import { TestBed } from '@angular/core/testing';
import { ActivatedRoute } from '@angular/router';
import { signal } from '@angular/core';
import { of } from 'rxjs';
import { vi } from 'vitest';
import { TakeExam } from './take-exam';
import { StudentService, TakeExamData } from '../../services/student.service';
import { AuthService } from '../../services/auth.service';
import { LayoutService } from '../../services/layout.service';

describe('TakeExam', () => {
  const examData: TakeExamData = {
    exam: { id: 9, title: 'Đề kiểm tra', duration: 30 },
    submission_id: 41,
    remaining_seconds: 1800,
    questions: [{
      id: 101,
      content: 'Câu hỏi',
      answers: [{ id: 501, label: 'A', content: 'Đáp án A' }, { id: 502, label: 'B', content: 'Đáp án B' }],
    }],
  };
  const studentService = { take: vi.fn(() => of(examData)) };

  beforeEach(async () => {
    localStorage.clear();
    studentService.take.mockClear();
    await TestBed.configureTestingModule({
      imports: [TakeExam],
      providers: [
        { provide: ActivatedRoute, useValue: { snapshot: { paramMap: { get: () => '9' } } } },
        { provide: StudentService, useValue: studentService },
        { provide: AuthService, useValue: { isLoggedIn: () => true } },
        { provide: LayoutService, useValue: { fullscreen: signal(false) } },
      ],
    }).compileComponents();
  });

  it('stores selected answers by the server submission session', () => {
    const component = TestBed.createComponent(TakeExam).componentInstance;
    component.data.set(examData);
    component.selected = { 101: 501 };

    component.saveDraft();

    expect(JSON.parse(localStorage.getItem('quiz-exam-draft-41') ?? '{}').selected).toEqual({ 101: 501 });
  });

  it('restores only answers that belong to the current server question set', () => {
    localStorage.setItem('quiz-exam-draft-41', JSON.stringify({
      saved_at: Date.now(),
      selected: { 101: 501, 999: 777, 1010: 502 },
    }));
    const component = TestBed.createComponent(TakeExam).componentInstance;

    component.ngOnInit();

    expect(component.selected).toEqual({ 101: 501 });
    expect(component.draftRestored()).toBe(true);
    component.ngOnDestroy();
  });
});
