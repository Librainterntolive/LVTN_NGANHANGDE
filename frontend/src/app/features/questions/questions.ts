import { Component, OnInit, inject, signal } from '@angular/core';
import { DecimalPipe } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { QuestionService, Question, ImportResult } from '../../services/question.service';
import { SubjectService, Subject } from '../../services/subject.service';
import { ChapterService, Chapter } from '../../services/chapter.service';
import { AuthService } from '../../services/auth.service';
import { DialogService } from '../../services/dialog.service';
import { Paginator } from '../../shared/paginator';
import { SearchableSelect } from '../../shared/searchable-select';
import { SourceService, Source } from '../../services/source.service';
import { ToastService } from '../../services/toast.service';

@Component({
  selector: 'app-questions',
  imports: [FormsModule, Paginator, SearchableSelect, DecimalPipe],
  templateUrl: './questions.html',
})
export class Questions implements OnInit {
  private qService = inject(QuestionService);
  private subjectService = inject(SubjectService);
  private chapterService = inject(ChapterService);
  private auth = inject(AuthService);
  private dialog = inject(DialogService);
  private sourceService = inject(SourceService);
  private toast = inject(ToastService);

  subjects = signal<Subject[]>([]);
  subjectTotal = signal<number>(0);
  subjectLoading = signal<boolean>(false);
  items = signal<Question[]>([]);
  total = signal<number>(0);
  error = signal<string>('');
  sources = signal<Source[]>([]);
  sourceTotal = signal<number>(0);
  sourceLoading = signal<boolean>(false);
  sourceMessage = signal<string>('');
  showSourceForm = signal<boolean>(false);
  sourceForm: Source = { title: '', publisher: '', url: '', published_year: '', license_note: '' };

  myId = this.auth.currentUser()?.id ?? 0;

  // bộ lọc
  subjectId = 0;          // 0 = chưa chọn môn
  keyword = '';
  owner = signal<'all' | 'mine' | 'others'>('all');
  reviewFilter = signal<string>('');

  // chương/chủ đề
  chapters = signal<Chapter[]>([]);          // chương của môn đang xem
  formChapters = signal<Chapter[]>([]);      // chương của môn đang chọn trong form
  chapterFilter = signal<'all' | 'none' | number>('all');
  showChapterMgr = signal<boolean>(false);   // panel quản lý chương
  newChapterName = '';
  editChapterId = signal<number | null>(null);
  editChapterName = '';

