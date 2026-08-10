import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface Exam {
  id?: number;
  subject_id: number;
  title: string;
  description?: string;
  start_time?: string;
  end_time?: string;
  duration?: number;
  pass_score?: number;
  shuffle?: boolean;
  shuffle_answers?: boolean;
  shuffle_mode?: string; // per_student/fixed
  access_type?: string;  // private/public
  max_attempts?: number; // 0 = không giới hạn số lần làm
  status?: string;       // draft/published/closed
}

export interface ExamDetail {
  exam: Exam;
  question_ids: number[];
  class_ids: number[];
}

@Injectable({ providedIn: 'root' })
export class ExamService {
  private http = inject(HttpClient);
  private url = `${environment.apiUrl}/exams`;

  getAll(keyword?: string, subjectId?: number): Observable<Exam[]> {
    const p: string[] = [];
    if (keyword) p.push(`keyword=${encodeURIComponent(keyword)}`);
    if (subjectId) p.push(`subject_id=${subjectId}`);
    const q = p.length ? `?${p.join('&')}` : '';
    return this.http.get<Exam[]>(`${this.url}${q}`);
  }
  getPaged(page = 1, limit = 12, keyword?: string, subjectId?: number): Observable<{items:Exam[];total:number;page:number;limit:number}> {
    const params = [`page=${page}`, `limit=${limit}`];
    if (keyword) params.push(`keyword=${encodeURIComponent(keyword)}`);
    if (subjectId) params.push(`subject_id=${subjectId}`);
    return this.http.get<{items:Exam[];total:number;page:number;limit:number}>(`${this.url}/paged?${params.join('&')}`);
  }
  getOne(id: number): Observable<ExamDetail> {
    return this.http.get<ExamDetail>(`${this.url}/${id}`);
  }

  // xem nội dung đề (câu hỏi + đáp án) cho GV
  preview(id: number): Observable<{ exam: Exam; questions: any[] }> {
    return this.http.get<{ exam: Exam; questions: any[] }>(`${this.url}/${id}/preview`);
  }
  // variants: số mã đề cần in. answerKey: true để lấy bảng đáp án cho giảng viên.
  printPaper(id: number, variants = 1, answerKey = false): Observable<Blob> {
    const params = `variants=${variants}${answerKey ? '&key=1' : ''}`;
    return this.http.get(`${this.url}/${id}/print?${params}`, { responseType: 'blob' });
  }
  create(data: any): Observable<Exam> {
    return this.http.post<Exam>(this.url, data);
  }

  // tạo đề từ nhiều nguồn (file + đề ngân hàng), gửi multipart
  build(form: FormData): Observable<any> {
    return this.http.post(`${this.url}/build`, form);
  }

  // sinh đề tự động theo ma trận chương × độ khó
  generate(data: any): Observable<any> {
    return this.http.post(`${this.url}/generate`, data);
  }
  update(id: number, data: any): Observable<Exam> {
    return this.http.put<Exam>(`${this.url}/${id}`, data);
  }
  remove(id: number): Observable<any> {
    return this.http.delete(`${this.url}/${id}`);
  }

  // nhân bản đề về của mình (GV)
  clone(id: number): Observable<Exam> {
    return this.http.post<Exam>(`${this.url}/${id}/clone`, {});
  }
}
