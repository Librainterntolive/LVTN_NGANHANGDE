import { Routes } from '@angular/router';
import { authGuard, roleGuard } from './auth/auth.guard';

// title: tên hiện trên tab trình duyệt (Angular tự gắn thêm phần đuôi chung).
export const routes: Routes = [
  { path: '', loadComponent: () => import('./features/home/home').then(m => m.Home), title: 'Trang chủ' },

  // công khai
  { path: 'login', loadComponent: () => import('./features/login/login').then(m => m.Login), title: 'Đăng nhập' },
  { path: 'register', loadComponent: () => import('./features/register/register').then(m => m.Register), title: 'Đăng ký' },
  { path: 'forgot-password', loadComponent: () => import('./features/forgot-password/forgot-password').then(m => m.ForgotPassword), title: 'Quên mật khẩu' },
  { path: 'change-password', loadComponent: () => import('./features/change-password/change-password').then(m => m.ChangePassword), title: 'Đổi mật khẩu', canActivate: [authGuard] },
  { path: 'subjects', loadComponent: () => import('./features/subjects/subjects').then(m => m.Subjects), title: 'Môn học' },
  { path: 'subjects/:id', loadComponent: () => import('./features/subject-detail/subject-detail').then(m => m.SubjectDetail), title: 'Chi tiết môn học' },

  // quản lý (Giảng viên + Quản trị viên) - H, I, K
  { path: 'questions', loadComponent: () => import('./features/questions/questions').then(m => m.Questions), title: 'Ngân hàng câu hỏi', canActivate: [roleGuard('Admin', 'Teacher')] },
  { path: 'classes', loadComponent: () => import('./features/classes/classes').then(m => m.Classes), title: 'Lớp học', canActivate: [roleGuard('Admin', 'Teacher')] },
  { path: 'classes/:id', loadComponent: () => import('./features/class-detail/class-detail').then(m => m.ClassDetail), title: 'Không gian lớp học', canActivate: [authGuard] },
  { path: 'exams', loadComponent: () => import('./features/exams/exams').then(m => m.Exams), title: 'Đề thi', canActivate: [roleGuard('Admin', 'Teacher')] },
  { path: 'stats', loadComponent: () => import('./features/stats/stats').then(m => m.Stats), title: 'Thống kê', canActivate: [roleGuard('Admin', 'Teacher')] },

  // chỉ Quản trị viên
  { path: 'users', loadComponent: () => import('./features/users/users').then(m => m.Users), title: 'Người dùng', canActivate: [roleGuard('Admin')] },
  { path: 'sources', loadComponent: () => import('./features/source-manager/source-manager').then(m => m.SourceManager), title: 'Kiểm duyệt nguồn', canActivate: [roleGuard('Admin')] },
  { path: 'audit-logs', loadComponent: () => import('./features/audit-manager/audit-manager').then(m => m.AuditManager), title: 'Nhật ký thao tác', canActivate: [roleGuard('Admin')] },

  // sinh viên - J
  { path: 'my-exams', loadComponent: () => import('./features/my-exams/my-exams').then(m => m.MyExams), title: 'Đề thi của tôi', canActivate: [authGuard] },
  { path: 'my-classes', loadComponent: () => import('./features/my-classes/my-classes').then(m => m.MyClasses), title: 'Lớp của tôi', canActivate: [authGuard] },
  { path: 'my-storage', loadComponent: () => import('./features/my-storage/my-storage').then(m => m.MyStorage), title: 'Kho của tôi', canActivate: [authGuard] },
  { path: 'take/:id', loadComponent: () => import('./features/take-exam/take-exam').then(m => m.TakeExam), title: 'Làm bài thi' }, // cho cả khách làm thử
  { path: 'my-submissions', loadComponent: () => import('./features/my-submissions/my-submissions').then(m => m.MySubmissions), title: 'Lịch sử làm bài', canActivate: [authGuard] },

  // đường dẫn không tồn tại -> trang 404 (phải đặt CUỐI cùng)
  { path: '**', loadComponent: () => import('./features/not-found/not-found').then(m => m.NotFound), title: 'Không tìm thấy trang' },
];
