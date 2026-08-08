import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface AppUser {
  id?: number;
  username: string;
  email?: string;
  password?: string;
  full_name?: string;
  role: string;   // Admin/Teacher/Student
  status?: string; // active/locked
  lock_reason?: string; // lý do tạm khóa
}
export interface PasswordResetRequest { id:number; user_id:number; status:string; created_at:string; approved_at?:string; }

@Injectable({ providedIn: 'root' })
export class UserService {
  private http = inject(HttpClient);
  private url = `${environment.apiUrl}/users`;

  getAll(): Observable<AppUser[]> {
    return this.http.get<AppUser[]>(this.url);
  }
  getPaged(page = 1, limit = 12, keyword = ''): Observable<{items: AppUser[]; total: number; page: number; limit: number}> {
    return this.http.get<{items: AppUser[]; total: number; page: number; limit: number}>(`${this.url}/paged?page=${page}&limit=${limit}&keyword=${encodeURIComponent(keyword)}`);
  }
  create(data: AppUser): Observable<AppUser> {
    return this.http.post<AppUser>(this.url, data);
  }
  update(id: number, data: AppUser): Observable<AppUser> {
    return this.http.put<AppUser>(`${this.url}/${id}`, data);
  }
  remove(id: number): Observable<any> {
    return this.http.delete(`${this.url}/${id}`);
  }
  getPasswordResetRequests(): Observable<PasswordResetRequest[]> { return this.http.get<PasswordResetRequest[]>(`${environment.apiUrl}/password-reset-requests`); }
  getPasswordResetRequestsPaged(page = 1, limit = 12): Observable<{items: PasswordResetRequest[]; total: number; page: number; limit: number}> { return this.http.get<{items: PasswordResetRequest[]; total: number; page: number; limit: number}>(`${environment.apiUrl}/password-reset-requests/paged?page=${page}&limit=${limit}`); }
  approvePasswordReset(id:number): Observable<any> { return this.http.post(`${environment.apiUrl}/password-reset-requests/${id}/approve`, {}); }
}
