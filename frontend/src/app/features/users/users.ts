import { Component, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { DatePipe } from '@angular/common';
import { UserService, AppUser, PasswordResetRequest } from '../../services/user.service';
import { DialogService } from '../../services/dialog.service';
import { Paginator } from '../../shared/paginator';
import { ToastService } from '../../services/toast.service';
import { Icon } from '../../shared/icon';

@Component({
  selector: 'app-users',
  imports: [FormsModule, DatePipe, Paginator, Icon],
  templateUrl: './users.html',
})
export class Users implements OnInit {
  private service = inject(UserService);
  private dialog = inject(DialogService);
  private toast = inject(ToastService);

  users = signal<AppUser[]>([]);
  total = signal<number>(0);
  loading = signal<boolean>(false);
  keyword = '';
  page = signal(1);
  limit = signal(10);
  error = signal<string>('');
  editingId = signal<number | null>(null);
  form: AppUser = this.empty();
  resetRequests = signal<PasswordResetRequest[]>([]);
  resetRequestTotal = signal(0);
  resetRequestPage = signal(1);
  resetRequestLimit = signal(5);
  resetRequestsLoading = signal(false);

  ngOnInit() { this.load(); this.loadResetRequests(); }

  empty(): AppUser {
    return { username: '', email: '', password: '', full_name: '', role: 'Student', status: 'active' };
  }

  load() {
    if (this.loading()) return;
    this.loading.set(true);
    this.service.getPaged(this.page(), this.limit(), this.keyword.trim()).subscribe({
      next: (data) => {
        this.users.set(data.items ?? []);
        this.total.set(data.total);
        this.loading.set(false);
        // Xóa tài khoản có thể làm trang hiện tại vượt quá trang cuối.
        const lastPage = Math.max(1, Math.ceil(this.total() / this.limit()));
        if (this.page() > lastPage) this.goToPage(lastPage);
      },
      error: () => { this.error.set('Không tải được (cần quyền Admin).'); this.loading.set(false); },
    });
  }
  // Đổi từ khóa thì quay về trang 1, nếu không sẽ rơi vào trang trống.
  search() { this.page.set(1); this.load(); }
  goToPage(page: number) { this.page.set(page); this.load(); }
  setLimit(limit: number) { this.limit.set(limit); this.page.set(1); this.load(); }
  loadResetRequests() {
    if (this.resetRequestsLoading()) return;
    this.resetRequestsLoading.set(true);
    this.service.getPasswordResetRequestsPaged(this.resetRequestPage(), this.resetRequestLimit()).subscribe({
      next: result => {
        this.resetRequests.set(result.items ?? []);
        this.resetRequestTotal.set(result.total ?? 0);
        this.resetRequestsLoading.set(false);
        const lastPage = Math.max(1, Math.ceil(this.resetRequestTotal() / this.resetRequestLimit()));
        if (this.resetRequestPage() > lastPage) this.goToResetPage(lastPage);
      },
      error: () => this.resetRequestsLoading.set(false),
    });
  }
  goToResetPage(page: number) { this.resetRequestPage.set(page); this.loadResetRequests(); }
  setResetLimit(limit: number) { this.resetRequestLimit.set(limit); this.resetRequestPage.set(1); this.loadResetRequests(); }
  approveReset(request: PasswordResetRequest) { this.dialog.confirm('Duyệt cấp lại mật khẩu', `Duyệt yêu cầu của tài khoản ID ${request.user_id}? Mật khẩu tạm sẽ gửi qua Gmail.`).then(ok=>{if(!ok)return;this.service.approvePasswordReset(request.id).subscribe({next:()=>{this.loadResetRequests();this.toast.success('Đã duyệt yêu cầu. Mật khẩu tạm được gửi qua Gmail.');},error:e=>this.error.set(e?.error?.error??'Không duyệt được yêu cầu')})}); }

  save() {
    this.error.set('');
    const req = this.editingId()
      ? this.service.update(this.editingId()!, this.form)
      : this.service.create(this.form);
    req.subscribe({
      next: () => { this.cancel(); this.load(); },
      error: (e) => this.error.set(e?.error?.error ?? 'Lưu thất bại'),
    });
  }

  edit(u: AppUser) {
    this.editingId.set(u.id!);
    this.form = { ...u, password: '' }; // để trống = không đổi mật khẩu
  }

  cancel() { this.editingId.set(null); this.form = this.empty(); }

  remove(id?: number) {
    if (!id) return;
    this.dialog.confirm('Xóa người dùng', 'Bạn chắc chắn muốn xóa người dùng này?').then((ok) => {
      if (!ok) return;
      this.service.remove(id).subscribe({
        next: () => { this.load(); this.toast.success('Đã xóa người dùng.'); },
        error: (error) => this.error.set(error?.error?.error ?? 'Không thể xóa người dùng.'),
      });
    });
  }

  // ----- tạm khóa / mở khóa -----
  lock(u: AppUser) {
    this.dialog.prompt(`Tạm khóa "${u.username}" — nhập lý do:`, '').then((reason) => {
      if (reason === null) return; // bấm Hủy
      this.service.update(u.id!, { ...u, password: '', status: 'locked', lock_reason: reason || 'Vi phạm quy định' })
        .subscribe({ next: () => { this.load(); this.toast.success(`Đã khóa tài khoản "${u.username}".`); }, error: error => this.error.set(error?.error?.error ?? 'Không thể khóa tài khoản.') });
    });
  }

  unlock(u: AppUser) {
    this.dialog.confirm('Mở khóa tài khoản', `Mở khóa cho "${u.username}"?`).then((ok) => {
      if (ok) this.service.update(u.id!, { ...u, password: '', status: 'active', lock_reason: '' })
        .subscribe({ next: () => { this.load(); this.toast.success(`Đã mở khóa tài khoản "${u.username}".`); }, error: error => this.error.set(error?.error?.error ?? 'Không thể mở khóa tài khoản.') });
    });
  }

  // ----- hiển thị role / status -----
  roleLabel(r: string): string {
    return r === 'Admin' ? 'Quản trị' : r === 'Teacher' ? 'Giảng viên' : 'Sinh viên';
  }
}
