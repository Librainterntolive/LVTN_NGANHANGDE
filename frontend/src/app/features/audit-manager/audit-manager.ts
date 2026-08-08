import { Component, OnInit, inject, signal } from '@angular/core';
import { DatePipe } from '@angular/common';
import { AuditLog, AuditService } from '../../services/audit.service';
import { ToastService } from '../../services/toast.service';
import { InfiniteScrollDirective } from '../../shared/infinite-scroll.directive';
import { Icon } from '../../shared/icon';

@Component({
  selector: 'app-audit-manager',
  imports: [DatePipe, InfiniteScrollDirective, Icon],
  templateUrl: './audit-manager.html',
})
export class AuditManager implements OnInit {
  private auditApi = inject(AuditService);
  private toast = inject(ToastService);

  logs = signal<AuditLog[]>([]);
  total = signal(0);
  loading = signal(false);
  action = signal('');
  private page = 1;

  ngOnInit() { this.load(); }

  load(reset = true) {
    if (this.loading()) return;
    const page = reset ? 1 : this.page + 1;
    this.loading.set(true);
    this.auditApi.getPaged(page, 12, this.action()).subscribe({
      next: result => {
        this.logs.set(reset ? (result.items ?? []) : [...this.logs(), ...(result.items ?? [])]);
        this.total.set(result.total ?? 0);
        this.page = page;
        this.loading.set(false);
      },
      error: () => { this.loading.set(false); this.toast.error('Không thể tải nhật ký hệ thống.'); },
    });
  }

  setAction(action: string) {
    this.action.set(action);
    this.load();
  }

  hasMore() { return this.logs().length < this.total(); }

  actionLabel(action: string) {
    const labels: Record<string, string> = {
      'source.created': 'Khai báo nguồn', 'source.reviewed': 'Kiểm duyệt nguồn',
      'question.created': 'Tạo câu hỏi', 'question.updated': 'Sửa câu hỏi',
      'question.deleted': 'Xóa câu hỏi', 'question.submitted': 'Gửi duyệt',
      'question.reviewed': 'Duyệt câu hỏi', 'password_reset.approved': 'Duyệt cấp lại mật khẩu',
		'class.created': 'Tạo lớp học', 'class.updated': 'Sửa lớp học', 'class.deleted': 'Xóa lớp học',
		'class.student_added': 'Thêm sinh viên', 'class.student_removed': 'Xóa sinh viên', 'class.joined': 'Tham gia lớp',
		'class.post_created': 'Đăng thông báo lớp', 'class.post_updated': 'Sửa thông báo lớp', 'class.post_deleted': 'Xóa thông báo lớp',
		'exam.created': 'Tạo đề thi', 'exam.built': 'Soạn đề từ kho', 'exam.generated': 'Sinh đề theo ma trận',
		'exam.updated': 'Sửa đề thi', 'exam.deleted': 'Xóa đề thi', 'exam.cloned': 'Nhân bản đề thi',
		'assignment.created': 'Tạo bài tập', 'assignment.updated': 'Sửa bài tập', 'assignment.deleted': 'Xóa bài tập',
		'assignment.submitted': 'Nộp bài tập', 'assignment.graded': 'Chấm bài tập',
		'user.created': 'Tạo tài khoản', 'user.updated': 'Cập nhật tài khoản', 'user.deleted': 'Xóa tài khoản',
    };
    return labels[action] ?? action;
  }
}
