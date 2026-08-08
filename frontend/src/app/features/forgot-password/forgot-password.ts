import { Component, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({selector:'app-forgot-password',imports:[FormsModule,RouterLink],templateUrl:'./forgot-password.html'})
export class ForgotPassword {
  private auth=inject(AuthService); email='';code='';step=signal<1|2>(1);message=signal('');error=signal('');loading=signal(false);
  send(){this.loading.set(true);this.error.set('');this.auth.requestPasswordOTP(this.email.trim()).subscribe({next:()=>{this.step.set(2);this.message.set('OTP đã được gửi về Gmail.');this.loading.set(false)},error:e=>{this.error.set(e?.error?.error??'Không gửi được OTP');this.loading.set(false)}})}
  confirm(){this.loading.set(true);this.auth.requestPasswordReset(this.email.trim(),this.code.trim()).subscribe({next:()=>{this.message.set('Yêu cầu đã gửi Admin duyệt.');this.loading.set(false)},error:e=>{this.error.set(e?.error?.error??'OTP không hợp lệ');this.loading.set(false)}})}
}
