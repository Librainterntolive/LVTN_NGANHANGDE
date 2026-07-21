import { Component, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { UserService, AppUser } from '../../services/user.service';
import { DialogService } from '../../services/dialog.service';

@Component({
  selector: 'app-users',
  imports: [FormsModule],
  templateUrl: './users.html',
})
export class Users implements OnInit {
  private service = inject(UserService);
  private dialog = inject(DialogService);

  users = signal<AppUser[]>([]);
  error = signal<string>('');
  editingId = signal<number | null>(null);
  form: AppUser = this.empty();

  ngOnInit() { this.load(); }

  empty(): AppUser {
    return { username: '', email: '', password: '', full_name: '', role: 'Student', status: 'active' };
  }

  load() {
    this.service.getAll().subscribe({
      next: (d) => this.users.set(d ?? []),
      error: () => this.error.set('Không tải được (cần quyền Admin).'),
    });
  }

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
      if (ok) this.service.remove(id).subscribe(() => this.load());
    });
  }

  // ----- tạm khóa / mở khóa -----
  lock(u: AppUser) {
    this.dialog.prompt(`Tạm khóa "${u.username}" — nhập lý do:`, '').then((reason) => {
      if (reason === null) return; // bấm Hủy
      this.service.update(u.id!, { ...u, password: '', status: 'locked', lock_reason: reason || 'Vi phạm quy định' })
        .subscribe(() => this.load());
    });
  }

  unlock(u: AppUser) {
    this.dialog.confirm('Mở khóa tài khoản', `Mở khóa cho "${u.username}"?`).then((ok) => {
      if (ok) this.service.update(u.id!, { ...u, password: '', status: 'active', lock_reason: '' })
        .subscribe(() => this.load());
    });
  }

  // ----- hiển thị role / status -----
  roleLabel(r: string): string {
    return r === 'Admin' ? '👑 Quản trị' : r === 'Teacher' ? '🎓 Giảng viên' : '📖 Sinh viên';
  }
}
