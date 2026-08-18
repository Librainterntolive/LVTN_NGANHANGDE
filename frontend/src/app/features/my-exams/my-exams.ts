import { Component, OnInit, inject, signal } from '@angular/core';
import { RouterLink } from '@angular/router';
import { StudentService } from '../../services/student.service';
import { Exam } from '../../services/exam.service';
import { Paginator } from '../../shared/paginator';
import { Icon } from '../../shared/icon';

@Component({
  selector: 'app-my-exams',
  imports: [RouterLink, Paginator, Icon],
  templateUrl: './my-exams.html',
})
export class MyExams implements OnInit {
  private service = inject(StudentService);
  exams = signal<Exam[]>([]);
  error = signal<string>('');
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
    this.service.getMyExamsPaged(this.page(), this.limit()).subscribe({
      next: (result) => {
        this.exams.set(result.items ?? []);
        this.total.set(result.total ?? 0);
        this.loading.set(false);
      },
      error: () => { this.error.set('Không tải được. Bạn đã đăng nhập chưa?'); this.loading.set(false); },
    });
  }

  goToPage(page: number) { this.page.set(page); this.load(); }
  setLimit(limit: number) { this.limit.set(limit); this.page.set(1); this.load(); }
}
