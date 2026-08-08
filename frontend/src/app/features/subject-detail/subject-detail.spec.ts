import { TestBed } from '@angular/core/testing';
import { provideRouter } from '@angular/router';
import { ActivatedRoute } from '@angular/router';
import { of } from 'rxjs';
import { vi } from 'vitest';
import { SubjectDetail } from './subject-detail';
import { SubjectService } from '../../services/subject.service';
import { QuestionService } from '../../services/question.service';
import { ExamService } from '../../services/exam.service';
import { StudentService } from '../../services/student.service';
import { AuthService } from '../../services/auth.service';

describe('SubjectDetail', () => {
  const questionService = {
    getPaged: vi.fn(() => of({ items: [], total: 0, page: 1, limit: 12 })),
  };

  beforeEach(async () => {
    questionService.getPaged.mockClear();
    await TestBed.configureTestingModule({
      imports: [SubjectDetail],
      providers: [
        provideRouter([]),
        { provide: ActivatedRoute, useValue: { snapshot: { paramMap: { get: () => '1' } } } },
        { provide: SubjectService, useValue: { getOne: () => of({ id: 1, name: 'Lập trình', level: 'Đại học' }) } },
        { provide: QuestionService, useValue: questionService },
        { provide: ExamService, useValue: { getPaged: () => of({ items: [], total: 0 }) } },
        { provide: StudentService, useValue: { getPublicExamsPaged: () => of({ items: [], total: 0 }) } },
        { provide: AuthService, useValue: { getRole: () => 'Teacher' } },
      ],
    }).compileComponents();
  });

  it('does not request question data until the question tab is opened', () => {
    const fixture = TestBed.createComponent(SubjectDetail);
    fixture.detectChanges();

    expect(questionService.getPaged).not.toHaveBeenCalled();
  });
});
