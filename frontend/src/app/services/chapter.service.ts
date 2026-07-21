import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface Chapter {
  id?: number;
  subject_id: number;
  name: string;
  order_index?: number;
  question_count?: number; // số câu hỏi trong chương (backend tính)
}

@Injectable({ providedIn: 'root' })
export class ChapterService {
  private http = inject(HttpClient);
  private url = `${environment.apiUrl}/chapters`;

  getBySubject(subjectId: number): Observable<Chapter[]> {
    return this.http.get<Chapter[]>(`${this.url}?subject_id=${subjectId}`);
  }

  create(data: Chapter): Observable<Chapter> {
    return this.http.post<Chapter>(this.url, data);
  }

  update(id: number, data: Chapter): Observable<Chapter> {
    return this.http.put<Chapter>(`${this.url}/${id}`, data);
  }

  remove(id: number): Observable<any> {
    return this.http.delete(`${this.url}/${id}`);
  }
}
