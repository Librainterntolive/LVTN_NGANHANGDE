import { Component, OnInit, inject, signal } from '@angular/core';
import { RouterLink } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { StudentService } from '../../services/student.service';
import { Exam } from '../../services/exam.service';

@Component({
  selector: 'app-home',
  imports: [RouterLink],
  templateUrl: './home.html',
})
export class Home implements OnInit {
  protected auth = inject(AuthService);
  private studentService = inject(StudentService);

  publicExams = signal<Exam[]>([]);

  ngOnInit() {
    // đề công khai cho khách dùng thử
    this.studentService.getPublicExams().subscribe({
      next: (d) => this.publicExams.set(d ?? []),
      error: () => {},
    });
  }
}
