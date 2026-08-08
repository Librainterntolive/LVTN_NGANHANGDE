import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface ClassPost {
  id?: number;
  class_id: number;
  created_by?: number;
  content: string;
  author_name?: string;
  created_at?: string;
  updated_at?: string;
}

@Injectable({ providedIn: 'root' })
export class ClassPostService {
  private http = inject(HttpClient);

  list(classId: number, page = 1, limit = 12): Observable<{ items: ClassPost[]; total: number }> {
    return this.http.get<{ items: ClassPost[]; total: number }>(`${environment.apiUrl}/classes/${classId}/posts?page=${page}&limit=${limit}`);
  }

  create(classId: number, content: string): Observable<ClassPost> {
    return this.http.post<ClassPost>(`${environment.apiUrl}/classes/${classId}/posts`, { content });
  }

  update(id: number, content: string): Observable<ClassPost> {
    return this.http.put<ClassPost>(`${environment.apiUrl}/class-posts/${id}`, { content });
  }

  remove(id: number): Observable<void> {
    return this.http.delete<void>(`${environment.apiUrl}/class-posts/${id}`);
  }
}
