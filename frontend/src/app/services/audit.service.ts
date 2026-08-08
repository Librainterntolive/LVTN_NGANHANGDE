import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface AuditLog {
  id: number;
  actor_user_id: number;
  actor_name?: string;
  action: string;
  entity_type: string;
  entity_id: number;
  description: string;
  created_at: string;
}

@Injectable({ providedIn: 'root' })
export class AuditService {
  private http = inject(HttpClient);
  private url = `${environment.apiUrl}/audit-logs`;

  getPaged(page = 1, limit = 12, action = ''): Observable<{ items: AuditLog[]; total: number }> {
    const params = [`page=${page}`, `limit=${limit}`];
    if (action) params.push(`action=${encodeURIComponent(action)}`);
    return this.http.get<{ items: AuditLog[]; total: number }>(`${this.url}?${params.join('&')}`);
  }
}
