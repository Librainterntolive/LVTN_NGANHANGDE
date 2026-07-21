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
        this.startTimer(d.exam.duration);
      },
      error: (e) => this.error.set(e?.error?.error ?? 'Không tải được đề'),
    });
  }

  startTimer(durationMinutes: number) {
    if (!durationMinutes || durationMinutes <= 0) return; // không giới hạn
    this.remaining.set(durationMinutes * 60);
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
    if (this.result()) return; // tránh nộp 2 lần
    if (this.timer) clearInterval(this.timer);
    const answers = Object.entries(this.selected).map(([qid, aid]) => ({
      question_id: Number(qid),
      selected_answer_id: Number(aid),
    }));
    this.service.submit(this.examId, answers).subscribe({
      next: (r) => { this.result.set(r); this.layout.fullscreen.set(false); },
      error: (e) => this.error.set(e?.error?.error ?? 'Nộp bài thất bại'),
    });
  }

  ngOnDestroy() {
    if (this.timer) clearInterval(this.timer);
    this.layout.fullscreen.set(false); // trả lại sidebar khi rời trang
  }
}
