import { Component, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ExamService, Exam } from '../../services/exam.service';
import { SubjectService, Subject } from '../../services/subject.service';
import { ClassService, AppClass } from '../../services/class.service';
import { QuestionService, Question } from '../../services/question.service';
import { ChapterService, Chapter } from '../../services/chapter.service';
import { ToastService } from '../../services/toast.service';
import { DialogService } from '../../services/dialog.service';
import { InfiniteScrollDirective } from '../../shared/infinite-scroll.directive';
import { Icon } from '../../shared/icon';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-exams',
  imports: [FormsModule, InfiniteScrollDirective, Icon, RouterLink],
  templateUrl: './exams.html',
})
export class Exams implements OnInit {
  private examService = inject(ExamService);
  private subjectService = inject(SubjectService);
  private classService = inject(ClassService);
  private questionService = inject(QuestionService);
  private chapterService = inject(ChapterService);
  private toast = inject(ToastService);
  private dialog = inject(DialogService);

  exams = signal<Exam[]>([]);
  subjects = signal<Subject[]>([]);
  subjectTotal = signal(0);
  subjectsLoading = signal(false);
  subjectPage = 1;
  classes = signal<AppClass[]>([]);
  classTotal = signal(0);
  classPage = 1;
  classesLoading = signal(false);
  error = signal<string>('');
  message = signal<string>('');
  editingId = signal<number | null>(null);

  // xem trước nội dung đề
  preview = signal<{ exam: Exam; questions: any[] } | null>(null);

  // khối để lọc môn
  levels = ['Đại học'];
  pickLevel = 'Đại học';

  // cấu hình đề
  form: Exam = this.empty();

  // nguồn câu hỏi
  file: File | null = null;
  fromExamId = 0;          // đề lấy thêm từ ngân hàng (0 = không)
  dragOver = signal(false);

  // ----- chọn câu hỏi từ ngân hàng câu hỏi -----
  pickerOpen = signal(false);
  pickerItems = signal<Question[]>([]);
  pickerTotal = signal(0);
  pickerLoading = signal(false);
  pickerChapters = signal<Chapter[]>([]);
  pickerChapter: 'all' | 'none' | number = 'all';
  pickerDifficulty = '';
  pickerKeyword = '';
  private pickerPage = 1;
  pickedIds = new Set<number>();      // id câu hỏi đã tick
  pickedPreview = new Map<number, string>(); // id -> nội dung (hiện danh sách đã chọn)

  // ----- ma trận đề (sinh tự động) -----
  createMode = signal<'manual' | 'matrix'>('manual');
  matrixRules = signal<{ chapter: 'any' | 'none' | number; difficulty: string; count: number; avail: number | null }[]>([
    { chapter: 'any', difficulty: 'any', count: 5, avail: null },
  ]);

  // khi sửa: giữ lại câu hỏi cũ
  private existingQuestionIds: number[] = [];
  selectedClassIds = new Set<number>();
  keyword = '';

  ngOnInit() {
    this.loadSubjects();
    // chỉ lấy lớp của mình + lớp dùng chung
    this.loadAssignableClasses();
    this.load();
  }

  loadAssignableClasses(reset = true) {
    if (this.classesLoading()) return;
    const page = reset ? 1 : this.classPage + 1;
    if (reset) { this.classes.set([]); this.classTotal.set(0); }
    this.classesLoading.set(true);
    this.classService.getAssignablePaged(page).subscribe({
      next: result => { this.classes.set(reset ? (result.items ?? []) : [...this.classes(), ...(result.items ?? [])]); this.classTotal.set(result.total ?? 0); this.classPage = page; this.classesLoading.set(false); },
      error: () => { this.error.set('Không tải được danh sách lớp học.'); this.classesLoading.set(false); },
    });
  }

  hasMoreAssignableClasses() { return this.classes().length < this.classTotal(); }

  empty(): Exam {
    return {
      subject_id: 0, title: '', description: '', duration: 30, pass_score: 5,
      shuffle: true, shuffle_answers: true, shuffle_mode: 'per_student',
      access_type: 'private', max_attempts: 0, status: 'draft',
    };
  }

