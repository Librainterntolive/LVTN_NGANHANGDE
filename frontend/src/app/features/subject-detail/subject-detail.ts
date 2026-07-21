import { Component, OnInit, inject, signal } from '@angular/core';
import { RouterLink, ActivatedRoute } from '@angular/router';
import { SubjectService, Subject } from '../../services/subject.service';
import { QuestionService, Question } from '../../services/question.service';
import { ExamService, Exam } from '../../services/exam.service';
import { StudentService } from '../../services/student.service';
import { AuthService } from '../../services/auth.service';
import { InfiniteScrollDirective } from '../../shared/infinite-scroll.directive';

@Component({
  selector: 'app-subject-detail',
  imports: [RouterLink, InfiniteScrollDirective],
  templateUrl: './subject-detail.html',
})
export class SubjectDetail implements OnInit {
  private route = inject(ActivatedRoute);
  private subjectService = inject(SubjectService);
  private qService = inject(QuestionService);
  private examService = inject(ExamService);
  private studentService = inject(StudentService);
  private auth = inject(AuthService);

  subjectId = 0;
  subject = signal<Subject | null>(null);
  tab = signal<'exams' | 'questions'>('exams');

  // câu hỏi (lazy-load)
  questions = signal<Question[]>([]);
  qTotal = signal<number>(0);
  qLoading = signal<boolean>(false);
  qHasMore = signal<boolean>(false);
  private qPage = 1;

  // đề thi của môn
  exams = signal<Exam[]>([]);

  isStaff(): boolean {
    const r = this.auth.getRole();
    return r === 'Admin' || r === 'Teacher';
  }

  ngOnInit() {
    this.subjectId = Number(this.route.snapshot.paramMap.get('id'));
    this.subjectService.getOne(this.subjectId).subscribe((s) => this.subject.set(s));
    this.loadExams();
    if (this.isStaff()) this.loadQuestions();
  }

  loadExams() {
    if (this.isStaff()) {
      this.examService.getAll(undefined, this.subjectId).subscribe((d) => this.exams.set(d ?? []));
    } else {
      // khách/SV: chỉ thấy đề công khai của môn này
      this.studentService.getPublicExams().subscribe((d) =>
        this.exams.set((d ?? []).filter((e) => e.subject_id === this.subjectId)));
    }
  }

  loadQuestions() {
    if (this.qLoading()) return;
    this.qLoading.set(true);
    this.qService.getPaged({ subjectId: this.subjectId, page: this.qPage, limit: 12 }).subscribe({
      next: (res) => {
        this.questions.update((c) => [...c, ...(res.items ?? [])]);
        this.qTotal.set(res.total);
        this.qHasMore.set(this.questions().length < res.total);
        this.qLoading.set(false);
      },
      error: () => this.qLoading.set(false),
    });
  }

  loadMoreQuestions() {
    if (this.qLoading() || !this.qHasMore()) return;
    this.qPage++;
    this.loadQuestions();
  }
}
