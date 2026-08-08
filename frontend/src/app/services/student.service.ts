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
  is_guest_trial?: boolean;
  question_limit?: number;
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
  status: string;
}
export interface MyLearningStats {
  saved_exams: number;
  attempts: number;
  avg_score: number;
  wrong_count: number;
  streak_days: number;
}

@Injectable({ providedIn: 'root' })
export class StudentService {
  private http = inject(HttpClient);
  private api = environment.apiUrl;

  getMyExams(): Observable<Exam[]> {
    return this.http.get<Exam[]>(`${this.api}/my-exams`);
  }
  getMyExamsPaged(page = 1, limit = 12): Observable<{ items: Exam[]; total: number; page: number; limit: number }> {
    return this.http.get<{ items: Exam[]; total: number; page: number; limit: number }>(`${this.api}/my-exams/paged?page=${page}&limit=${limit}`);
  }

  // đề công khai cho khách dùng thử (không cần đăng nhập)
  getPublicExams(): Observable<Exam[]> {
    return this.http.get<Exam[]>(`${this.api}/public-exams`);
  }
  getPublicExamsPaged(page = 1, limit = 12, subjectId?: number): Observable<{items: Exam[]; total: number; page: number; limit: number}> {
    const query = [`page=${page}`, `limit=${limit}`];
    if (subjectId) query.push(`subject_id=${subjectId}`);
    return this.http.get<{items: Exam[]; total: number; page: number; limit: number}>(`${this.api}/public-exams/paged?${query.join('&')}`);
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
  getMySubmissionsPaged(page = 1, limit = 12): Observable<{ items: SubmissionRow[]; total: number; page: number; limit: number }> {
    return this.http.get<{ items: SubmissionRow[]; total: number; page: number; limit: number }>(`${this.api}/my-submissions/paged?page=${page}&limit=${limit}`);
  }
  getSubmissionResult(submissionId: number): Observable<SubmitResult> {
    return this.http.get<SubmitResult>(`${this.api}/my-submissions/${submissionId}/result`);
  }
  getMyStats(): Observable<MyLearningStats> {
    return this.http.get<MyLearningStats>(`${this.api}/my-stats`);
  }
}
