import { Component, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ClassService, AppClass } from '../../services/class.service';
import { UserService, AppUser } from '../../services/user.service';
import { DialogService } from '../../services/dialog.service';
import { ToastService } from '../../services/toast.service';

@Component({
  selector: 'app-classes',
  imports: [FormsModule],
  templateUrl: './classes.html',
})
export class Classes implements OnInit {
  private service = inject(ClassService);
  private userService = inject(UserService);
  private dialog = inject(DialogService);
  private toast = inject(ToastService);

  classes = signal<AppClass[]>([]);
  allStudents = signal<AppUser[]>([]); // danh sách user role=Student để chọn
  error = signal<string>('');

  // form tạo/sửa (ẩn/hiện)
  showForm = signal<boolean>(false);
  form: AppClass = { name: '', description: '', is_public: false };
  editingId = signal<number | null>(null);

  // modal chi tiết lớp (tab Sinh viên / Đề đã giao)
  selectedClass = signal<AppClass | null>(null);
  detailTab = signal<'students' | 'exams'>('students');
  classStudents = signal<AppUser[]>([]);
  classExams = signal<any[]>([]);
  studentSearch = '';

  ngOnInit() {
    this.load();
    // lấy danh sách student (cần quyền Admin); nếu Teacher không gọi được thì bỏ qua
    this.userService.getAll().subscribe({
      next: (d) => this.allStudents.set((d ?? []).filter((u) => u.role === 'Student')),
      error: () => {},
    });
  }

  load() {
    this.service.getAll().subscribe({
      next: (d) => this.classes.set(d ?? []),
      error: () => this.error.set('Không tải được lớp.'),
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
      if (ok) this.service.remove(id).subscribe(() => { this.load(); this.closeDetail(); });
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
    this.loadStudents(c.id!);
    this.service.getExams(c.id!).subscribe((d) => this.classExams.set(d ?? []));
  }

  closeDetail() {
    this.selectedClass.set(null);
    this.classStudents.set([]);
    this.classExams.set([]);
  }

  loadStudents(classId: number) {
    this.service.getStudents(classId).subscribe((d) => this.classStudents.set(d ?? []));
  }

  // gõ để tìm sinh viên chưa có trong lớp (thay cho dropdown dài)
  studentSuggestions(): AppUser[] {
    const kw = this.studentSearch.trim().toLowerCase();
    if (!kw) return [];
    const inClass = new Set(this.classStudents().map((s) => s.id));
    return this.allStudents()
      .filter((u) => !inClass.has(u.id))
      .filter((u) => (u.username ?? '').toLowerCase().includes(kw) || (u.full_name ?? '').toLowerCase().includes(kw))
      .slice(0, 8);
  }

  addStudent(u: AppUser) {
    const c = this.selectedClass();
    if (!c || !u.id) return;
    this.service.addStudent(c.id!, u.id).subscribe({
      next: () => {
        this.toast.success(`Đã thêm ${u.full_name || u.username} vào lớp.`);
        this.studentSearch = '';
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
      this.service.removeStudent(c.id!, s.id!).subscribe(() => {
        this.loadStudents(c.id!);
        this.load();
      });
    });
  }

  examStatusLabel(s?: string): string {
    return s === 'published' ? 'Phát hành' : s === 'closed' ? 'Đã đóng' : 'Nháp';
  }
}
