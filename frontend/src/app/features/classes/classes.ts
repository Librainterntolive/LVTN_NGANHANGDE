import { Component, OnDestroy, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ClassService, AppClass } from '../../services/class.service';
import { AppUser } from '../../services/user.service';
import { DialogService } from '../../services/dialog.service';
import { ToastService } from '../../services/toast.service';
import { RouterLink } from '@angular/router';
import { InfiniteScrollDirective } from '../../shared/infinite-scroll.directive';
import { Icon } from '../../shared/icon';

@Component({
  selector: 'app-classes',
  imports: [FormsModule, RouterLink, InfiniteScrollDirective, Icon],
  templateUrl: './classes.html',
})
export class Classes implements OnInit, OnDestroy {
  private service = inject(ClassService);
  private dialog = inject(DialogService);
  private toast = inject(ToastService);

  classes = signal<AppClass[]>([]);
  matchedStudents = signal<AppUser[]>([]);
  error = signal<string>('');
  total = signal<number>(0);
  loading = signal<boolean>(false);
  private page = 1;

  // form tạo/sửa (ẩn/hiện)
  showForm = signal<boolean>(false);
  form: AppClass = { name: '', description: '', is_public: false };
  editingId = signal<number | null>(null);

  // modal chi tiết lớp (tab Sinh viên / Đề đã giao)
  selectedClass = signal<AppClass | null>(null);
  detailTab = signal<'students' | 'exams'>('students');
  classStudents = signal<AppUser[]>([]);
  studentTotal = signal(0);
  studentPage = 1;
  studentsLoading = signal(false);
  classExams = signal<any[]>([]);
  classExamTotal = signal(0);
  classExamPage = 1;
  classExamsLoading = signal(false);
  studentSearch = '';
  private studentSearchTimer?: ReturnType<typeof setTimeout>;

  ngOnInit() {
    this.load();
  }

  ngOnDestroy() {
    if (this.studentSearchTimer) clearTimeout(this.studentSearchTimer);
  }

  load() { this.page = 1; this.classes.set([]); this.total.set(0); this.loadMore(); }

  loadMore() {
    if (this.loading() || (this.total() > 0 && this.classes().length >= this.total())) return;
    this.loading.set(true);
    this.service.getPaged(this.page, 12).subscribe({
      next: (data) => { this.classes.update((rows) => [...rows, ...(data.items ?? [])]); this.total.set(data.total); this.page++; this.loading.set(false); },
      error: () => { this.error.set('Không tải được lớp.'); this.loading.set(false); },
    });
  }

  // ----- form tạo/sửa -----
  openAdd() {
    this.editingId.set(null);
    this.form = { name: '', description: '', is_public: false };
    this.showForm.set(true);
  }

  save() {
    if (!this.form.name.trim()) { this.error.set('Nhập tên lớp'); return; }
    this.error.set('');
    const req = this.editingId()
      ? this.service.update(this.editingId()!, this.form)
      : this.service.create(this.form);
    req.subscribe({
      next: () => {
        this.toast.success(this.editingId() ? 'Đã cập nhật lớp.' : 'Đã tạo lớp mới.');
        this.cancel();
        this.load();
      },
      error: (e) => this.error.set(e?.error?.error ?? 'Lưu thất bại'),
    });
  }

  edit(c: AppClass) {
    this.editingId.set(c.id!);
    this.form = { ...c };
    this.showForm.set(true);
  }

  cancel() {
    this.editingId.set(null);
    this.form = { name: '', description: '', is_public: false };
    this.showForm.set(false);
  }

  remove(id?: number) {
    if (!id) return;
    this.dialog.confirm('Xóa lớp', 'Xóa lớp sẽ gỡ toàn bộ sinh viên khỏi lớp. Bạn chắc chắn?').then((ok) => {
      if (!ok) return;
      this.service.remove(id).subscribe({
        next: () => {
          this.load();
          this.toast.success('Đã xóa lớp học.');
        },
        error: (error) => this.error.set(error?.error?.error ?? 'Không thể xóa lớp học.'),
      });
    });
  }

  // ----- copy mã lớp -----
  copyCode(c: AppClass) {
    if (!c.code) return;
    navigator.clipboard.writeText(c.code).then(
      () => this.toast.success(`Đã sao chép mã lớp ${c.code}`),
      () => this.toast.error('Không sao chép được, hãy chép tay: ' + c.code),
    );
  }

