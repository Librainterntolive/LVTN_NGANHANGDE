import { Component, OnInit, inject, signal } from '@angular/core';
import { DecimalPipe } from '@angular/common';
import { StudentService, SubmissionRow } from '../../services/student.service';

@Component({
  selector: 'app-my-submissions',
  imports: [DecimalPipe],
  templateUrl: './my-submissions.html',
})
export class MySubmissions implements OnInit {
  private service = inject(StudentService);
  rows = signal<SubmissionRow[]>([]);

  ngOnInit() {
    this.service.getMySubmissions().subscribe((d) => this.rows.set(d ?? []));
  }
}
