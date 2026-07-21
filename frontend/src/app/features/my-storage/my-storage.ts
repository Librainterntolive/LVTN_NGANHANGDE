import { Component, OnInit, inject, signal, computed } from '@angular/core';
import { RouterLink } from '@angular/router';
import { DecimalPipe } from '@angular/common';
import { FolderService, Folder, SavedExam, MyStats, WrongQuestion } from '../../services/folder.service';
import { SubjectService, Subject } from '../../services/subject.service';
import { ExamService, Exam } from '../../services/exam.service';
import { AuthService } from '../../services/auth.service';
import { ToastService } from '../../services/toast.service';
import { DialogService } from '../../services/dialog.service';

interface TreeRow { folder: Folder; depth: number; hasChildren: boolean; }

@Component({
  selector: 'app-my-storage',
  imports: [RouterLink, DecimalPipe],
  templateUrl: './my-storage.html',
})
export class MyStorage implements OnInit {
  private folderService = inject(FolderService);
  private subjectService = inject(SubjectService);
  private examService = inject(ExamService);
  private auth = inject(AuthService);
  private toast = inject(ToastService);
  private dialog = inject(DialogService);

  folders = signal<Folder[]>([]);
  expanded = signal<Set<number>>(new Set());
  selected = signal<Folder | null>(null);
  folderExams = signal<SavedExam[]>([]);
  examBank = signal<Exam[]>([]);
  subjects = signal<Subject[]>([]);
  savedIds = signal<Set<number>>(new Set());

  // thống kê góc học tập
  stats = signal<MyStats | null>(null);

  // sổ tay câu sai
  wrongQuestions = signal<WrongQuestion[]>([]);
  showNotebook = signal<boolean>(false);

  // chế độ luyện lại câu sai
  practiceSet = signal<any[]>([]);
  practicing = signal<boolean>(false);
  practiceSelected: Record<number, number> = {};
  practiceResults = signal<any[] | null>(null);

  // lọc/tìm ngân hàng đề
  bankKeyword = signal<string>('');
  bankSubject = signal<number>(0);

  isTeacher = computed(() => {
    const r = this.auth.getRole();
    return r === 'Teacher' || r === 'Admin';
  });

  ngOnInit() {
    this.subjectService.getAll().subscribe((d) => this.subjects.set(d ?? []));
    this.loadFolders();
    this.folderService.getExamBank().subscribe((d) => this.examBank.set(d ?? []));
    this.reloadStats();
    this.folderService.getSavedExamIds().subscribe((ids) => this.savedIds.set(new Set(ids ?? [])));
  }

  reloadStats() {
    this.folderService.getMyStats().subscribe((s) => this.stats.set(s));
    this.folderService.getWrongQuestions().subscribe((d) => this.wrongQuestions.set(d ?? []));
  }

  loadFolders() {
    this.folderService.getFolders().subscribe((d) => this.folders.set(d ?? []));
  }

  // ----- dựng cây phẳng theo độ sâu (tôn trọng trạng thái mở/đóng) -----
  treeRows(): TreeRow[] {
    const out: TreeRow[] = [];
    const walk = (parentId: number | null, depth: number) => {
      const children = this.folders()
        .filter((f) => (f.parent_id ?? null) === parentId)
        .sort((a, b) => a.name.localeCompare(b.name));
      for (const f of children) {
        const hasChildren = this.folders().some((c) => c.parent_id === f.id);
        out.push({ folder: f, depth, hasChildren });
        if (this.expanded().has(f.id)) walk(f.id, depth + 1);
      }
    };
    walk(null, 0);
    return out;
  }

  toggle(id: number) {
    const s = new Set(this.expanded());
    s.has(id) ? s.delete(id) : s.add(id);
    this.expanded.set(s);
  }

  select(f: Folder) {
    this.selected.set(f);
    this.folderService.getExams(f.id).subscribe((d) => this.folderExams.set(d ?? []));
  }