  subjectsForLevel() {
    if (!this.pickLevel) return this.subjects();
    return this.subjects().filter((s) => s.level === this.pickLevel);
  }

  loadSubjects(reset = true) {
    if (this.subjectsLoading()) return;
    const page = reset ? 1 : this.subjectPage + 1;
    if (reset) { this.subjects.set([]); this.subjectTotal.set(0); }
    this.subjectsLoading.set(true);
    this.subjectService.getPaged(page, 12).subscribe({
      next: result => {
        this.subjects.set(reset ? (result.items ?? []) : [...this.subjects(), ...(result.items ?? [])]);
        this.subjectTotal.set(result.total ?? 0);
        this.subjectPage = page;
        this.subjectsLoading.set(false);
      },
      error: () => { this.error.set('Không tải được danh sách môn học.'); this.subjectsLoading.set(false); },
    });
  }

  hasMoreSubjects() { return this.subjects().length < this.subjectTotal(); }

  examTotal = signal<number>(0);
  private examPage = 1;
  examLoading = signal<boolean>(false);

  load() {
    this.examPage = 1; this.exams.set([]); this.examTotal.set(0); this.loadMoreRows();
  }
  search() { this.load(); }
  clearSearch() { this.keyword = ''; this.load(); }

  displayedExams(): Exam[] {
    return this.exams();
  }
  hasMoreRows(): boolean {
    return this.exams().length < this.examTotal();
  }
  loadMoreRows() {
    if (this.examLoading() || (this.examTotal() > 0 && !this.hasMoreRows())) return;
    this.examLoading.set(true);
    this.examService.getPaged(this.examPage, 12, this.keyword || undefined).subscribe({
      next: (data) => { this.exams.update((rows) => [...rows, ...(data.items ?? [])]); this.examTotal.set(data.total); this.examPage++; this.examLoading.set(false); },
      error: () => { this.error.set('Không tải được đề thi.'); this.examLoading.set(false); },
    });
  }

  // badge màu cho trạng thái / truy cập
  statusLabel(s?: string): string {
    return s === 'published' ? 'Công khai' : s === 'closed' ? 'Đã đóng' : 'Nháp';
  }
  accessLabel(a?: string): string {
    return a === 'public' ? 'Mọi người' : 'Theo lớp';
  }

  // tải file Excel mẫu để giáo viên điền câu hỏi theo đúng định dạng
  downloadTemplate() {
    this.questionService.downloadTemplate().subscribe({
      next: (blob) => {
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'mau-cau-hoi-de-thi.xlsx';
        a.click();
        URL.revokeObjectURL(url);
      },
      error: () => this.toast.error('Không tải được mẫu câu hỏi. Vui lòng thử lại.'),
    });
  }

  // ----- kéo thả file -----
  onFileChange(e: Event) {
    const input = e.target as HTMLInputElement;
    this.setImportFile(input.files?.[0] ?? null);
    if (!this.file) input.value = '';
  }
  onDrop(e: DragEvent) {
    e.preventDefault();
    this.dragOver.set(false);
    if (e.dataTransfer?.files?.length) this.setImportFile(e.dataTransfer.files[0]);
  }
  onDragOver(e: DragEvent) { e.preventDefault(); this.dragOver.set(true); }
  onDragLeave(e: DragEvent) { e.preventDefault(); this.dragOver.set(false); }
  clearFile() { this.file = null; }

  private setImportFile(file: File | null) {
    if (!file) { this.file = null; return; }
    const name = file.name.toLowerCase();
    if (!name.endsWith('.csv') && !name.endsWith('.xlsx')) {
      this.file = null;
      this.error.set('Chỉ hỗ trợ file .csv hoặc .xlsx');
      return;
    }
    if (file.size > 20 * 1024 * 1024) {
      this.file = null;
      this.error.set('File quá lớn (tối đa 20MB)');
      return;
    }
    this.error.set('');
    this.file = file;
  }

  toggleClass(id: number) {
    this.selectedClassIds.has(id) ? this.selectedClassIds.delete(id) : this.selectedClassIds.add(id);
  }

