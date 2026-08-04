import { Component, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-register',
  imports: [FormsModule, RouterLink],
  templateUrl: './register.html',
})
export class Register {
  private auth = inject(AuthService);
  private router = inject(Router);

  form = { username: '', email: '', password: '', full_name: '' };
  error = signal<string>('');
  ok = signal<boolean>(false);
  loading = signal<boolean>(false);

  submit() {
    if (this.loading() || this.ok()) return;
    this.error.set('');

    const err = this.validate();
    if (err) {
      this.error.set(err);
      return;
    }

    this.loading.set(true);
    // đăng ký mặc định là Student
    this.auth.register({ ...this.form, username: this.form.username.trim(), role: 'Student' }).subscribe({
      next: () => {
        this.loading.set(false);
        this.ok.set(true);
        setTimeout(() => this.router.navigate(['/login']), 1200);
      },
      error: (e) => {
        this.loading.set(false);
        this.error.set(e?.error?.error ?? 'Đăng ký thất bại');
      },
    });
  }

  // Kiểm tra tại chỗ để báo lỗi ngay, không phải chờ máy chủ trả lời.
  // Giới hạn 72 ký tự là mức tối đa của bcrypt bên máy chủ.
  private validate(): string {
    if (!this.form.username.trim()) return 'Vui lòng nhập tên đăng nhập.';
    if (this.form.username.trim().length < 3) return 'Tên đăng nhập cần ít nhất 3 ký tự.';
    if (!this.form.full_name.trim()) return 'Vui lòng nhập họ tên.';
    if (!this.form.password) return 'Vui lòng nhập mật khẩu.';
    if (this.form.password.length < 6) return 'Mật khẩu cần ít nhất 6 ký tự.';
    if (this.form.password.length > 72) return 'Mật khẩu tối đa 72 ký tự.';
    if (this.form.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.form.email.trim())) {
      return 'Email không đúng định dạng.';
    }
    return '';
  }
}
