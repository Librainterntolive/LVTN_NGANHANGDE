import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface Source {
  id?: number;
  title: string;
  publisher?: string;
  url: string;
  published_year?: string;
  license_note?: string;
  verification_status?: string;
  reviewed_by?: number;
  reviewed_at?: string;
}

@Injectable({ providedIn: 'root' })
export class SourceService {
  private http = inject(HttpClient);
  private url = `${environment.apiUrl}/sources`;

  getPaged(page = 1, limit = 12, keyword = ''): Observable<{ items: Source[]; total: number }> {
    const query = [`page=${page}`, `limit=${limit}`];
    if (keyword) query.push(`keyword=${encodeURIComponent(keyword)}`);
    return this.http.get<{ items: Source[]; total: number }>(`${this.url}?${query.join('&')}`);
  }

  create(source: Source): Observable<Source> {
    return this.http.post<Source>(this.url, source);
  }
  review(id: number, status: 'verified' | 'rejected'): Observable<Source> {
    return this.http.post<Source>(`${this.url}/${id}/review`, { status });
  }
}
