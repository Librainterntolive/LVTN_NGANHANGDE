import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface Overview {
  total_users: number;
  total_questions: number;
  total_approved_questions: number;
  total_verified_sources: number;
  total_exams: number;
  total_submissions: number;
}

export interface ExamStat {
  exam_id: number;
  title: string;
  attempts: number;
  avg_score: number;
  pass_count: number;
  pass_rate: number;
}

@Injectable({ providedIn: 'root' })
export class StatsService {
  private http = inject(HttpClient);
  private url = `${environment.apiUrl}/stats`;

  getOverview(): Observable<Overview> {
    return this.http.get<Overview>(`${this.url}/overview`);
  }
  getExamStats(): Observable<ExamStat[]> {
    return this.http.get<ExamStat[]>(`${this.url}/exams`);
  }
  getExamStatsPaged(page = 1, limit = 12): Observable<{items: ExamStat[]; total: number; page: number; limit: number}> {
    return this.http.get<{items: ExamStat[]; total: number; page: number; limit: number}>(`${this.url}/exams/paged?page=${page}&limit=${limit}`);
  }
}
