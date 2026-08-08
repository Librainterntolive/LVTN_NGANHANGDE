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
  message = signal<string>('');
  ok = signal<boolean>(false);
  verifying = signal<boolean>(false);
  otp = '';
  loading = signal<boolean>(false);
  verifyLoading = signal<boolean>(false);
  resendLoading = signal<boolean>(false);

  submit() {
    if (this.loading() || this.ok()) return;
    this.error.set('');
    this.message.set('');

    const err = this.validate();
    if (err) {
      this.error.set(err);
      return;
    }

    this.loading.set(true);
    // đăng ký mặc định là Student
    this.auth.register({ ...this.form, username: this.form.username.trim(), role: 'Student' }).subscribe({
      next: (result: any) => {
        this.loading.set(false);
        this.ok.set(true);
        this.verifying.set(true);
		if (result?.otp_delivery_pending) this.error.set('Chưa gửi được OTP. Hãy bấm “Gửi lại OTP” để thử lại Gmail.');
      },
      error: (e) => {
        this.loading.set(false);
        this.error.set(e?.error?.error ?? 'Đăng ký thất bại');
      },
    });
  }

  verify() {
    if (this.verifyLoading()) return;
    const code = this.otp.trim();
    if (!/^\d{6}$/.test(code)) {
      this.error.set('Vui lòng nhập đúng mã OTP gồm 6 chữ số.');
      return;
    }
    this.error.set('');
    this.message.set('');
    this.verifyLoading.set(true);
    this.auth.verifyOTP(this.form.email.trim(), code).subscribe({
      next: () => { this.verifyLoading.set(false); this.router.navigate(['/login']); },
      error: (e) => { this.verifyLoading.set(false); this.error.set(e?.error?.error ?? 'Mã OTP không hợp lệ.'); },
    });
  }
  resend() {
    if (this.resendLoading()) return;
    this.error.set('');
    this.message.set('');
    this.resendLoading.set(true);
    this.auth.resendOTP(this.form.email.trim()).subscribe({
      next: () => { this.resendLoading.set(false); this.message.set('Đã gửi lại OTP. Hãy kiểm tra Gmail.'); },
      error: (e) => { this.resendLoading.set(false); this.error.set(e?.error?.error ?? 'Không gửi lại được OTP.'); },
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
    if (!this.form.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.form.email.trim())) {
      return 'Email không đúng định dạng.';
    }
    return '';
  }
}
