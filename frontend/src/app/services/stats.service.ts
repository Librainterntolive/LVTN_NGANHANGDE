import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface Overview {
  total_users: number;
  total_questions: number;
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
}
