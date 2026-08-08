import { Component, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-login',
  imports: [FormsModule, RouterLink],
  templateUrl: './login.html',
})
export class Login implements OnInit {
  private auth = inject(AuthService);
  private router = inject(Router);
  private route = inject(ActivatedRoute);

  username = '';
  password = '';
  error = signal<string>('');
  loading = signal<boolean>(false); // chặn bấm nhiều lần -> gửi trùng request

  ngOnInit() {
    if (this.route.snapshot.queryParamMap.get('reason') === 'expired') {
      this.error.set('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
    }
  }

  submit() {
    if (this.loading()) return;
    this.error.set('');

    // kiểm tra tại chỗ, khỏi gọi API với dữ liệu rỗng
    if (!this.username.trim() || !this.password) {
      this.error.set('Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.');
      return;
    }

    this.loading.set(true);
    this.auth.login(this.username.trim(), this.password).subscribe({
      next: () => {
        this.loading.set(false);
        this.router.navigate([this.auth.currentUser()?.must_change_password ? '/change-password' : this.homeFor(this.auth.getRole())]);
      },
      error: (e) => {
        this.loading.set(false);
        this.error.set(e?.error?.error ?? 'Đăng nhập thất bại');
      },
    });
  }

  // đưa mỗi vai trò về đúng trang việc của họ thay vì luôn vào /subjects
  private homeFor(role: string | null): string {
    if (role === 'Student') return '/my-exams';
    if (role === 'Admin' || role === 'Teacher') return '/exams';
    return '/subjects';
  }
}