  // ----- modal chi tiết lớp -----
  openDetail(c: AppClass) {
    this.selectedClass.set(c);
    this.detailTab.set('students');
    this.studentSearch = '';
    this.matchedStudents.set([]);
    this.loadStudents(c.id!);
    this.loadClassExams(c.id!);
  }

  closeDetail() {
    this.selectedClass.set(null);
    this.classStudents.set([]);
    this.classExams.set([]);
    this.classExamTotal.set(0);
  }

  loadStudents(classId: number, reset = true) {
    if (this.studentsLoading()) return;
    const page = reset ? 1 : this.studentPage + 1;
    this.studentsLoading.set(true);
    this.service.getStudentsPaged(classId, page).subscribe({
      next: data => { this.classStudents.set(reset ? (data.items ?? []) : [...this.classStudents(), ...(data.items ?? [])]); this.studentTotal.set(data.total ?? 0); this.studentPage = page; this.studentsLoading.set(false); },
      error: () => this.studentsLoading.set(false),
    });
  }

  hasMoreStudents() { return this.classStudents().length < this.studentTotal(); }

  loadClassExams(classId: number, reset = true) {
    if (this.classExamsLoading()) return;
    const page = reset ? 1 : this.classExamPage + 1;
    if (reset) { this.classExams.set([]); this.classExamTotal.set(0); }
    this.classExamsLoading.set(true);
    this.service.getExamsPaged(classId, page, 12).subscribe({
      next: (data) => {
        this.classExams.set(reset ? (data.items ?? []) : [...this.classExams(), ...(data.items ?? [])]);
        this.classExamTotal.set(data.total ?? 0);
        this.classExamPage = page;
        this.classExamsLoading.set(false);
      },
      error: () => this.classExamsLoading.set(false),
    });
  }

  hasMoreClassExams() { return this.classExams().length < this.classExamTotal(); }

  searchStudents() {
    const keyword = this.studentSearch.trim();
    if (this.studentSearchTimer) clearTimeout(this.studentSearchTimer);
    if (keyword.length < 2) { this.matchedStudents.set([]); return; }
    this.studentSearchTimer = setTimeout(() => {
      if (keyword !== this.studentSearch.trim()) return;
      this.service.searchStudents(keyword).subscribe({ next: rows => this.matchedStudents.set(rows ?? []), error: () => this.matchedStudents.set([]) });
    }, 250);
  }

  // Server chỉ trả tối đa 8 sinh viên khớp, không tải toàn bộ người dùng.
  studentSuggestions(): AppUser[] {
    const inClass = new Set(this.classStudents().map((s) => s.id));
    return this.matchedStudents().filter((u) => !inClass.has(u.id));
  }

  addStudent(u: AppUser) {
    const c = this.selectedClass();
    if (!c || !u.id) return;
    this.service.addStudent(c.id!, u.id).subscribe({
      next: () => {
        this.toast.success(`Đã thêm ${u.full_name || u.username} vào lớp.`);
        this.studentSearch = '';
        this.matchedStudents.set([]);
        this.loadStudents(c.id!, true);
        this.load(); // cập nhật số SV trên card
      },
      error: (e) => this.error.set(e?.error?.error ?? 'Thêm thất bại'),
    });
  }

  removeStudent(s: AppUser) {
    const c = this.selectedClass();
    if (!c || !s.id) return;
    this.dialog.confirm('Xóa khỏi lớp', `Xóa ${s.full_name || s.username} khỏi lớp "${c.name}"?`).then((ok) => {
      if (!ok) return;
      this.service.removeStudent(c.id!, s.id!).subscribe({
        next: () => {
          this.loadStudents(c.id!, true);
          this.load();
          this.toast.success(`Đã xóa ${s.full_name || s.username} khỏi lớp.`);
        },
        error: (e) => this.error.set(e?.error?.error ?? 'Không thể xóa sinh viên.'),
      });
    });
  }

  examStatusLabel(s?: string): string {
    return s === 'published' ? 'Phát hành' : s === 'closed' ? 'Đã đóng' : 'Nháp';
  }
}
