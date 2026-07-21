import { Routes } from '@angular/router';
import { Home } from './features/home/home';
import { Subjects } from './features/subjects/subjects';
import { SubjectDetail } from './features/subject-detail/subject-detail';
import { Login } from './features/login/login';
import { Register } from './features/register/register';
import { Questions } from './features/questions/questions';
import { Classes } from './features/classes/classes';
import { Users } from './features/users/users';
import { Exams } from './features/exams/exams';
import { MyExams } from './features/my-exams/my-exams';
import { TakeExam } from './features/take-exam/take-exam';
import { MySubmissions } from './features/my-submissions/my-submissions';
import { MyClasses } from './features/my-classes/my-classes';
import { MyStorage } from './features/my-storage/my-storage';
import { Stats } from './features/stats/stats';
import { authGuard } from './auth/auth.guard';

export const routes: Routes = [
  { path: '', component: Home },

  // công khai
  { path: 'login', component: Login },
  { path: 'register', component: Register },
  { path: 'subjects', component: Subjects },
  { path: 'subjects/:id', component: SubjectDetail },

  // quản lý (cần đăng nhập) - H, I, K
  { path: 'questions', component: Questions, canActivate: [authGuard] },
  { path: 'classes', component: Classes, canActivate: [authGuard] },
  { path: 'exams', component: Exams, canActivate: [authGuard] },
  { path: 'stats', component: Stats, canActivate: [authGuard] },
  { path: 'users', component: Users, canActivate: [authGuard] },

  // sinh viên - J
  { path: 'my-exams', component: MyExams, canActivate: [authGuard] },
  { path: 'my-classes', component: MyClasses, canActivate: [authGuard] },
  { path: 'my-storage', component: MyStorage, canActivate: [authGuard] },
  { path: 'take/:id', component: TakeExam }, // cho cả khách làm thử
  { path: 'my-submissions', component: MySubmissions, canActivate: [authGuard] },
];
