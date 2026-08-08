import { TestBed } from '@angular/core/testing';
import { provideRouter } from '@angular/router';
import { throwError } from 'rxjs';
import { Home } from './home';
import { AuthService } from '../../services/auth.service';
import { StudentService } from '../../services/student.service';
import { ClassService } from '../../services/class.service';
import { StatsService } from '../../services/stats.service';

describe('Home', () => {
  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [Home],
      providers: [
        provideRouter([]),
        { provide: AuthService, useValue: { currentUser: () => null } },
        { provide: StudentService, useValue: { getPublicExamsPaged: () => throwError(() => new Error('offline')) } },
        { provide: ClassService, useValue: {} },
        { provide: StatsService, useValue: {} },
      ],
    }).compileComponents();
  });

  it('shows a clear message when public exams cannot be loaded', () => {
    const fixture = TestBed.createComponent(Home);
    fixture.detectChanges();

    expect((fixture.nativeElement as HTMLElement).querySelector('.public-error')?.textContent)
      .toContain('Không tải được đề công khai');
  });
});
