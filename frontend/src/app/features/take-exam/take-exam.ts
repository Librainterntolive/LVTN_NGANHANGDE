import { Component, OnInit, OnDestroy, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { DecimalPipe } from '@angular/common';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { StudentService, TakeExamData, SubmitResult } from '../../services/student.service';
import { AuthService } from '../../services/auth.service';
import { LayoutService } from '../../services/layout.service';

@Component({
  selector: 'app-take-exam',
  imports: [FormsModule, RouterLink, DecimalPipe],
  templateUrl: './take-exam.html',
})
export class TakeExam implements OnInit, OnDestroy {
  private route = inject(ActivatedRoute);
  private service = inject(StudentService);
  protected auth = inject(AuthService);
  private layout = inject(LayoutService);

  examId = 0;
  data = signal<TakeExamData | null>(null);
  error = signal<string>('');
  result = signal<SubmitResult | null>(null);
  submitting = signal<boolean>(false);
  draftRestored = signal<boolean>(false);

  // modal xác nhận nộp khi còn câu chưa làm
  showConfirm = signal<boolean>(false);
  unansweredCount = signal<number>(0);

  // đồng hồ đếm ngược (giây)
  remaining = signal<number>(0);
  private timer: any = null;

  // map question_id -> selected_answer_id
  selected: Record<number, number> = {};

  ngOnInit() {
    this.layout.fullscreen.set(true); // ẩn sidebar/topbar khi thi
    this.examId = Number(this.route.snapshot.paramMap.get('id'));
    this.service.take(this.examId).subscribe({
      next: (d) => {
        this.data.set(d);
        this.restoreDraft(d);
        this.startTimer(d);
      },
      error: (e) => this.error.set(e?.error?.error ?? 'Không tải được đề'),
    });
  }

  // Số giây còn lại do SERVER cấp (tính từ giờ bắt đầu lưu trong CSDL).
  // Nhờ vậy tải lại trang không làm mới đồng hồ. Chỉ khi server không cấp
  // phiên (khách làm thử) mới tạm tính theo duration của đề.
  startTimer(d: TakeExamData) {
    const fromServer = d.remaining_seconds;
    if (fromServer === -1) return; // đề không giới hạn thời gian

    const seconds = fromServer ?? (d.exam.duration ?? 0) * 60;
    if (seconds <= 0) return;

    this.remaining.set(seconds);
    this.timer = setInterval(() => {
      const left = this.remaining() - 1;
      this.remaining.set(left);
      if (left <= 0) {
        clearInterval(this.timer);
        this.submit(); // hết giờ tự nộp
      }
    }, 1000);
  }

  // định dạng mm:ss
  formatTime(): string {
    const s = this.remaining();
    const m = Math.floor(s / 60);
    const sec = s % 60;
    return `${m}:${sec < 10 ? '0' : ''}${sec}`;
  }

  // đã trả lời câu này chưa
  isAnswered(qid: number): boolean {
    return !!this.selected[qid];
  }

  saveDraft() {
    const key = this.draftKey();
    if (!key || this.result()) return;
    try {
      localStorage.setItem(key, JSON.stringify({ saved_at: Date.now(), selected: this.selected }));
    } catch {}
  }

  // số câu đã làm
  answeredCount(): number {
    const d = this.data();
    if (!d) return 0;
    return d.questions.filter((q) => this.isAnswered(q.id)).length;
  }

  // nhảy tới câu hỏi thứ index
  goTo(index: number) {
    const el = document.getElementById('q-' + index);
    if (el) el.scrollIntoView({ behavior: 'smooth', block: 'center' });
  }

  // bấm nút Nộp: nếu còn câu chưa làm -> mở modal xác nhận (popup đẹp trong app)
  submitWithConfirm() {
    const d = this.data();
    if (!d) return;
    const unanswered = d.questions.length - this.answeredCount();
    if (unanswered > 0) {
      this.unansweredCount.set(unanswered);
      this.showConfirm.set(true);
      return;
    }
    this.submit();
  }
  confirmSubmit() { this.showConfirm.set(false); this.submit(); }
  cancelSubmit() { this.showConfirm.set(false); }

  submit() {
    if (this.result() || this.submitting()) return; // tránh nộp 2 lần
    this.error.set('');
    this.submitting.set(true);
    const answers = Object.entries(this.selected).map(([qid, aid]) => ({
      question_id: Number(qid),
      selected_answer_id: Number(aid),
    }));
    this.service.submit(this.examId, answers).subscribe({
      next: (result) => this.finishSubmission(result),
      error: (error) => this.recoverSubmissionAfterNetworkError(error),
    });
  }

  private finishSubmission(result: SubmitResult) {
    if (this.timer) clearInterval(this.timer);
    this.clearDraft();
    this.result.set(result);
    this.submitting.set(false);
    this.layout.fullscreen.set(false);
  }

  private recoverSubmissionAfterNetworkError(error: any) {
    const submissionId = this.data()?.submission_id;
    if (!this.auth.isLoggedIn() || !submissionId) {
      this.submitting.set(false);
      this.error.set(error?.error?.error ?? 'Không thể nộp bài. Kiểm tra kết nối rồi thử lại.');
      return;
    }

    this.service.getSubmissionResult(submissionId).subscribe({
      next: (result) => this.finishSubmission(result),
      error: () => {
        this.submitting.set(false);
        this.error.set('Kết nối bị gián đoạn. Bài chưa được xác nhận; hãy kiểm tra mạng và bấm nộp lại.');
      },
    });
  }

  private draftKey(): string | null {
    const submissionId = this.data()?.submission_id;
    return submissionId ? `quiz-exam-draft-${submissionId}` : null;
  }

  private restoreDraft(data: TakeExamData) {
    const key = this.draftKey();
    if (!key) return;
    try {
      const raw = localStorage.getItem(key);
      if (!raw) return;
      const draft = JSON.parse(raw) as { saved_at?: number; selected?: Record<string, number> };
      if (!draft.saved_at || Date.now() - draft.saved_at > 24 * 60 * 60 * 1000 || !draft.selected) {
        localStorage.removeItem(key);
        return;
      }
      const validAnswers = new Map(data.questions.map((question) => [question.id, new Set(question.answers.map((answer) => answer.id))]));
      const restored: Record<number, number> = {};
      for (const [questionId, answerId] of Object.entries(draft.selected)) {
        const id = Number(questionId);
        const answer = Number(answerId);
        if (validAnswers.get(id)?.has(answer)) restored[id] = answer;
      }
      this.selected = restored;
      this.draftRestored.set(Object.keys(restored).length > 0);
    } catch {
      localStorage.removeItem(key);
    }
  }

  private clearDraft() {
    const key = this.draftKey();
    if (!key) return;
    try { localStorage.removeItem(key); } catch {}
  }

  ngOnDestroy() {
    if (this.timer) clearInterval(this.timer);
    this.layout.fullscreen.set(false); // trả lại sidebar khi rời trang
  }
}
