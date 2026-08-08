import { Component, OnInit, inject, signal } from '@angular/core';
import { DecimalPipe } from '@angular/common';
import { StudentService, SubmissionRow } from '../../services/student.service';
import { InfiniteScrollDirective } from '../../shared/infinite-scroll.directive';

@Component({
  selector: 'app-my-submissions',
  imports: [DecimalPipe, InfiniteScrollDirective],
  templateUrl: './my-submissions.html',
})
export class MySubmissions implements OnInit {
  private service = inject(StudentService);
  rows = signal<SubmissionRow[]>([]);
  total = signal(0);
  page = signal(1);
  loading = signal(false);

  ngOnInit() {
    this.load();
  }

  load(reset = true) {
    if (this.loading()) return;
    const page = reset ? 1 : this.page() + 1;
    this.loading.set(true);
    this.service.getMySubmissionsPaged(page).subscribe({
      next: result => { this.rows.set(reset ? (result.items ?? []) : [...this.rows(), ...(result.items ?? [])]); this.total.set(result.total ?? 0); this.page.set(page); this.loading.set(false); },
      error: () => this.loading.set(false),
    });
  }
  hasMore() { return this.rows().length < this.total(); }
}
