import { Component, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { QuestionService, Question, ImportResult } from '../../services/question.service';
import { SubjectService, Subject } from '../../services/subject.service';
import { ChapterService, Chapter } from '../../services/chapter.service';
import { AuthService } from '../../services/auth.service';
import { DialogService } from '../../services/dialog.service';
import { InfiniteScrollDirective } from '../../shared/infinite-scroll.directive';

@Component({
  selector: 'app-questions',
  imports: [FormsModule, InfiniteScrollDirective],
  templateUrl: './questions.html',
})
export class Questions implements OnInit {
  private qService = inject(QuestionService);
  private subjectService = inject(SubjectService);
  private chapterService = inject(ChapterService);
  private auth = inject(AuthService);
  private dialog = inject(DialogService);

  subjects = signal<Subject[]>([]);
  items = signal<Question[]>([]);
  total = signal<number>(0);
  error = signal<string>('');

  myId = this.auth.currentUser()?.id ?? 0;

  // bộ lọc
  subjectId = 0;          // 0 = chưa chọn môn
  keyword = '';
  owner = signal<'all' | 'mine' | 'others'>('all');

  // chương/chủ đề
  chapters = signal<Chapter[]>([]);          // chương của môn đang xem
  formChapters = signal<Chapter[]>([]);      // chương của môn đang chọn trong form
  chapterFilter = signal<'all' | 'none' | number>('all');
  showChapterMgr = signal<boolean>(false);   // panel quản lý chương
  newChapterName = '';
  editChapterId = signal<number | null>(null);
  editChapterName = '';

  // phân trang
  private page = 1;
  private readonly limit = 12;
  loading = signal<boolean>(false);
  hasMore = signal<boolean>(false);

  // form thêm/sửa
  editingId = signal<number | null>(null);
  showForm = signal<boolean>(false);
  correctIndex = 0;
  form: Question = this.emptyForm();

  // import từ file (gộp từ trang Import cũ)
  showImport = signal<boolean>(false);
  importFile: File | null = null;
  importResult = signal<ImportResult | null>(null);

  ngOnInit() {
    this.subjectService.getAll().subscribe({ next: (d) => this.subjects.set(d ?? []) });
  }

  emptyForm(): Question {
    return {
      subject_id: 0, chapter_id: null, content: '', question_type: 'single',
      difficulty: 'medium', status: 'active',
      answers: [{ content: '', is_correct: true }, { content: '', is_correct: false }],
    };
  }

  ownerParam(): string {
    return this.owner() === 'mine' ? 'me' : this.owner() === 'others' ? 'others' : '';
  }

  // gọi khi đổi môn: reset bộ lọc chương + tải danh sách chương của môn mới
  onSubjectChange() {
    this.chapterFilter.set('all');
    this.loadChapters();
    this.reload();
  }

  loadChapters() {
    if (!this.subjectId) { this.chapters.set([]); return; }
    this.chapterService.getBySubject(this.subjectId).subscribe({
      next: (d) => this.chapters.set(d ?? []),
    });
  }

  // gọi khi đổi tab / tìm kiếm / đổi chương -> tải lại từ đầu
  reload() {
    if (!this.subjectId) { this.items.set([]); this.total.set(0); this.hasMore.set(false); return; }
    this.page = 1;
    this.items.set([]);
    this.fetch();
  }

  private fetch() {
    if (this.loading()) return;
    this.loading.set(true);
    const ch = this.chapterFilter();
    this.qService.getPaged({
      subjectId: this.subjectId, keyword: this.keyword || undefined,
      owner: this.ownerParam() || undefined,
      chapter: ch === 'all' ? undefined : ch,
      page: this.page, limit: this.limit,
    }).subscribe({
      next: (res) => {
        this.items.update((cur) => [...cur, ...(res.items ?? [])]);
        this.total.set(res.total);
        this.hasMore.set(this.items().length < res.total);
        this.loading.set(false);
      },
      error: () => { this.error.set('Không tải được câu hỏi.'); this.loading.set(false); },
    });
  }

  loadMore() {
    if (this.loading() || !this.hasMore()) return;
    this.page++;
    this.fetch();
  }

  setOwner(o: 'all' | 'mine' | 'others') { this.owner.set(o); this.reload(); }
  search() { this.reload(); }
  clearSearch() { this.keyword = ''; this.reload(); }

  isMine(q: Question): boolean { return q.created_by === this.myId; }
  isUsed(q: Question): boolean { return (q.used_count ?? 0) > 0; }

  chapterName(id?: number | null): string {
    if (!id) return '';
    return this.chapters().find((c) => c.id === id)?.name ?? '';
  }

  // ----- chương/chủ đề -----
  setChapter(c: 'all' | 'none' | number) { this.chapterFilter.set(c); this.reload(); }

  toggleChapterMgr() { this.showChapterMgr.update((v) => !v); }

  addChapter() {
    const name = this.newChapterName.trim();
    if (!name || !this.subjectId) return;
    this.chapterService.create({ subject_id: this.subjectId, name, order_index: this.chapters().length + 1 }).subscribe({
      next: () => { this.newChapterName = ''; this.loadChapters(); },
      error: (e) => this.error.set(e?.error?.error ?? 'Không thêm được chương'),
    });
  }

  startEditChapter(ch: Chapter) {
    this.editChapterId.set(ch.id!);
    this.editChapterName = ch.name;
  }

  saveChapter(ch: Chapter) {
    const name = this.editChapterName.trim();
    if (!name) return;
    this.chapterService.update(ch.id!, { ...ch, name }).subscribe({
      next: () => { this.editChapterId.set(null); this.loadChapters(); this.reload(); },
      error: (e) => this.error.set(e?.error?.error ?? 'Không sửa được chương'),
    });
  }

  cancelEditChapter() { this.editChapterId.set(null); }

  deleteChapter(ch: Chapter) {
    this.dialog.confirm('Xóa chương', `Xóa chương "${ch.name}"? Câu hỏi trong chương sẽ trở về "Chưa phân chương" (không bị xóa).`).then((ok) => {
      if (!ok) return;
      this.chapterService.remove(ch.id!).subscribe({
        next: () => {
          if (this.chapterFilter() === ch.id) this.chapterFilter.set('all');
          this.loadChapters(); this.reload();
        },
        error: (e) => this.error.set(e?.error?.error ?? 'Không xóa được chương'),
      });
    });
  }

  // chương cho dropdown trong form (theo môn đang chọn ở form)
  loadFormChapters() {
    if (!this.form.subject_id) { this.formChapters.set([]); return; }
    if (this.form.subject_id === this.subjectId) { this.formChapters.set(this.chapters()); return; }
    this.chapterService.getBySubject(this.form.subject_id).subscribe({
      next: (d) => this.formChapters.set(d ?? []),
    });
  }

  onFormSubjectChange() {
    this.form.chapter_id = null; // môn đổi thì chương cũ không còn hợp lệ
    this.loadFormChapters();
  }

  // ----- import file -----
  openImport() { this.showForm.set(false); this.showImport.set(true); }
  closeImport() { this.showImport.set(false); this.importFile = null; this.importResult.set(null); }

  onImportFileChange(e: Event) {
    const input = e.target as HTMLInputElement;
    this.importFile = input.files?.[0] ?? null;
  }

  doImport() {
    this.error.set('');
    this.importResult.set(null);
    if (!this.importFile) { this.error.set('Hãy chọn file CSV hoặc Excel'); return; }
    const name = this.importFile.name.toLowerCase();
    if (!name.endsWith('.csv') && !name.endsWith('.xlsx')) {
      this.error.set('Chỉ hỗ trợ file .csv hoặc .xlsx'); return;
    }
    if (this.importFile.size > 50 * 1024 * 1024) {
      this.error.set('File quá lớn (tối đa 50MB)'); return;
    }
    this.qService.importFile(this.importFile).subscribe({
      next: (r) => {
        this.importResult.set(r);
        // Danh sách chỉ hiện khi đã chọn môn. Sau khi import thì tự mở môn vừa
        // nhận câu hỏi, nếu không người dùng nhìn vào màn hình trống và tưởng
        // import hỏng (rồi bấm lại nhiều lần, tạo ra câu trùng).
        const first = r.subject_ids?.[0];
        if (first && this.subjectId !== first) {
          this.subjectId = first;
          this.chapterFilter.set('all');
        }
        this.loadChapters();
        this.reload();
      },
      error: (e) => this.error.set(e?.error?.error ?? 'Import thất bại'),
    });
  }

  // tên các môn vừa nhận câu hỏi (hiện trong thông báo kết quả import)
  importedSubjectNames(): string {
    const ids = this.importResult()?.subject_ids ?? [];
    const names = ids
      .map((id) => this.subjects().find((s) => s.id === id)?.name)
      .filter((n): n is string => !!n);
    return names.join(', ');
  }

  downloadTemplate() {
    this.qService.downloadTemplate().subscribe((blob) => {
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = 'mau-import-cau-hoi.xlsx';
      a.click();
      URL.revokeObjectURL(url);
    });
  }

  // ----- form -----
  openAdd() {
    this.closeImport(); this.cancelEdit(); this.showForm.set(true);
    if (!this.form.subject_id && this.subjectId) this.form.subject_id = this.subjectId;
    this.loadFormChapters();
  }

  // nhân bản: mở form thêm mới với nội dung sao chép từ câu hỏi gốc
  duplicate(q: Question) {
    this.closeImport();
    this.editingId.set(null);
    this.showForm.set(true);
    this.form = {
      subject_id: q.subject_id, chapter_id: q.chapter_id ?? null,
      content: q.content, question_type: q.question_type ?? 'single',
      difficulty: q.difficulty ?? 'medium', status: 'draft', // bản sao bắt đầu ở trạng thái nháp
      answers: q.answers.map((a) => ({ content: a.content, is_correct: a.is_correct })),
    };
    this.correctIndex = this.form.answers.findIndex((a) => a.is_correct);
    if (this.correctIndex < 0) this.correctIndex = 0;
    this.loadFormChapters();
  }
  addAnswerRow() { this.form.answers.push({ content: '', is_correct: false }); }
  removeAnswerRow(i: number) {
    if (this.form.answers.length <= 2) return;
    this.form.answers.splice(i, 1);
    if (this.correctIndex >= this.form.answers.length) this.correctIndex = 0;
  }

  save() {
    this.error.set('');
    if (!this.form.subject_id) { this.error.set('Vui lòng chọn môn học'); return; }
    this.form.answers.forEach((a, i) => (a.is_correct = i === this.correctIndex));
    const req = this.editingId()
      ? this.qService.update(this.editingId()!, this.form)
      : this.qService.create(this.form);
    req.subscribe({
      next: () => {
        const savedSubject = this.form.subject_id;
        this.cancelEdit();
        if (this.subjectId !== savedSubject) { this.subjectId = savedSubject; this.onSubjectChange(); }
        else { this.loadChapters(); this.reload(); }
      },
      error: (e) => this.error.set(e?.error?.error ?? 'Lưu thất bại'),
    });
  }

  edit(q: Question) {
    if (this.isUsed(q)) return; // đã dùng trong đề thi -> khóa sửa
    this.editingId.set(q.id!);
    this.showForm.set(true);
    this.form = {
      subject_id: q.subject_id, chapter_id: q.chapter_id ?? null, content: q.content,
      question_type: q.question_type ?? 'single', difficulty: q.difficulty ?? 'medium',
      status: q.status ?? 'active',
      answers: q.answers.map((a) => ({ content: a.content, is_correct: a.is_correct })),
    };
    this.correctIndex = this.form.answers.findIndex((a) => a.is_correct);
    if (this.correctIndex < 0) this.correctIndex = 0;
    this.loadFormChapters();
  }

  cancelEdit() {
    this.editingId.set(null);
    this.showForm.set(false);
    this.form = this.emptyForm();
    this.correctIndex = 0;
  }

  remove(id?: number) {
    if (!id) return;
    this.dialog.confirm('Xóa câu hỏi', 'Bạn chắc chắn muốn xóa câu hỏi này?').then((ok) => {
      if (!ok) return;
      this.qService.remove(id).subscribe({
        next: () => { this.loadChapters(); this.reload(); },
        error: (e) => this.error.set(e?.error?.error ?? 'Không xóa được câu hỏi'),
      });
    });
  }

  subjectName(id: number): string {
    return this.subjects().find((s) => s.id === id)?.name ?? '?';
  }
}
