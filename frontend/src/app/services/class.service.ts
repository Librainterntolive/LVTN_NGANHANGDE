import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { AppUser } from './user.service';

export interface AppClass {
  id?: number;
  name: string;
  description?: string;
  code?: string;          // mã tham gia lớp
  creator_name?: string;  // tên GV tạo
  is_public?: boolean;    // lớp dùng chung
  student_count?: number; // số SV trong lớp
  exam_count?: number;    // số đề đã giao
}

@Injectable({ providedIn: 'root' })
export class ClassService {
  private http = inject(HttpClient);
  private url = `${environment.apiUrl}/classes`;

  getAll(): Observable<AppClass[]> {
    return this.http.get<AppClass[]>(this.url);
  }
  getPaged(page = 1, limit = 12): Observable<{ items: AppClass[]; total: number; page: number; limit: number }> {
    return this.http.get<{ items: AppClass[]; total: number; page: number; limit: number }>(`${this.url}/paged?page=${page}&limit=${limit}`);
  }
  getOne(classId: number): Observable<AppClass> {
    return this.http.get<AppClass>(`${this.url}/${classId}`);
  }
  searchStudents(keyword: string): Observable<AppUser[]> {
    return this.http.get<AppUser[]>(`${environment.apiUrl}/students/search?query=${encodeURIComponent(keyword)}`);
  }
  // lớp có thể giao đề: của mình + lớp dùng chung
  getAssignable(): Observable<AppClass[]> {
    return this.http.get<AppClass[]>(`${this.url}/assignable`);
  }
  getAssignablePaged(page = 1, limit = 12): Observable<{ items: AppClass[]; total: number; page: number; limit: number }> {
    return this.http.get<{ items: AppClass[]; total: number; page: number; limit: number }>(`${this.url}/assignable/paged?page=${page}&limit=${limit}`);
  }
  create(data: AppClass): Observable<AppClass> {
    return this.http.post<AppClass>(this.url, data);
  }
  update(id: number, data: AppClass): Observable<AppClass> {
    return this.http.put<AppClass>(`${this.url}/${id}`, data);
  }
  remove(id: number): Observable<any> {
    return this.http.delete(`${this.url}/${id}`);
  }

  getStudents(classId: number): Observable<AppUser[]> {
    return this.http.get<AppUser[]>(`${this.url}/${classId}/students`);
  }
  getStudentsPaged(classId: number, page = 1, limit = 12): Observable<{ items: AppUser[]; total: number; page: number; limit: number }> {
    return this.http.get<{ items: AppUser[]; total: number; page: number; limit: number }>(`${this.url}/${classId}/students/paged?page=${page}&limit=${limit}`);
  }
  // đề thi đã giao cho lớp
  getExams(classId: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.url}/${classId}/exams`);
  }
  getExamsPaged(classId: number, page = 1, limit = 12): Observable<{ items: any[]; total: number; page: number; limit: number }> {
    return this.http.get<{ items: any[]; total: number; page: number; limit: number }>(`${this.url}/${classId}/exams/paged?page=${page}&limit=${limit}`);
  }
  addStudent(classId: number, studentId: number): Observable<any> {
    return this.http.post(`${this.url}/${classId}/students`, { student_id: studentId });
  }
  removeStudent(classId: number, studentId: number): Observable<any> {
    return this.http.delete(`${this.url}/${classId}/students/${studentId}`);
  }

  // ----- phía sinh viên -----
  joinByCode(code: string): Observable<any> {
    return this.http.post(`${environment.apiUrl}/join-class`, { code });
  }
  getMyClasses(): Observable<AppClass[]> {
    return this.http.get<AppClass[]>(`${environment.apiUrl}/my-classes`);
  }
  getMyClassesPaged(page = 1, limit = 12): Observable<{ items: AppClass[]; total: number; page: number; limit: number }> {
    return this.http.get<{ items: AppClass[]; total: number; page: number; limit: number }>(`${environment.apiUrl}/my-classes/paged?page=${page}&limit=${limit}`);
  }
}
