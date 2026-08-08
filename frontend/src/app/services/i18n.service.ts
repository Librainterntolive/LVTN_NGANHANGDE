import { Injectable, signal } from '@angular/core';

export type Lang = 'vi' | 'en';

// Từ điển song ngữ: key -> { vi, en }
const DICT: Record<string, { vi: string; en: string }> = {
  'app.title': { vi: 'Hệ thống thi trắc nghiệm trực tuyến', en: 'Online Quiz System' },
  'app.subtitle': { vi: 'Thi trắc nghiệm', en: 'Online quizzes' },

  'menu.search': { vi: 'Tìm kiếm...', en: 'Search...' },
  'menu.home': { vi: 'Trang chủ', en: 'Dashboard' },
  'menu.subjects': { vi: 'Môn học', en: 'Subjects' },
  'menu.storage': { vi: 'Kho của tôi', en: 'My Storage' },
  'menu.teaching': { vi: 'Giảng dạy', en: 'Teaching' },
  'menu.questions': { vi: 'Câu hỏi', en: 'Questions' },
  'menu.classes': { vi: 'Lớp học', en: 'Classes' },
  'menu.exams': { vi: 'Đề thi', en: 'Exams' },
  'menu.stats': { vi: 'Thống kê', en: 'Statistics' },
  'menu.admin': { vi: 'Quản trị', en: 'Admin' },
  'menu.users': { vi: 'Người dùng', en: 'Users' },
  'menu.sources': { vi: 'Kiểm duyệt nguồn', en: 'Source review' },
  'menu.learning': { vi: 'Học tập', en: 'Learning' },
  'menu.myexams': { vi: 'Đề thi của tôi', en: 'My Exams' },
  'menu.myclasses': { vi: 'Lớp của tôi', en: 'My Classes' },
  'menu.history': { vi: 'Lịch sử', en: 'History' },
  'menu.logout': { vi: 'Đăng xuất', en: 'Log out' },
  'menu.dark': { vi: 'Chế độ tối', en: 'Dark mode' },
  'menu.auto': { vi: 'Tự động theo hệ thống', en: 'Auto (follow system)' },
  'menu.lang': { vi: 'Ngôn ngữ: Tiếng Việt', en: 'Language: English' },

  'auth.login': { vi: 'Đăng nhập', en: 'Log in' },
  'auth.register': { vi: 'Đăng ký', en: 'Sign up' },
  'dlg.cancel': { vi: 'Hủy', en: 'Cancel' },
  'dlg.ok': { vi: 'Đồng ý', en: 'OK' },

  'stats.title': { vi: 'Thống kê - Báo cáo', en: 'Statistics & Reports' },
  'stats.users': { vi: 'Người dùng', en: 'Total Users' },
  'stats.questions': { vi: 'Câu hỏi', en: 'Total Questions' },
  'stats.exams': { vi: 'Đề thi', en: 'Total Exams' },
  'stats.attempts': { vi: 'Lượt thi', en: 'Attempts' },
  'stats.inSystem': { vi: 'trong hệ thống', en: 'in the system' },
  'stats.chart': { vi: 'Điểm trung bình theo đề thi', en: 'Average Score by Exam' },
  'stats.byExam': { vi: 'Chi tiết theo từng đề thi', en: 'Per-exam Details' },
  'stats.exam': { vi: 'Đề thi', en: 'Exam' },
  'stats.avg': { vi: 'Điểm TB', en: 'Avg Score' },
  'stats.passed': { vi: 'Đậu', en: 'Passed' },
  'stats.passRate': { vi: 'Tỉ lệ đậu', en: 'Pass Rate' },
  'stats.noData': { vi: 'Chưa có dữ liệu.', en: 'No data yet.' },
};

// Dịch vụ đa ngôn ngữ nhẹ: i18n.t('key') trả về chuỗi theo ngôn ngữ hiện tại.
@Injectable({ providedIn: 'root' })
export class I18nService {
  lang = signal<Lang>((localStorage.getItem('lang') as Lang) || 'vi');

  t(key: string): string {
    const entry = DICT[key];
    if (!entry) return key;
    return entry[this.lang()];
  }

  toggle() {
    const l: Lang = this.lang() === 'vi' ? 'en' : 'vi';
    this.lang.set(l);
    localStorage.setItem('lang', l);
  }
}
