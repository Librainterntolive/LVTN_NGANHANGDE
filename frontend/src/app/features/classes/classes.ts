import { Component, OnDestroy, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ClassService, AppClass } from '../../services/class.service';
import { AppUser } from '../../services/user.service';
import { DialogService } from '../../services/dialog.service';
import { ToastService } from '../../services/toast.service';
import { RouterLink } from '@angular/router';
import { Paginator } from '../../shared/paginator';
import { Icon } from '../../shared/icon';

@Component({
  selector: 'app-classes',
  imports: [FormsModule, RouterLink, Paginator, Icon],
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
  page = signal(1);
  limit = signal(10);

  // form tạo/sửa (ẩn/hiện)
  showForm = signal<boolean>(false);
  form: AppClass = { name: '', description: '', is_public: false };
  editingId = signal<number | null>(null);

  // modal chi tiết lớp (tab Sinh viên / Đề đã giao)
  selectedClass = signal<AppClass | null>(null);
  detailTab = signal<'students' | 'exams'>('students');
  classStudents = signal<AppUser[]>([]);
  studentTotal = signal(0);
  studentPage = signal(1);
  studentLimit = signal(10);
  studentsLoading = signal(false);
  classExams = signal<any[]>([]);
  classExamTotal = signal(0);
  classExamPage = signal(1);
  classExamLimit = signal(10);
  classExamsLoading = signal(false);
  studentSearch = '';
  private studentSearchTimer?: ReturnType<typeof setTimeout>;

  ngOnInit() {
    this.load();
  }

  ngOnDestroy() {
    if (this.studentSearchTimer) clearTimeout(this.studentSearchTimer);
  }

  load() {
    if (this.loading()) return;
    this.loading.set(true);
    this.service.getPaged(this.page(), this.limit()).subscribe({
      next: (data) => {
        this.classes.set(data.items ?? []);
        this.total.set(data.total ?? 0);
        this.loading.set(false);
        // Xóa lớp có thể làm trang hiện tại vượt quá trang cuối.
        const lastPage = Math.max(1, Math.ceil(this.total() / this.limit()));
        if (this.page() > lastPage) this.goToPage(lastPage);
      },
      error: () => { this.loading.set(false); this.error.set('Không tải được danh sách lớp học.'); },
    });
  }

  goToPage(page: number) { this.page.set(page); this.load(); }
  setLimit(limit: number) { this.limit.set(limit); this.page.set(1); this.load(); }


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
    this.studentPage.set(1);
    this.classExamPage.set(1);
    this.loadStudents(c.id!);
    this.loadClassExams(c.id!);
  }

  closeDetail() {
    this.selectedClass.set(null);
    this.classStudents.set([]);
    this.classExams.set([]);
    this.classExamTotal.set(0);
  }

  loadStudents(classId: number) {
    if (this.studentsLoading()) return;
    this.studentsLoading.set(true);
    this.service.getStudentsPaged(classId, this.studentPage(), this.studentLimit()).subscribe({
      next: data => {
        this.classStudents.set(data.items ?? []);
        this.studentTotal.set(data.total ?? 0);
        this.studentsLoading.set(false);
      },
      error: () => this.studentsLoading.set(false),
    });
  }

  goToStudentPage(page: number) {
    this.studentPage.set(page);
    this.loadStudents(this.selectedClass()!.id!);
  }

  setStudentLimit(limit: number) {
    this.studentLimit.set(limit);
    this.studentPage.set(1);
    this.loadStudents(this.selectedClass()!.id!);
  }


  loadClassExams(classId: number) {
    if (this.classExamsLoading()) return;
    this.classExamsLoading.set(true);
    this.service.getExamsPaged(classId, this.classExamPage(), this.classExamLimit()).subscribe({
      next: (data) => {
        this.classExams.set(data.items ?? []);
        this.classExamTotal.set(data.total ?? 0);
        this.classExamsLoading.set(false);
      },
      error: () => this.classExamsLoading.set(false),
    });
  }

  goToClassExamPage(page: number) {
    this.classExamPage.set(page);
    this.loadClassExams(this.selectedClass()!.id!);
  }

  setClassExamLimit(limit: number) {
    this.classExamLimit.set(limit);
    this.classExamPage.set(1);
    this.loadClassExams(this.selectedClass()!.id!);
  }


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
        this.loadStudents(c.id!);
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
          this.loadStudents(c.id!);
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
