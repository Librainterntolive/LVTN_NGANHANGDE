import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { Exam } from './exam.service';

export interface Folder {
  id: number;
  name: string;
  parent_id: number | null;
}

export interface SavedExam {
  id: number;       // id bản ghi trong kho
  exam_id: number;
  title: string;
  subject_id: number;
  status: string;
  access_type: string;
  duration: number;
  note?: string;           // ghi chú cá nhân
  attempt_count?: number;  // số lần đã làm
  best_score?: number;     // điểm cao nhất
  last_score?: number;     // điểm lần gần nhất
}

export interface MyStats {
  saved_exams: number;
  attempts: number;
  avg_score: number;
  wrong_count: number;
  streak_days: number;
}

export interface WrongQuestion {
  question_id: number;
  content: string;
  subject_id: number;
  difficulty: string;
  wrong_count: number;
  need_streak: number;
}

@Injectable({ providedIn: 'root' })
export class FolderService {
  private http = inject(HttpClient);
  private api = environment.apiUrl;

  getFolders(): Observable<Folder[]> {
    return this.http.get<Folder[]>(`${this.api}/folders`);
  }
  create(name: string, parentId: number | null): Observable<Folder> {
    return this.http.post<Folder>(`${this.api}/folders`, { name, parent_id: parentId });
  }
  rename(id: number, name: string): Observable<Folder> {
    return this.http.put<Folder>(`${this.api}/folders/${id}`, { name });
  }
  remove(id: number): Observable<any> {
    return this.http.delete(`${this.api}/folders/${id}`);
  }
  getExams(folderId: number): Observable<SavedExam[]> {
    return this.http.get<SavedExam[]>(`${this.api}/folders/${folderId}/exams`);
  }
  addExam(folderId: number, examId: number): Observable<any> {
    return this.http.post(`${this.api}/folders/${folderId}/exams`, { exam_id: examId });
  }
  removeExam(folderId: number, examId: number): Observable<any> {
    return this.http.delete(`${this.api}/folders/${folderId}/exams/${examId}`);
  }
  // ghi chú cá nhân trên đề đã lưu
  setNote(folderId: number, examId: number, note: string): Observable<any> {
    return this.http.put(`${this.api}/folders/${folderId}/exams/${examId}/note`, { note });
  }

  // ngân hàng đề (đề đã phát hành)
  getExamBank(): Observable<Exam[]> {
    return this.http.get<Exam[]>(`${this.api}/exam-bank`);
  }
  // id các đề đã lưu (badge "Đã lưu")
  getSavedExamIds(): Observable<number[]> {
    return this.http.get<number[]>(`${this.api}/saved-exams`);
  }

  // ----- thống kê góc học tập -----
  getMyStats(): Observable<MyStats> {
    return this.http.get<MyStats>(`${this.api}/my-stats`);
  }

  // ----- sổ tay câu sai -----
  getWrongQuestions(): Observable<WrongQuestion[]> {
    return this.http.get<WrongQuestion[]>(`${this.api}/practice/wrong-questions`);
  }
  getPracticeSet(): Observable<any[]> {
    return this.http.get<any[]>(`${this.api}/practice/wrong-questions/take`);
  }
  submitPractice(answers: { question_id: number; selected_answer_id: number }[]): Observable<{ results: any[] }> {
    return this.http.post<{ results: any[] }>(`${this.api}/practice/wrong-questions/submit`, { answers });
  }
}
