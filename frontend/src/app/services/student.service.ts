import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { Exam } from './exam.service';

export interface TakeAnswer { id: number; label: string; content: string; }
export interface TakeQuestion { id: number; content: string; answers: TakeAnswer[]; }
export interface TakeExamData {
  exam: { id: number; title: string; duration: number };
  questions: TakeQuestion[];
  // Phiên làm bài do server cấp (khách làm thử không có).
  // remaining_seconds = -1 nghĩa là đề không giới hạn thời gian.
  submission_id?: number;
  remaining_seconds?: number;
}
export interface SubmitResult {
  submission_id: number;
  total: number;
  correct: number;
  score: number;
  is_passed: boolean;
}
export interface SubmissionRow {
  id: number;
  exam_id: number;
  exam_title: string;
  total_score: number;
  is_passed: boolean;
  submit_time: string;
}

@Injectable({ providedIn: 'root' })
export class StudentService {
  private http = inject(HttpClient);
  private api = environment.apiUrl;

  getMyExams(): Observable<Exam[]> {
    return this.http.get<Exam[]>(`${this.api}/my-exams`);
  }

  // đề công khai cho khách dùng thử (không cần đăng nhập)
  getPublicExams(): Observable<Exam[]> {
    return this.http.get<Exam[]>(`${this.api}/public-exams`);
  }
  take(examId: number): Observable<TakeExamData> {
    return this.http.get<TakeExamData>(`${this.api}/exams/${examId}/take`);
  }
  submit(examId: number, answers: { question_id: number; selected_answer_id: number }[]): Observable<SubmitResult> {
    return this.http.post<SubmitResult>(`${this.api}/exams/${examId}/submit`, { answers });
  }
  getMySubmissions(): Observable<SubmissionRow[]> {
    return this.http.get<SubmissionRow[]>(`${this.api}/my-submissions`);
  }
}