  // ===== Chọn câu hỏi từ ngân hàng =====
  // gọi khi đổi môn trong form: câu đã tick thuộc môn cũ -> bỏ hết
  onFormSubjectChange() {
    this.pickedIds.clear();
    this.pickedPreview.clear();
    this.pickerChapter = 'all';
    this.pickerItems.set([]);
    this.pickerTotal.set(0);
    if (this.form.subject_id) {
      this.chapterService.getBySubject(this.form.subject_id).subscribe((d) => this.pickerChapters.set(d ?? []));
      if (this.pickerOpen()) this.reloadPicker();
      if (this.createMode() === 'matrix') this.refreshAllAvail();
    } else {
      this.pickerChapters.set([]);
    }
  }

  togglePicker() {
    this.pickerOpen.update((v) => !v);
    if (this.pickerOpen() && this.form.subject_id && this.pickerItems().length === 0) this.reloadPicker();
  }

  reloadPicker() {
    if (!this.form.subject_id) { this.error.set('Chọn môn học trước khi chọn câu hỏi'); return; }
    this.pickerPage = 1;
    this.pickerItems.set([]);
    this.fetchPicker();
  }

  private fetchPicker() {
    this.pickerLoading.set(true);
    this.questionService.getPaged({
      subjectId: this.form.subject_id,
      keyword: this.pickerKeyword || undefined,
      chapter: this.pickerChapter === 'all' ? undefined : this.pickerChapter,
      difficulty: this.pickerDifficulty || undefined,
      status: 'active', // câu nháp không được vào đề
      page: this.pickerPage, limit: 10,
    }).subscribe({
      next: (res) => {
        this.pickerItems.update((cur) => [...cur, ...(res.items ?? [])]);
        this.pickerTotal.set(res.total);
        this.pickerLoading.set(false);
      },
      error: () => this.pickerLoading.set(false),
    });
  }

  pickerHasMore(): boolean { return this.pickerItems().length < this.pickerTotal(); }
  loadMorePicker() {
    if (this.pickerLoading() || !this.pickerHasMore()) return;
    this.pickerPage++;
    this.fetchPicker();
  }

  // ===== Ma trận đề =====
  setMode(m: 'manual' | 'matrix') { this.createMode.set(m); if (m === 'matrix') this.refreshAllAvail(); }

  addRule() {
    this.matrixRules.update((rs) => [...rs, { chapter: 'any' as const, difficulty: 'any', count: 5, avail: null }]);
    this.refreshAvail(this.matrixRules().length - 1);
  }
  removeRule(i: number) {
    this.matrixRules.update((rs) => rs.filter((_, idx) => idx !== i));
  }
  totalMatrixCount(): number {
    return this.matrixRules().reduce((sum, r) => sum + (Number(r.count) || 0), 0);
  }

  // đếm số câu khả dụng trong ngân hàng cho 1 dòng ma trận
  refreshAvail(i: number) {
    const r = this.matrixRules()[i];
    if (!r || !this.form.subject_id) return;
    this.questionService.getPaged({
      subjectId: this.form.subject_id,
      chapter: r.chapter === 'any' ? undefined : r.chapter,
      difficulty: r.difficulty === 'any' ? undefined : r.difficulty,
      status: 'active', page: 1, limit: 1,
    }).subscribe((res) => {
      this.matrixRules.update((rs) => rs.map((x, idx) => idx === i ? { ...x, avail: res.total } : x));
    });
  }
  refreshAllAvail() {
    for (let i = 0; i < this.matrixRules().length; i++) this.refreshAvail(i);
  }

  generateExam() {
    this.error.set('');
    if (!this.form.title.trim()) { this.error.set('Nhập tên đề thi'); return; }
    if (!this.form.subject_id) { this.error.set('Chọn môn học'); return; }
    const rules = this.matrixRules()
      .filter((r) => Number(r.count) > 0)
      .map((r) => ({ chapter: String(r.chapter), difficulty: r.difficulty, count: Number(r.count) }));
    if (rules.length === 0) { this.error.set('Ma trận cần ít nhất 1 dòng có số câu > 0'); return; }

    const payload = {
      ...this.form,
      rules,
      class_ids: Array.from(this.selectedClassIds),
    };
    this.examService.generate(payload).subscribe({
      next: (res) => {
        this.toast.success(`Đã sinh đề tự động với ${res.total} câu hỏi.`);
        this.cancel();
        this.load();
        if (res?.exam?.id) this.showPreview(res.exam.id);
      },
      error: (e) => this.toast.error(e?.error?.error ?? 'Sinh đề thất bại'),
    });
  }