  // phân trang
  page = signal(1);
  limit = signal(10);
  private subjectPage = 1;
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
    this.loadSources();
  }

  // Combobox học phần và nguồn gọi thẳng API theo từ khóa: gõ tới đâu tìm tới đó,
  // nên số lượng bản ghi không còn ảnh hưởng tới thao tác chọn.
  fetchSubjects = (keyword: string, page: number, limit: number) =>
    this.subjectService.getPaged(page, limit, keyword);

  fetchSources = (keyword: string, page: number, limit: number) =>
    this.sourceService.getPaged(page, limit, keyword);

  // Nguồn chưa xác thực vẫn hiện nhưng ghi rõ trạng thái; backend chặn không cho
  // dùng nguồn chưa duyệt nên ở đây chỉ cần cho người soạn thấy tình trạng.
  sourceLabel = (source: Source) => {
    const status = source.verification_status === 'verified' ? 'Đã xác thực'
      : source.verification_status === 'rejected' ? 'Từ chối' : 'Chờ xác thực';
    return `[${status}] ${source.title} — ${source.publisher || source.url}`;
  };

  // Tên hiển thị khi form đang giữ sẵn một id (ví dụ mở form sửa câu hỏi).
  subjectName(id?: number | null): string {
    if (!id) return '';
    return this.subjectNames()[id] ?? '';
  }

  sourceTitle(id?: number | null): string {
    if (!id) return '';
    return this.sources().find(s => s.id === id)?.title ?? '';
  }

  private subjectNames = signal<Record<number, string>>({});

  private ensureSubjectName(id?: number | null) {
    if (!id || this.subjectNames()[id]) return;
    this.subjectService.getOne(id).subscribe({
      next: subject => this.subjectNames.update(map => ({ ...map, [id]: subject.name })),
      error: () => {},
    });
  }

  emptyForm(): Question {
    return {
      subject_id: 0, chapter_id: null, content: '', question_type: 'single',
		 difficulty: 'medium', status: 'draft', review_status: 'draft', source_id: null, source_reference: '',
      content_original: '', original_language: '', translation_status: 'original', translation_refs: '',
      answers: [{ content: '', is_correct: true }, { content: '', is_correct: false }],
    };
  }

  // tên tiếng Việt của ngôn ngữ bản gốc, dùng cho nhãn "Xem nguyên bản"
  languageName(code: string): string {
    const names: Record<string, string> = {
      en: 'tiếng Anh', fr: 'tiếng Pháp', zh: 'tiếng Trung',
      ja: 'tiếng Nhật', ru: 'tiếng Nga', vi: 'tiếng Việt',
    };
    return names[code] ?? code;
  }

  ownerParam(): string {
    return this.owner() === 'mine' ? 'me' : this.owner() === 'others' ? 'others' : '';
  }

	 get isAdmin(): boolean { return this.auth.currentUser()?.role === 'Admin'; }

	 private sourcePage = 1;
	 loadSources(reset = true) {
		if (this.sourceLoading()) return;
		if (reset) { this.sourcePage = 1; this.sources.set([]); this.sourceTotal.set(0); }
		this.sourceLoading.set(true);
		this.sourceService.getPaged(this.sourcePage, 12).subscribe({
			next: (res) => { this.sources.update(items => [...items, ...(res.items ?? [])]); this.sourceTotal.set(res.total ?? 0); this.sourcePage++; this.sourceLoading.set(false); },
			error: () => { this.error.set('Không tải được danh sách nguồn tài liệu.'); this.sourceLoading.set(false); },
		});
	 }
	 hasMoreSources() { return this.sources().length < this.sourceTotal(); }
	 loadMoreSources() { if (!this.sourceLoading() && this.hasMoreSources()) this.loadSources(false); }

	 toggleSourceForm() { this.showSourceForm.update((value) => !value); }

	 createSource() {
		this.error.set('');
		this.sourceMessage.set('');
		this.sourceService.create(this.sourceForm).subscribe({
			next: (source) => {
				this.sources.update((items) => [source, ...items]);
				this.sourceTotal.update((count) => count + 1);
				this.sourceForm = { title: '', publisher: '', url: '', published_year: '', license_note: '' };
				this.showSourceForm.set(false);
				this.sourceMessage.set('Đã gửi nguồn để xác thực. Chỉ có thể chọn nguồn này sau khi quản trị viên duyệt.');
				this.toast.success('Đã gửi nguồn tài liệu để xác thực.');
			},
			error: (e) => {
				const message = e?.error?.error ?? 'Không thêm được nguồn tài liệu.';
				this.error.set(message);
				this.toast.error(message);
			},
		});
	 }

	 pendingSources(): Source[] { return this.sources().filter(source => source.verification_status === 'pending'); }
	 reviewSource(source: Source, status: 'verified' | 'rejected') {
		this.sourceService.review(source.id!, status).subscribe({
			next: updated => {
				this.sources.update(items => items.map(item => item.id === updated.id ? updated : item));
				this.toast.success(status === 'verified' ? 'Đã xác thực nguồn tài liệu.' : 'Đã từ chối nguồn tài liệu.');
			},
			error: error => {
				const message = error?.error?.error ?? 'Không cập nhật được nguồn tài liệu.';
				this.error.set(message);
				this.toast.error(message);
			},
		});
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
    if (!this.subjectId) { this.items.set([]); this.total.set(0); return; }
    this.page.set(1);
    this.fetch();
  }

  goToPage(page: number) { this.page.set(page); this.fetch(); }
  setLimit(limit: number) { this.limit.set(limit); this.page.set(1); this.fetch(); }

  private fetch() {
    if (this.loading()) return;
    this.loading.set(true);
    const ch = this.chapterFilter();
    this.qService.getPaged({
      subjectId: this.subjectId, keyword: this.keyword || undefined,
      owner: this.ownerParam() || undefined,
      chapter: ch === 'all' ? undefined : ch,
		 reviewStatus: this.reviewFilter() || undefined,
      page: this.page(), limit: this.limit(),
    }).subscribe({
      next: (res) => {
        this.items.set(res.items ?? []);
        this.total.set(res.total);
        this.loading.set(false);
        // Duyệt hoặc xóa câu hỏi có thể làm trang hiện tại vượt quá trang cuối.
        const lastPage = Math.max(1, Math.ceil(this.total() / this.limit()));
        if (this.page() > lastPage) this.goToPage(lastPage);
      },
      error: () => { this.error.set('Không tải được câu hỏi.'); this.loading.set(false); },
    });
  }

  setOwner(o: 'all' | 'mine' | 'others') { this.owner.set(o); this.reload(); }
	 setReviewFilter(status: string) { this.reviewFilter.set(status); this.reload(); }
  search() { this.reload(); }
  clearSearch() { this.keyword = ''; this.reload(); }

  isMine(q: Question): boolean { return q.created_by === this.myId; }
  isUsed(q: Question): boolean { return (q.used_count ?? 0) > 0; }
	 isPending(q: Question): boolean { return q.review_status === 'pending'; }

	 approve(q: Question) {
		this.qService.review(q.id!, 'approved').subscribe({
			next: () => { this.toast.success('Đã duyệt câu hỏi.'); this.reload(); },
			error: (e) => { const message = e?.error?.error ?? 'Không duyệt được câu hỏi.'; this.error.set(message); this.toast.error(message); },
		});
	 }

	 reject(q: Question) {
		this.qService.review(q.id!, 'rejected').subscribe({
			next: () => { this.toast.success('Đã từ chối câu hỏi.'); this.reload(); },
			error: (e) => { const message = e?.error?.error ?? 'Không từ chối được câu hỏi.'; this.error.set(message); this.toast.error(message); },
		});
	 }

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
      next: () => { this.newChapterName = ''; this.loadChapters(); this.toast.success('Đã thêm chương / chủ đề.'); },
      error: (e) => { const message = e?.error?.error ?? 'Không thêm được chương'; this.error.set(message); this.toast.error(message); },
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
      next: () => { this.editChapterId.set(null); this.loadChapters(); this.reload(); this.toast.success('Đã cập nhật chương / chủ đề.'); },
      error: (e) => { const message = e?.error?.error ?? 'Không sửa được chương'; this.error.set(message); this.toast.error(message); },
    });
  }

  cancelEditChapter() { this.editChapterId.set(null); }

  deleteChapter(ch: Chapter) {
    this.dialog.confirm('Xóa chương', `Xóa chương "${ch.name}"? Câu hỏi trong chương sẽ trở về "Chưa phân chương" (không bị xóa).`).then((ok) => {
      if (!ok) return;
      this.chapterService.remove(ch.id!).subscribe({
        next: () => {
          if (this.chapterFilter() === ch.id) this.chapterFilter.set('all');
          this.loadChapters(); this.reload(); this.toast.success('Đã xóa chương / chủ đề.');
        },
        error: (e) => { const message = e?.error?.error ?? 'Không xóa được chương'; this.error.set(message); this.toast.error(message); },
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
    const file = input.files?.[0] ?? null;
    if (!file) { this.importFile = null; return; }
    const name = file.name.toLowerCase();
    if (!name.endsWith('.csv') && !name.endsWith('.xlsx')) {
      this.importFile = null;
      input.value = '';
      this.error.set('Chỉ hỗ trợ file .csv hoặc .xlsx');
      return;
    }
    if (file.size > 20 * 1024 * 1024) {
      this.importFile = null;
      input.value = '';
      this.error.set('File quá lớn (tối đa 20MB)');
      return;
    }
    this.error.set('');
    this.importFile = file;
  }

  doImport() {
    this.error.set('');
    this.importResult.set(null);
    if (!this.importFile) { this.error.set('Hãy chọn file CSV hoặc Excel'); return; }
    const name = this.importFile.name.toLowerCase();
    if (!name.endsWith('.csv') && !name.endsWith('.xlsx')) {
      this.error.set('Chỉ hỗ trợ file .csv hoặc .xlsx'); return;
    }
    if (this.importFile.size > 20 * 1024 * 1024) {
      this.error.set('File quá lớn (tối đa 20MB)'); return;
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
			this.toast.success(`Đã import ${r.imported} câu hỏi. Các câu hỏi sẽ chờ duyệt trước khi dùng cho đề công khai.`);
      },
      error: (e) => { const message = e?.error?.error ?? 'Import thất bại'; this.error.set(message); this.toast.error(message); },
    });
  }

  // tên các môn vừa nhận câu hỏi (hiện trong thông báo kết quả import)
  importedSubjectNames(): string {
    const ids = this.importResult()?.subject_ids ?? [];
    ids.forEach(id => this.ensureSubjectName(id));
    const names = ids
      .map((id) => this.subjectNames()[id])
      .filter((n): n is string => !!n);
    return names.join(', ');
  }

  downloadTemplate() {
    this.qService.downloadTemplate().subscribe({
      next: (blob) => {
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'mau-import-cau-hoi.xlsx';
        a.click();
        URL.revokeObjectURL(url);
      },
      error: () => this.toast.error('Không tải được mẫu import. Vui lòng thử lại.'),
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
		 source_id: q.source_id ?? null, source_reference: q.source_reference ?? '', review_status: 'draft',
      content_original: q.content_original ?? '',
      original_language: q.original_language ?? '',
      translation_status: q.translation_status ?? 'original',
      translation_refs: q.translation_refs ?? '',
      answers: q.answers.map((a) => ({ content: a.content, content_original: a.content_original ?? '', is_correct: a.is_correct })),
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

  save(submitForReview = false) {
    this.error.set('');
    if (!this.form.subject_id) { this.error.set('Vui lòng chọn môn học'); return; }
	if (!this.form.source_id || !this.form.source_reference?.trim()) {
		this.error.set('Vui lòng chọn nguồn tài liệu và ghi vị trí tham chiếu');
		return;
	}
	this.form.submit_for_review = submitForReview;
	this.form.answers.forEach((a, i) => (a.is_correct = i === this.correctIndex));
    const editingId = this.editingId();
    const req = editingId
      ? this.qService.update(editingId, this.form)
      : this.qService.create(this.form);
    req.subscribe({
      next: () => {
        const savedSubject = this.form.subject_id;
        this.cancelEdit();
        if (this.subjectId !== savedSubject) { this.subjectId = savedSubject; this.onSubjectChange(); }
        else { this.loadChapters(); this.reload(); }
			this.toast.success(submitForReview ? 'Đã gửi câu hỏi để duyệt.' : editingId ? 'Đã cập nhật câu hỏi.' : 'Đã lưu câu hỏi nháp.');
      },
      error: (e) => { const message = e?.error?.error ?? 'Lưu thất bại'; this.error.set(message); this.toast.error(message); },
    });
  }

  edit(q: Question) {
    if (this.isUsed(q)) return; // đã dùng trong đề thi -> khóa sửa
    this.editingId.set(q.id!);
    this.showForm.set(true);
    this.ensureSubjectName(q.subject_id);
    this.form = {
      subject_id: q.subject_id, chapter_id: q.chapter_id ?? null, content: q.content,
      question_type: q.question_type ?? 'single', difficulty: q.difficulty ?? 'medium',
      status: q.status ?? 'active',
      source_id: q.source_id ?? null,
      source_reference: q.source_reference ?? '',
      review_status: q.review_status ?? 'draft',
      content_original: q.content_original ?? '',
      original_language: q.original_language ?? '',
      translation_status: q.translation_status ?? 'original',
      translation_refs: q.translation_refs ?? '',
      answers: q.answers.map((a) => ({ content: a.content, content_original: a.content_original ?? '', is_correct: a.is_correct })),
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
        next: () => { this.loadChapters(); this.reload(); this.toast.success('Đã xóa câu hỏi.'); },
        error: (e) => { const message = e?.error?.error ?? 'Không xóa được câu hỏi'; this.error.set(message); this.toast.error(message); },
      });
    });
  }

}
