import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

// Kiểu dữ liệu môn học (khớp với struct Subject bên backend)
export interface Subject {
  id?: number;
  name: string;
  level?: string;        // Khối 10/11/12, Đại học, Khác
  description?: string;
  created_at?: string;
}

export interface SubjectPage {
  items: Subject[];
  total: number;
  page: number;
  limit: number;
}

// Service MẪU gọi API môn học. Copy theo mẫu này cho Question, Exam...
@Injectable({ providedIn: 'root' })
export class SubjectService {
  private http = inject(HttpClient);
  private url = `${environment.apiUrl}/subjects`;

  getPaged(page = 1, limit = 12, keyword?: string, level = 'Đại học'): Observable<SubjectPage> {
    const params = [`page=${page}`, `limit=${limit}`, `level=${encodeURIComponent(level)}`];
    if (keyword?.trim()) params.push(`keyword=${encodeURIComponent(keyword.trim())}`);
    return this.http.get<SubjectPage>(`${this.url}/paged?${params.join('&')}`);
  }

  getOne(id: number): Observable<Subject> {
    return this.http.get<Subject>(`${this.url}/${id}`);
  }

  create(data: Subject): Observable<Subject> {
    return this.http.post<Subject>(this.url, data);
  }

  update(id: number, data: Subject): Observable<Subject> {
    return this.http.put<Subject>(`${this.url}/${id}`, data);
  }

  remove(id: number): Observable<any> {
    return this.http.delete(`${this.url}/${id}`);
  }
}