  isPicked(id?: number): boolean { return !!id && this.pickedIds.has(id); }
  togglePick(q: Question) {
    if (!q.id) return;
    if (this.pickedIds.has(q.id)) {
      this.pickedIds.delete(q.id);
      this.pickedPreview.delete(q.id);
    } else {
      this.pickedIds.add(q.id);
      this.pickedPreview.set(q.id, q.content);
    }
  }
  unpick(id: number) { this.pickedIds.delete(id); this.pickedPreview.delete(id); }
  pickedList(): { id: number; content: string }[] {
    return Array.from(this.pickedIds).map((id) => ({ id, content: this.pickedPreview.get(id) ?? `Câu #${id}` }));
  }
  pickerChapterName(id?: number | null): string {
    if (!id) return '';
    return this.pickerChapters().find((c) => c.id === id)?.name ?? '';
  }

  // ===== TẠO đề (gộp file + đề ngân hàng) =====
  create() {
    this.error.set(''); this.message.set('');
    if (!this.form.title.trim()) { this.error.set('Nhập tên đề thi'); return; }
    if (!this.form.subject_id) { this.error.set('Chọn môn học'); return; }
    if (!this.file && !this.fromExamId && this.pickedIds.size === 0) {
      this.error.set('Cần ít nhất 1 nguồn câu hỏi: chọn từ ngân hàng câu hỏi, kéo file vào, hoặc lấy từ đề có sẵn');
      return;
    }

    const fd = new FormData();
    fd.append('title', this.form.title);
    fd.append('subject_id', String(this.form.subject_id));
    fd.append('duration', String(this.form.duration ?? 30));
    fd.append('pass_score', String(this.form.pass_score ?? 5));
    fd.append('shuffle', String(!!this.form.shuffle));
    fd.append('shuffle_answers', String(!!this.form.shuffle_answers));
    fd.append('shuffle_mode', this.form.shuffle_mode ?? 'per_student');
    fd.append('access_type', this.form.access_type ?? 'private');
    fd.append('max_attempts', String(this.form.max_attempts ?? 0));
    fd.append('status', this.form.status ?? 'draft');
    fd.append('from_exam_id', String(this.fromExamId || 0));
    fd.append('question_ids', Array.from(this.pickedIds).join(',')); // câu chọn từ ngân hàng
    fd.append('class_ids', Array.from(this.selectedClassIds).join(','));
    if (this.file) fd.append('file', this.file);

    this.examService.build(fd).subscribe({
      next: (res) => {
        this.toast.success(`Tạo đề thành công với ${res.total} câu hỏi.`);
        this.cancel();
        this.load();
        if (res?.exam?.id) this.showPreview(res.exam.id); // tự mở xem đề
      },
      error: (e) => this.toast.error(e?.error?.error ?? 'Tạo đề thất bại'),
    });
  }

  // ===== Xem trước nội dung đề =====
  showPreview(id: number) {
    this.examService.preview(id).subscribe({
      next: (d) => {
        this.preview.set(d);
        window.scrollTo({ top: 0, behavior: 'smooth' });
      },
      error: () => {
        this.error.set('Không tải được nội dung đề.');
        this.toast.error('Không tải được nội dung đề.');
      },
    });
  }
  closePreview() { this.preview.set(null); }

  printExam(id: number) {
    const popup = window.open('', '_blank');
    if (!popup) {
      this.toast.error('Trinh duyet dang chan cua so in. Hay cho phep pop-up va thu lai.');
      return;
    }
    popup.opener = null;
    popup.document.title = 'Dang tao ban in...';
    this.examService.printPaper(id).subscribe({
      next: (paper) => {
        const url = URL.createObjectURL(paper);
        popup.location.replace(url);
        popup.addEventListener('load', () => { popup.focus(); popup.print(); }, { once: true });
        setTimeout(() => URL.revokeObjectURL(url), 60000);
      },
      error: (e) => {
        popup.close();
        this.toast.error(e?.error?.error ?? 'Không tạo được bản in đề thi.');
      },
    });
  }

