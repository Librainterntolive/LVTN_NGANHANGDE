import { Component, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-register',
  imports: [FormsModule],
  templateUrl: './register.html',
})
export class Register {
  private auth = inject(AuthService);
  private router = inject(Router);

  form = { username: '', email: '', password: '', full_name: '' };
  error = signal<string>('');
  ok = signal<boolean>(false);

  submit() {
    this.error.set('');
    // đăng ký mặc định là Student
    this.auth.register({ ...this.form, role: 'Student' }).subscribe({
      next: () => {
        this.ok.set(true);
        setTimeout(() => this.router.navigate(['/login']), 1200);
      },
      error: (e) => this.error.set(e?.error?.error ?? 'Đăng ký thất bại'),
    });
  }
}
