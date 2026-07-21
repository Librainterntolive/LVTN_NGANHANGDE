import { Component, OnInit, inject, signal } from '@angular/core';
import { RouterLink } from '@angular/router';
import { StudentService } from '../../services/student.service';
import { Exam } from '../../services/exam.service';

@Component({
  selector: 'app-my-exams',
  imports: [RouterLink],
  templateUrl: './my-exams.html',
})
export class MyExams implements OnInit {
  private service = inject(StudentService);
  exams = signal<Exam[]>([]);
  error = signal<string>('');

  ngOnInit() {
    this.service.getMyExams().subscribe({
      next: (d) => this.exams.set(d ?? []),
      error: () => this.error.set('Không tải được. Bạn đã đăng nhập chưa?'),
    });
  }
}