  downloadPrintPaper(id: number, title: string) {
    this.examService.printPaper(id).subscribe({
      next: (paper) => {
        const url = URL.createObjectURL(paper);
        const link = document.createElement('a');
        link.href = url;
        link.download = `${this.printFileName(title)}.html`;
        document.body.appendChild(link);
        link.click();
        link.remove();
        setTimeout(() => URL.revokeObjectURL(url), 1000);
        this.toast.success('Da tai ban in. Mo file HTML de in hoac luu PDF.');
      },
      error: (e) => this.toast.error(e?.error?.error ?? 'Không tải được bản in đề thi.'),
    });
  }

  private printFileName(title: string) {
    const base = title.normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .replace(/[đĐ]/g, character => character === 'đ' ? 'd' : 'D')
      .replace(/[^a-zA-Z0-9._-]+/g, '-')
      .replace(/^-+|-+$/g, '');
    return base || `de-thi-${Date.now()}`;
  }

  // ===== SỬA đề (cấu hình + thay đổi được danh sách câu hỏi) =====
  edit(id: number) {
    this.examService.getOne(id).subscribe({
      next: (d) => {
        this.editingId.set(id);
        this.form = { ...d.exam };
        this.existingQuestionIds = d.question_ids ?? [];
        this.selectedClassIds = new Set(d.class_ids ?? []);

        // nạp câu hỏi hiện có của đề vào danh sách đã tick
        this.pickedIds = new Set(this.existingQuestionIds);
        this.pickedPreview.clear();
        this.examService.preview(id).subscribe({
          next: (preview) => {
            for (const question of preview.questions ?? []) this.pickedPreview.set(question.id, question.content);
          },
          error: () => this.toast.error('Không tải được danh sách câu hỏi của đề.'),
        });
        if (this.form.subject_id) {
          this.chapterService.getBySubject(this.form.subject_id).subscribe((c) => this.pickerChapters.set(c ?? []));
        }
        this.pickerItems.set([]);
        this.pickerTotal.set(0);
        window.scrollTo({ top: 0, behavior: 'smooth' });
      },
      error: () => this.toast.error('Không tải được cấu hình đề thi.'),
    });
  }

  saveEdit() {
    this.error.set('');
    if (this.pickedIds.size === 0) { this.error.set('Đề thi cần ít nhất 1 câu hỏi'); return; }
    const payload = {
      ...this.form,
      question_ids: Array.from(this.pickedIds),
      class_ids: Array.from(this.selectedClassIds),
    };
    this.examService.update(this.editingId()!, payload).subscribe({
      next: () => { this.toast.success('Đã cập nhật đề thi.'); this.cancel(); this.load(); },
      error: (e) => {
        const message = e?.error?.error ?? 'Lưu thất bại';
        this.error.set(message);
        this.toast.error(message);
      },
    });
  }

  cancel() {
    this.editingId.set(null);
    this.form = this.empty();
    this.file = null;
    this.fromExamId = 0;
    this.existingQuestionIds = [];
    this.selectedClassIds.clear();
    this.pickedIds.clear();
    this.pickedPreview.clear();
    this.pickerOpen.set(false);
    this.pickerItems.set([]);
    this.pickerTotal.set(0);
    this.pickerChapter = 'all';
    this.pickerDifficulty = '';
    this.pickerKeyword = '';
    this.createMode.set('manual');
    this.matrixRules.set([{ chapter: 'any', difficulty: 'any', count: 5, avail: null }]);
  }

  remove(id?: number) {
    if (!id) return;
    this.dialog.confirm('Xóa đề thi', 'Bạn chắc chắn muốn xóa đề thi này?').then((ok) => {
      if (!ok) return;
      this.examService.remove(id).subscribe({
        next: () => {
          this.load();
          this.toast.success('Đã xóa đề thi.');
        },
        error: (error) => this.toast.error(error?.error?.error ?? 'Không thể xóa đề thi.'),
      });
    });
  }

  subjectName(id: number): string {
    return this.subjects().find((s) => s.id === id)?.name ?? '?';
  }
}
