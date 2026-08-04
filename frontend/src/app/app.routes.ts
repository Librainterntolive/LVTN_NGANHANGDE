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
import { NotFound } from './features/not-found/not-found';
import { authGuard, roleGuard } from './auth/auth.guard';

// title: tên hiện trên tab trình duyệt (Angular tự gắn thêm phần đuôi chung).
export const routes: Routes = [
  { path: '', component: Home, title: 'Trang chủ' },

  // công khai
  { path: 'login', component: Login, title: 'Đăng nhập' },
  { path: 'register', component: Register, title: 'Đăng ký' },
  { path: 'subjects', component: Subjects, title: 'Môn học' },
  { path: 'subjects/:id', component: SubjectDetail, title: 'Chi tiết môn học' },

  // quản lý (Giảng viên + Quản trị viên) - H, I, K
  { path: 'questions', component: Questions, title: 'Ngân hàng câu hỏi', canActivate: [roleGuard('Admin', 'Teacher')] },
  { path: 'classes', component: Classes, title: 'Lớp học', canActivate: [roleGuard('Admin', 'Teacher')] },
  { path: 'exams', component: Exams, title: 'Đề thi', canActivate: [roleGuard('Admin', 'Teacher')] },
  { path: 'stats', component: Stats, title: 'Thống kê', canActivate: [roleGuard('Admin', 'Teacher')] },

  // chỉ Quản trị viên
  { path: 'users', component: Users, title: 'Người dùng', canActivate: [roleGuard('Admin')] },

  // sinh viên - J
  { path: 'my-exams', component: MyExams, title: 'Đề thi của tôi', canActivate: [authGuard] },
  { path: 'my-classes', component: MyClasses, title: 'Lớp của tôi', canActivate: [authGuard] },
  { path: 'my-storage', component: MyStorage, title: 'Kho của tôi', canActivate: [authGuard] },
  { path: 'take/:id', component: TakeExam, title: 'Làm bài thi' }, // cho cả khách làm thử
  { path: 'my-submissions', component: MySubmissions, title: 'Lịch sử làm bài', canActivate: [authGuard] },

  // đường dẫn không tồn tại -> trang 404 (phải đặt CUỐI cùng)
  { path: '**', component: NotFound, title: 'Không tìm thấy trang' },
];
