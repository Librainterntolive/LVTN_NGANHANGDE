// Dựng thật từng màn hình có dùng phân trang / ô chọn có tìm kiếm.
//
// Vì sao cần: `ng build` xanh KHÔNG bảo đảm màn hình chạy được. Một input của
// component dùng chung từng được đặt tên `valueOf` — trùng hàm có sẵn trên
// Object.prototype — nên Angular ném lỗi ngay lúc dựng và bốn màn hình trắng
// trơn, trong khi build vẫn báo thành công. Bài kiểm thử này chặn đúng loại lỗi
// đó: chỉ cần component dựng được là đạt, không kiểm tra nội dung.
//
// Gọi API thất bại trong môi trường test là bình thường (không có máy chủ);
// điều được kiểm ở đây là màn hình không ném lỗi khi dựng.
import { TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { provideRouter } from '@angular/router';
import { ActivatedRoute } from '@angular/router';
import { Type } from '@angular/core';

import { Exams } from '../features/exams/exams';
import { Questions } from '../features/questions/questions';
import { Stats } from '../features/stats/stats';
import { MyStorage } from '../features/my-storage/my-storage';
import { Subjects } from '../features/subjects/subjects';
import { Users } from '../features/users/users';
import { SourceManager } from '../features/source-manager/source-manager';
import { AuditManager } from '../features/audit-manager/audit-manager';
import { MyClasses } from '../features/my-classes/my-classes';
import { MyExams } from '../features/my-exams/my-exams';
import { MySubmissions } from '../features/my-submissions/my-submissions';
import { Classes } from '../features/classes/classes';
import { ClassDetail } from '../features/class-detail/class-detail';
import { SubjectDetail } from '../features/subject-detail/subject-detail';

const routeStub = { snapshot: { paramMap: { get: () => '1' }, queryParamMap: { get: () => null } } };

const screens: [string, Type<unknown>][] = [
  ['Đề thi', Exams],
  ['Ngân hàng câu hỏi', Questions],
  ['Thống kê', Stats],
  ['Góc học tập', MyStorage],
  ['Học phần', Subjects],
  ['Người dùng', Users],
  ['Nguồn tài liệu', SourceManager],
  ['Nhật ký hệ thống', AuditManager],
  ['Lớp học', Classes],
  ['Chi tiết lớp', ClassDetail],
  ['Chi tiết học phần', SubjectDetail],
  ['Lớp của tôi', MyClasses],
  ['Đề của tôi', MyExams],
  ['Bài nộp của tôi', MySubmissions],
];

describe('màn hình dựng được', () => {
  beforeEach(() => {
    localStorage.clear();
  });

  for (const [name, screen] of screens) {
    it(`${name}`, async () => {
      await TestBed.configureTestingModule({
        imports: [screen],
        providers: [
          provideHttpClient(),
          provideRouter([]),
          { provide: ActivatedRoute, useValue: routeStub },
        ],
      }).compileComponents();

      const fixture = TestBed.createComponent(screen);
      fixture.detectChanges();
      expect(fixture.componentInstance).toBeTruthy();
    });
  }
});
