import { Component, OnInit, inject, signal } from '@angular/core';
import { RouterLink, ActivatedRoute } from '@angular/router';
import { SubjectService, Subject } from '../../services/subject.service';
import { QuestionService, Question } from '../../services/question.service';
import { ExamService, Exam } from '../../services/exam.service';
import { StudentService } from '../../services/student.service';
import { AuthService } from '../../services/auth.service';
import { Paginator } from '../../shared/paginator';
import { Icon } from '../../shared/icon';

@Component({
  selector: 'app-subject-detail',
  imports: [RouterLink, Paginator, Icon],
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
  qPage = signal(1);
  qLimit = signal(10);

  // đề thi của môn
  exams = signal<Exam[]>([]);
  examTotal = signal<number>(0);
  examLoading = signal<boolean>(false);
  examPage = signal(1);
  examLimit = signal(10);

  isStaff(): boolean {
    const r = this.auth.getRole();
    return r === 'Admin' || r === 'Teacher';
  }

  ngOnInit() {
    this.subjectId = Number(this.route.snapshot.paramMap.get('id'));
    this.subjectService.getOne(this.subjectId).subscribe((s) => this.subject.set(s));
    this.loadExams();
  }

  selectTab(tab: 'exams' | 'questions') {
    this.tab.set(tab);
    if (tab === 'questions' && this.isStaff() && !this.questions().length && !this.qLoading()) {
      this.loadQuestions();
    }
  }

  loadExams() {
    if (this.examLoading()) return;
    this.examLoading.set(true);
    const request = this.isStaff()
      ? this.examService.getPaged(this.examPage(), this.examLimit(), undefined, this.subjectId)
      : this.studentService.getPublicExamsPaged(this.examPage(), this.examLimit(), this.subjectId);
    request.subscribe({
      next: result => {
        this.exams.set(result.items ?? []);
        this.examTotal.set(result.total);
        this.examLoading.set(false);
      },
      error: () => this.examLoading.set(false),
    });
  }

  goToExamPage(page: number) { this.examPage.set(page); this.loadExams(); }
  setExamLimit(limit: number) { this.examLimit.set(limit); this.examPage.set(1); this.loadExams(); }

  loadQuestions() {
    if (this.qLoading()) return;
    this.qLoading.set(true);
    this.qService.getPaged({ subjectId: this.subjectId, page: this.qPage(), limit: this.qLimit() }).subscribe({
      next: (res) => {
        this.questions.set(res.items ?? []);
        this.qTotal.set(res.total);
        this.qLoading.set(false);
      },
      error: () => this.qLoading.set(false),
    });
  }

  goToQuestionPage(page: number) { this.qPage.set(page); this.loadQuestions(); }
  setQuestionLimit(limit: number) { this.qLimit.set(limit); this.qPage.set(1); this.loadQuestions(); }
}
