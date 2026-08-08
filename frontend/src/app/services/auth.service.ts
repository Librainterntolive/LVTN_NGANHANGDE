import { Injectable, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, tap } from 'rxjs';
import { environment } from '../../environments/environment';

export interface LoginResult {
  token: string;
  user: { id: number; username: string; full_name: string; role: string; must_change_password?: boolean };
}

@Injectable({ providedIn: 'root' })
export class AuthService {
  private http = inject(HttpClient);
  private url = `${environment.apiUrl}/auth`;

  // signal để giao diện biết đang đăng nhập hay chưa
  currentUser = signal<LoginResult['user'] | null>(this.readUser());

  login(username: string, password: string): Observable<LoginResult> {
    return this.http.post<LoginResult>(`${this.url}/login`, { username, password }).pipe(
      tap((res) => {
        localStorage.setItem('token', res.token);
        localStorage.setItem('user', JSON.stringify(res.user));
        this.currentUser.set(res.user);
      })
    );
  }

  register(data: any): Observable<any> {
    return this.http.post(`${this.url}/register`, data);
  }
  verifyOTP(email: string, code: string): Observable<any> {
    return this.http.post(`${this.url}/verify-otp`, { email, code });
  }
  resendOTP(email: string): Observable<any> { return this.http.post(`${this.url}/resend-otp`, { email }); }
  requestPasswordOTP(email: string): Observable<any> { return this.http.post(`${this.url}/password-reset-otp`, { email }); }
  requestPasswordReset(email: string, code: string): Observable<any> { return this.http.post(`${this.url}/forgot-password`, { email, code }); }
  changePassword(currentPassword:string,newPassword:string): Observable<any> { return this.http.post(`${environment.apiUrl}/auth/change-password`, { current_password:currentPassword, new_password:newPassword }); }

  logout() {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    this.currentUser.set(null);
  }

  getToken(): string | null {
    return localStorage.getItem('token');
  }

  isLoggedIn(): boolean {
    const valid = this.isTokenValid(this.getToken());
    if (!valid && this.getToken()) this.logout();
    return valid;
  }

  getRole(): string | null {
    return this.currentUser()?.role ?? null;
  }

  private readUser(): LoginResult['user'] | null {
    if (!this.isTokenValid(this.getToken())) {
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      return null;
    }
    const raw = localStorage.getItem('user');
    if (!raw) return null;
    try {
      return JSON.parse(raw);
    } catch {
      localStorage.removeItem('user');
      return null;
    }
  }

  private isTokenValid(token: string | null): boolean {
    if (!token) return false;
    const parts = token.split('.');
    if (parts.length !== 3) return false;
    try {
      const payload = parts[1].replace(/-/g, '+').replace(/_/g, '/');
      const decoded = atob(payload.padEnd(Math.ceil(payload.length / 4) * 4, '='));
      const expiry = JSON.parse(decoded).exp;
      return typeof expiry === 'number' && expiry * 1000 > Date.now();
    } catch {
      return false;
    }
  }
}
