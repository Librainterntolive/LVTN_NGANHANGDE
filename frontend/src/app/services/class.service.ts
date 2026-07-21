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
  // lớp có thể giao đề: của mình + lớp dùng chung
  getAssignable(): Observable<AppClass[]> {
    return this.http.get<AppClass[]>(`${this.url}/assignable`);
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
  // đề thi đã giao cho lớp
  getExams(classId: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.url}/${classId}/exams`);
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
}
