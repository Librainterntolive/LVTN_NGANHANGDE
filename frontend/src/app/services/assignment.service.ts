import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, firstValueFrom } from 'rxjs';
import { environment } from '../../environments/environment';

export interface Assignment {
  id?: number; class_id: number; title: string; description?: string;
  due_at: string; late_until?: string | null; max_score?: number; status?: string; my_submission?: AssignmentSubmission;
}
export interface AssignmentSubmission {
  id?: number; assignment_id: number; student_id: number; original_name: string;
  status: 'on_time' | 'late'; submitted_at: string; score?: number | null; feedback?: string;
  student_name?: string; student_username?: string;
}
export interface ClassSubmissionStat { student_id:number; full_name:string; username:string; submitted:number; late:number; average_submitted:number; average_with_missing:number; }
export interface ClassSubmissionSummary { average_submitted:number; average_with_missing:number; submission_rate:number; }
interface UploadSession { id: string; chunk_size: number; total_chunks: number; }
interface UploadProgress extends UploadSession { received_indexes: number[]; }
interface SavedUpload { id: string; filename: string; size: number; last_modified: number; }

@Injectable({ providedIn: 'root' })
export class AssignmentService {
  private http = inject(HttpClient);
  private api = environment.apiUrl;

  list(classId: number, page = 1, limit = 12): Observable<{items: Assignment[]; total: number}> {
    return this.http.get<{items: Assignment[]; total: number}>(`${this.api}/classes/${classId}/assignments?page=${page}&limit=${limit}`);
  }
  create(classId: number, data: Assignment) { return this.http.post<Assignment>(`${this.api}/classes/${classId}/assignments`, data); }
  update(id: number, data: Assignment) { return this.http.put<Assignment>(`${this.api}/assignments/${id}`, data); }
  remove(id: number) { return this.http.delete(`${this.api}/assignments/${id}`); }
  submissions(id: number) { return this.http.get<AssignmentSubmission[]>(`${this.api}/assignments/${id}/submissions`); }
  submissionsPaged(id: number, page = 1, limit = 12) { return this.http.get<{ items: AssignmentSubmission[]; total: number; page: number; limit: number }>(`${this.api}/assignments/${id}/submissions/paged?page=${page}&limit=${limit}`); }
  grade(id: number, score: number, feedback: string) { return this.http.put<AssignmentSubmission>(`${this.api}/assignment-submissions/${id}/grade`, {score, feedback}); }
  download(id: number) { return this.http.get(`${this.api}/assignment-submissions/${id}/download`, {responseType: 'blob'}); }
  classStats(classId: number) { return this.http.get<ClassSubmissionStat[]>(`${this.api}/classes/${classId}/submission-stats`); }
  classStatsPaged(classId: number, page = 1, limit = 12) { return this.http.get<{ items: ClassSubmissionStat[]; total: number; summary: ClassSubmissionSummary; page: number; limit: number }>(`${this.api}/classes/${classId}/submission-stats/paged?page=${page}&limit=${limit}`); }

  async uploadWithRetry(assignmentId: number, file: File, onProgress: (percent: number) => void): Promise<AssignmentSubmission> {
    const storageKey = `quiz-upload-${assignmentId}`;
    let session: UploadProgress;
    const saved = this.readSavedUpload(storageKey);
    if (saved && saved.filename === file.name && saved.size === file.size && saved.last_modified === file.lastModified) {
      try {
        session = await firstValueFrom(this.http.get<UploadProgress>(`${this.api}/uploads/${saved.id}`));
      } catch {
        localStorage.removeItem(storageKey);
        session = await this.startUpload(assignmentId, file, storageKey);
      }
    } else {
      localStorage.removeItem(storageKey);
      session = await this.startUpload(assignmentId, file, storageKey);
    }
    const received = new Set(session.received_indexes ?? []);
    for (let index = 0; index < session.total_chunks; index++) {
      if (received.has(index)) {
        onProgress(Math.round(((index + 1) / session.total_chunks) * 100));
        continue;
      }
      const start = index * session.chunk_size;
      const chunk = file.slice(start, Math.min(start + session.chunk_size, file.size));
      await this.sendChunkWithRetry(session.id, index, chunk);
      onProgress(Math.round(((index + 1) / session.total_chunks) * 100));
    }
    const submission = await firstValueFrom(this.http.post<AssignmentSubmission>(`${this.api}/uploads/${session.id}/complete`, {}));
    localStorage.removeItem(storageKey);
    return submission;
  }

  private async startUpload(assignmentId: number, file: File, storageKey: string): Promise<UploadProgress> {
    const session = await firstValueFrom(this.http.post<UploadSession>(`${this.api}/assignments/${assignmentId}/upload-sessions`, {filename: file.name, mime_type: file.type, size: file.size}));
    const saved: SavedUpload = { id: session.id, filename: file.name, size: file.size, last_modified: file.lastModified };
    localStorage.setItem(storageKey, JSON.stringify(saved));
    return { ...session, received_indexes: [] };
  }

  private readSavedUpload(storageKey: string): SavedUpload | null {
    try {
      const value = localStorage.getItem(storageKey);
      return value ? JSON.parse(value) as SavedUpload : null;
    } catch {
      localStorage.removeItem(storageKey);
      return null;
    }
  }

  private async sendChunkWithRetry(sessionId: string, index: number, chunk: Blob): Promise<void> {
    let lastError: unknown;
    for (let attempt = 0; attempt < 3; attempt++) {
      try { await firstValueFrom(this.http.put(`${this.api}/uploads/${sessionId}/chunks/${index}`, chunk)); return; }
      catch (error) { lastError = error; await new Promise((resolve) => setTimeout(resolve, 700 * (attempt + 1))); }
    }
    throw lastError;
  }
}
