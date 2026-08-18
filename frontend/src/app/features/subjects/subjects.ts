import { Component, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { SubjectService, Subject } from '../../services/subject.service';
import { AuthService } from '../../services/auth.service';
import { DialogService } from '../../services/dialog.service';
import { Paginator } from '../../shared/paginator';
import { Icon } from '../../shared/icon';

@Component({
  selector: 'app-subjects',
  imports: [FormsModule, RouterLink, Paginator, Icon],
  templateUrl: './subjects.html',
})
export class Subjects implements OnInit {
  private service = inject(SubjectService);
  private auth = inject(AuthService);
  private dialog = inject(DialogService);

  subjects = signal<Subject[]>([]);
  total = signal(0);
  loading = signal(false);
  error = signal('');
  keyword = '';
  page = signal(1);
  limit = signal(10);

  form: Subject = this.empty();
  editingId = signal<number | null>(null);
  showForm = signal(false);

  empty(): Subject { return { name: '', level: 'Đại học', description: '' }; }

  isStaff(): boolean {
    const role = this.auth.getRole();
    return role === 'Admin' || role === 'Teacher';
  }

  ngOnInit() { this.load(); }

  load() {
    if (this.loading()) return;
    this.loading.set(true);
    this.error.set('');
    this.service.getPaged(this.page(), this.limit(), this.keyword).subscribe({
      next: (result) => {
        this.subjects.set(result.items ?? []);
        this.total.set(result.total ?? 0);
        this.loading.set(false);
        // Xóa bớt dữ liệu có thể làm trang hiện tại vượt quá trang cuối.
        const lastPage = Math.max(1, Math.ceil(this.total() / this.limit()));
        if (this.page() > lastPage) this.goToPage(lastPage);
      },
      error: () => {
        this.error.set('Không gọi được API. Hãy kiểm tra Backend đang chạy.');
        this.loading.set(false);
      },
    });
  }

  // Đổi bộ lọc thì quay về trang 1, nếu không sẽ rơi vào trang trống.
  search() { this.page.set(1); this.load(); }

  goToPage(page: number) { this.page.set(page); this.load(); }

  setLimit(limit: number) { this.limit.set(limit); this.page.set(1); this.load(); }

  // Lấy từ bảng màu chung để đổi theo theme sáng/tối, không đặt mã màu cứng.
  levelColor(): string { return 'var(--hero-bg)'; }

  openAdd() { this.editingId.set(null); this.form = this.empty(); this.showForm.set(true); }
  edit(subject: Subject) { this.editingId.set(subject.id!); this.form = { ...subject }; this.showForm.set(true); }
  cancel() { this.showForm.set(false); this.editingId.set(null); this.form = this.empty(); }

  save() {
    if (!this.form.name.trim()) { this.error.set('Nhập tên học phần trước khi lưu.'); return; }
    this.error.set('');
    const request = this.editingId()
      ? this.service.update(this.editingId()!, this.form)
      : this.service.create(this.form);
    request.subscribe({
      next: () => { this.cancel(); this.load(); },
      error: () => this.error.set('Không thể lưu học phần.'),
    });
  }

  remove(id?: number) {
    if (!id) return;
    this.dialog.confirm('Xóa học phần', 'Bạn chắc chắn muốn xóa học phần này?').then((confirmed) => {
      if (!confirmed) return;
      this.service.remove(id).subscribe({
        next: () => this.load(),
        error: () => this.error.set('Không thể xóa vì học phần đang có câu hỏi hoặc đề thi.'),
      });
    });
  }
}
