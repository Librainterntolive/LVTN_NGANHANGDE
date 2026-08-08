import { Component, OnInit, inject, signal } from '@angular/core';
import { RouterLink } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { StudentService } from '../../services/student.service';
import { Exam } from '../../services/exam.service';
import { ClassService } from '../../services/class.service';
import { StatsService } from '../../services/stats.service';
import { Icon } from '../../shared/icon';

interface DashboardMetric { label: string; value: number; note: string; route: string; }

@Component({ selector: 'app-home', imports: [RouterLink, Icon], templateUrl: './home.html' })
export class Home implements OnInit {
  auth = inject(AuthService);
  private student = inject(StudentService);
  private classes = inject(ClassService);
  private stats = inject(StatsService);

  publicExams = signal<Exam[]>([]);
  metrics = signal<DashboardMetric[]>([]);
  dashboardWarning = signal('');
  publicLoadFailed = signal(false);

  ngOnInit() {
    const user = this.auth.currentUser();
    if (!user) {
      this.student.getPublicExamsPaged(1, 12).subscribe({
        next: result => this.publicExams.set(result.items ?? []),
        error: () => this.publicLoadFailed.set(true),
      });
      return;
    }
    if (user.role === 'Student') {
      this.loadStudentMetrics();
      return;
    }
    this.loadStaffMetrics(user.role === 'Admin');
  }

  private loadStudentMetrics() {
    this.classes.getMyClassesPaged(1, 1).subscribe({ next: result => this.addMetric('Lớp học', result.total, 'đã tham gia', '/my-classes'), error: () => this.reportDashboardError() });
    this.student.getMyExamsPaged(1, 1).subscribe({ next: result => this.addMetric('Bài cần làm', result.total, 'đề được giao', '/my-exams'), error: () => this.reportDashboardError() });
    this.student.getMyStats().subscribe({ next: result => {
      this.addMetric('Lượt làm bài', result.attempts, 'lịch sử học tập', '/my-submissions');
      this.addMetric('Điểm trung bình', Math.round(result.avg_score * 10) / 10, 'trên thang điểm 10', '/my-submissions');
      this.addMetric('Chuỗi học tập', result.streak_days, 'ngày liên tiếp', '/my-storage');
    }, error: () => this.reportDashboardError(),
    });
  }

  private loadStaffMetrics(isAdmin: boolean) {
    this.classes.getPaged(1, 1).subscribe({ next: result => this.addMetric('Lớp học', result.total, 'đang quản lý', '/classes'), error: () => this.reportDashboardError() });
    this.stats.getOverview().subscribe({ next: result => {
      this.addMetric(isAdmin ? 'Tài khoản' : 'Sinh viên', result.total_users, isAdmin ? 'trong hệ thống' : 'thuộc các lớp của bạn', isAdmin ? '/users' : '/classes');
      this.addMetric('Đề thi', result.total_exams, 'đã tạo', '/exams');
      this.addMetric('Câu hỏi', result.total_questions, 'trong ngân hàng của bạn', '/questions');
      this.addMetric('Đã duyệt', result.total_approved_questions, 'câu hỏi đủ điều kiện dùng', '/questions');
      this.addMetric('Nguồn xác thực', result.total_verified_sources, isAdmin ? 'đã được kiểm duyệt' : 'nguồn của bạn đã xác thực', isAdmin ? '/sources' : '/questions');
      this.addMetric('Lượt làm bài', result.total_submissions, 'đã ghi nhận', '/stats');
    }, error: () => this.reportDashboardError(),
    });
  }

  private addMetric(label: string, value: number, note: string, route: string) {
    this.metrics.update(rows => [...rows, { label, value, note, route }]);
  }

  private reportDashboardError() {
    this.dashboardWarning.set('Một số số liệu chưa tải được. Kiểm tra kết nối rồi tải lại trang để cập nhật.');
  }
}
