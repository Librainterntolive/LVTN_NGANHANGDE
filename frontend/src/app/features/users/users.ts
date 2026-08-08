import { Component, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { DatePipe } from '@angular/common';
import { UserService, AppUser, PasswordResetRequest } from '../../services/user.service';
import { DialogService } from '../../services/dialog.service';
import { InfiniteScrollDirective } from '../../shared/infinite-scroll.directive';
import { ToastService } from '../../services/toast.service';

@Component({
  selector: 'app-users',
  imports: [FormsModule, DatePipe, InfiniteScrollDirective],
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
  private page = 1;
  error = signal<string>('');
  editingId = signal<number | null>(null);
  form: AppUser = this.empty();
  resetRequests = signal<PasswordResetRequest[]>([]);
  resetRequestTotal = signal(0);
  resetRequestPage = 1;
  resetRequestsLoading = signal(false);

  ngOnInit() { this.load(); this.loadResetRequests(); }

  empty(): AppUser {
    return { username: '', email: '', password: '', full_name: '', role: 'Student', status: 'active' };
  }

  load(reset = true) {
    if (this.loading()) return;
    if (reset) { this.page = 1; this.users.set([]); this.total.set(0); }
    this.loading.set(true);
    this.service.getPaged(this.page, 12, this.keyword.trim()).subscribe({
      next: (data) => { this.users.update(rows => [...rows, ...(data.items ?? [])]); this.total.set(data.total); this.page++; this.loading.set(false); },
      error: () => { this.error.set('Không tải được (cần quyền Admin).'); this.loading.set(false); },
    });
  }
  loadMore() { if (!this.loading() && this.users().length < this.total()) this.load(false); }
  loadResetRequests(reset = true) { if (this.resetRequestsLoading()) return; const page = reset ? 1 : this.resetRequestPage + 1; if (reset) { this.resetRequests.set([]); this.resetRequestTotal.set(0); } this.resetRequestsLoading.set(true); this.service.getPasswordResetRequestsPaged(page).subscribe({next: result=>{this.resetRequests.set(reset ? (result.items ?? []) : [...this.resetRequests(), ...(result.items ?? [])]);this.resetRequestTotal.set(result.total ?? 0);this.resetRequestPage = page;this.resetRequestsLoading.set(false);},error:()=>this.resetRequestsLoading.set(false)}); }
  hasMoreResetRequests() { return this.resetRequests().length < this.resetRequestTotal(); }
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
    return r === 'Admin' ? '👑 Quản trị' : r === 'Teacher' ? '🎓 Giảng viên' : '📖 Sinh viên';
  }
}
