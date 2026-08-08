import { Component, OnInit, inject, signal } from '@angular/core';
import { RouterLink } from '@angular/router';
import { StudentService } from '../../services/student.service';
import { Exam } from '../../services/exam.service';
import { InfiniteScrollDirective } from '../../shared/infinite-scroll.directive';
import { Icon } from '../../shared/icon';

@Component({
  selector: 'app-my-exams',
  imports: [RouterLink, InfiniteScrollDirective, Icon],
  templateUrl: './my-exams.html',
})
export class MyExams implements OnInit {
  private service = inject(StudentService);
  exams = signal<Exam[]>([]);
  error = signal<string>('');
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
    this.service.getMyExamsPaged(page).subscribe({
      next: (result) => {
        this.exams.set(reset ? (result.items ?? []) : [...this.exams(), ...(result.items ?? [])]);
        this.total.set(result.total ?? 0);
        this.page.set(page);
        this.loading.set(false);
      },
      error: () => { this.error.set('Không tải được. Bạn đã đăng nhập chưa?'); this.loading.set(false); },
    });
  }
  hasMore() { return this.exams().length < this.total(); }
}
