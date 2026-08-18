import { Component, OnInit, inject, signal } from '@angular/core';
import { DecimalPipe } from '@angular/common';
import { StudentService, SubmissionRow } from '../../services/student.service';
import { Paginator } from '../../shared/paginator';

@Component({
  selector: 'app-my-submissions',
  imports: [DecimalPipe, Paginator],
  templateUrl: './my-submissions.html',
})
export class MySubmissions implements OnInit {
  private service = inject(StudentService);
  rows = signal<SubmissionRow[]>([]);
  total = signal(0);
  page = signal(1);
  limit = signal(10);
  loading = signal(false);

  ngOnInit() {
    this.load();
  }

  load() {
    if (this.loading()) return;
    this.loading.set(true);
    this.service.getMySubmissionsPaged(this.page(), this.limit()).subscribe({
      next: result => {
        this.rows.set(result.items ?? []);
        this.total.set(result.total ?? 0);
        this.loading.set(false);
      },
      error: () => this.loading.set(false),
    });
  }

  goToPage(page: number) { this.page.set(page); this.load(); }
  setLimit(limit: number) { this.limit.set(limit); this.page.set(1); this.load(); }
}
