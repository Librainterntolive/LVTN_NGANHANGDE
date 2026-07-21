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

@Injectable({ providedIn: 'root' })
export class UserService {
  private http = inject(HttpClient);
  private url = `${environment.apiUrl}/users`;

  getAll(): Observable<AppUser[]> {
    return this.http.get<AppUser[]>(this.url);
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
}
