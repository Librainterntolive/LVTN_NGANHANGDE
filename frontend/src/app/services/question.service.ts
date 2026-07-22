import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface Answer {
  id?: number;
  label?: string;
  content: string;
  is_correct: boolean;
  order_index?: number;
}

export interface Question {
  id?: number;
  subject_id: number;
  chapter_id?: number | null; // null = chưa phân chương
  content: string;
  question_type?: string; // single/truefalse
  difficulty?: string;    // easy/medium/hard
  status?: string;        // draft (nháp) / active (chính thức)
  created_by?: number;    // id người soạn
  creator_name?: string;  // tên người soạn
  used_count?: number;    // số đề thi đang dùng câu này (>0 = khóa sửa/xóa)
  answers: Answer[];
}

// Kết quả import: subject_ids là các môn đã nhận câu hỏi, dùng để mở đúng môn
// cho người dùng thấy kết quả ngay sau khi import.
export interface ImportResult {
  imported: number;
  subject_ids?: number[] | null;
  errors: string[] | null;
}

@Injectable({ providedIn: 'root' })
export class QuestionService {
  private http = inject(HttpClient);
  private url = `${environment.apiUrl}/questions`;

  // phân trang: trả { items, total }
  getPaged(opts: {
    subjectId?: number; keyword?: string; owner?: string; chapter?: number | 'none';
    difficulty?: string; status?: string; page?: number; limit?: number;
  }): Observable<{ items: Question[]; total: number; page: number; limit: number }> {
    const p: string[] = [];
    if (opts.subjectId) p.push(`subject_id=${opts.subjectId}`);
    if (opts.keyword) p.push(`keyword=${encodeURIComponent(opts.keyword)}`);
    if (opts.owner) p.push(`owner=${opts.owner}`);
    if (opts.chapter) p.push(`chapter_id=${opts.chapter}`); // 'none' = chưa phân chương
    if (opts.difficulty) p.push(`difficulty=${opts.difficulty}`);
    if (opts.status) p.push(`status=${opts.status}`);
    p.push(`page=${opts.page ?? 1}`);
    p.push(`limit=${opts.limit ?? 12}`);
    return this.http.get<{ items: Question[]; total: number; page: number; limit: number }>(`${this.url}?${p.join('&')}`);
  }

  getOne(id: number): Observable<Question> {
    return this.http.get<Question>(`${this.url}/${id}`);
  }

  create(data: Question): Observable<Question> {
    return this.http.post<Question>(this.url, data);
  }

  update(id: number, data: Question): Observable<Question> {
    return this.http.put<Question>(`${this.url}/${id}`, data);
  }

  remove(id: number): Observable<any> {
    return this.http.delete(`${this.url}/${id}`);
  }

  // K - import câu hỏi từ file CSV hoặc Excel
  importFile(file: File): Observable<ImportResult> {
    const form = new FormData();
    form.append('file', file);
    return this.http.post<ImportResult>(`${this.url}/import`, form);
  }

  // tải file Excel mẫu
  downloadTemplate(): Observable<Blob> {
    return this.http.get(`${this.url}/import-template`, { responseType: 'blob' });
  }
}
