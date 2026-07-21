import { Component, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { SubjectService, Subject } from '../../services/subject.service';
import { AuthService } from '../../services/auth.service';
import { DialogService } from '../../services/dialog.service';

@Component({
  selector: 'app-subjects',
  imports: [FormsModule, RouterLink],
  templateUrl: './subjects.html',
})
export class Subjects implements OnInit {
  private service = inject(SubjectService);
  private auth = inject(AuthService);
  private dialog = inject(DialogService);

  subjects = signal<Subject[]>([]);
  error = signal<string>('');

  // các khối hướng tới Cấp 3 + Đại học
  levels = ['Khối 10', 'Khối 11', 'Khối 12', 'Đại học', 'Khác'];
  filterLevel = '';
  keyword = '';

  // form thêm/sửa
  form: Subject = this.empty();
  editingId = signal<number | null>(null);
  showForm = signal<boolean>(false);

  empty(): Subject { return { name: '', level: 'Khối 10', description: '' }; }

  isStaff(): boolean {
    const r = this.auth.getRole();
    return r === 'Admin' || r === 'Teacher';
  }

  ngOnInit() { this.load(); }

  load() {
    this.service.getAll().subscribe({
      next: (data) => this.subjects.set(data ?? []),
      error: () => this.error.set('Không gọi được API. Backend đã chạy chưa?'),
    });
  }

  // lọc theo khối + từ khóa
  filtered(): Subject[] {
    return this.subjects().filter((s) => {
      const okLevel = !this.filterLevel || s.level === this.filterLevel;
      const okKw = !this.keyword || s.name.toLowerCase().includes(this.keyword.toLowerCase());
      return okLevel && okKw;
    });
  }

  // đếm số môn theo khối (cho chip)
  countLevel(lv: string): number {
    return this.subjects().filter((s) => s.level === lv).length;
  }

  // màu nhãn theo khối
  levelColor(level?: string): string {
    switch (level) {
      case 'Khối 10': return '#1976d2';
      case 'Khối 11': return '#7b1fa2';
      case 'Khối 12': return '#c2185b';
      case 'Đại học': return '#2e7d32';
      default: return '#607d8b';
    }
  }

  openAdd() { this.editingId.set(null); this.form = this.empty(); this.showForm.set(true); }
  edit(s: Subject) { this.editingId.set(s.id!); this.form = { ...s }; this.showForm.set(true); }
  cancel() { this.showForm.set(false); this.editingId.set(null); this.form = this.empty(); }

  save() {
    if (!this.form.name.trim()) { this.error.set('Nhập tên môn học'); return; }
    this.error.set('');
    const req = this.editingId()
      ? this.service.update(this.editingId()!, this.form)
      : this.service.create(this.form);
    req.subscribe({
      next: () => { this.cancel(); this.load(); },
      error: () => this.error.set('Lưu thất bại.'),
    });
  }

  remove(id?: number) {
    if (!id) return;
    this.dialog.confirm('Xóa môn học', 'Bạn chắc chắn muốn xóa môn học này?').then((ok) => {
      if (!ok) return;
      this.service.remove(id).subscribe({
        next: () => this.load(),
        error: () => this.error.set('Không xóa được (có thể môn đang có câu hỏi/đề thi).'),
      });
    });
  }
}