  // ----- thao tác thư mục -----
  newRoot() {
    this.dialog.prompt('Tạo thư mục mới', '').then((name) => {
      if (!name) return;
      this.folderService.create(name, null).subscribe(() => this.loadFolders());
    });
  }
  newSub(parent: Folder) {
    this.dialog.prompt(`Tạo thư mục con trong "${parent.name}"`, '').then((name) => {
      if (!name) return;
      this.folderService.create(name, parent.id).subscribe(() => {
        const s = new Set(this.expanded()); s.add(parent.id); this.expanded.set(s);
        this.loadFolders();
      });
    });
  }
  rename(f: Folder) {
    this.dialog.prompt('Đổi tên thư mục', f.name).then((name) => {
      if (!name) return;
      this.folderService.rename(f.id, name).subscribe(() => this.loadFolders());
    });
  }
  del(f: Folder) {
    this.dialog.confirm('Xóa thư mục', `Xóa thư mục "${f.name}" và toàn bộ thư mục con?`).then((ok) => {
      if (!ok) return;
      this.folderService.remove(f.id).subscribe(() => {
        if (this.selected()?.id === f.id) { this.selected.set(null); this.folderExams.set([]); }
        this.loadFolders();
      });
    });
  }

  // ----- lưu / bỏ đề -----
  saveToFolder(examId: number) {
    const f = this.selected();
    if (!f) { this.toast.error('Hãy chọn 1 thư mục bên trái trước.'); return; }
    this.folderService.addExam(f.id, examId).subscribe(() => {
      this.toast.success('Đã lưu đề vào thư mục: ' + f.name);
      this.savedIds.update((s) => new Set(s).add(examId));
      this.select(f);
      this.reloadStats();
    });
  }
  removeFromFolder(examId: number) {
    const f = this.selected();
    if (!f) return;
    this.folderService.removeExam(f.id, examId).subscribe(() => {
      this.select(f);
      this.reloadStats();
    });
  }
  isSaved(examId?: number): boolean {
    return !!examId && this.savedIds().has(examId);
  }

  // ----- ghi chú cá nhân -----
  editNote(e: SavedExam) {
    const f = this.selected();
    if (!f) return;
    this.dialog.prompt('Ghi chú cho đề (để trống để xóa)', e.note ?? '').then((note) => {
      if (note === null) return;
      this.folderService.setNote(f.id, e.exam_id, note).subscribe(() => {
        this.toast.success('Đã lưu ghi chú');
        this.select(f);
      });
    });
  }

  // ----- nhân bản đề (GV) -----
  cloneExam(examId: number) {
    this.examService.clone(examId).subscribe({
      next: () => this.toast.success('Đã nhân bản về "Đề thi" của bạn (bản nháp).'),
      error: (err) => this.toast.error(err?.error?.error ?? 'Nhân bản thất bại'),
    });
  }

  // ----- lọc ngân hàng đề -----
  filteredBank(): Exam[] {
    const kw = this.bankKeyword().trim().toLowerCase();
    const subj = this.bankSubject();
    return this.examBank().filter((e) => {
      if (subj && e.subject_id !== subj) return false;
      if (kw && !(e.title ?? '').toLowerCase().includes(kw)) return false;
      return true;
    });
  }

  // ===== Sổ tay câu sai =====
  toggleNotebook() { this.showNotebook.update((v) => !v); }

  startPractice() {
    this.folderService.getPracticeSet().subscribe((set) => {
      if (!set || set.length === 0) {
        this.toast.success('Tuyệt vời! Bạn không còn câu sai nào để luyện.');
        return;
      }
      this.practiceSet.set(set);
      this.practiceSelected = {};
      this.practiceResults.set(null);
      this.practicing.set(true);
    });
  }

  submitPractice() {
    const answers = Object.entries(this.practiceSelected).map(([qid, aid]) => ({
      question_id: Number(qid),
      selected_answer_id: Number(aid),
    }));
    if (answers.length === 0) { this.toast.error('Hãy trả lời ít nhất 1 câu.'); return; }
    this.folderService.submitPractice(answers).subscribe({
      next: (r) => {
        this.practiceResults.set(r.results ?? []);
        this.reloadStats();
      },
      error: (e) => this.toast.error(e?.error?.error ?? 'Chấm bài thất bại'),
    });
  }

  practiceCorrectCount(): number {
    return (this.practiceResults() ?? []).filter((r) => r.is_correct).length;
  }
  masteredCount(): number {
    return (this.practiceResults() ?? []).filter((r) => r.mastered).length;
  }
  resultFor(qid: number): any {
    return (this.practiceResults() ?? []).find((r) => r.question_id === qid);
  }
  closePractice() {
    this.practicing.set(false);
    this.practiceSet.set([]);
    this.practiceResults.set(null);
  }

  subjectName(id: number): string {
    return this.subjects().find((s) => s.id === id)?.name ?? '?';
  }
  difficultyLabel(d: string): string {
    return d === 'easy' ? 'Dễ' : d === 'hard' ? 'Khó' : 'TB';
  }
}
