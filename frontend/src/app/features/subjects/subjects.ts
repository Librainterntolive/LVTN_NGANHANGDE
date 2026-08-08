import { Component, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { SubjectService, Subject } from '../../services/subject.service';
import { AuthService } from '../../services/auth.service';
import { DialogService } from '../../services/dialog.service';
import { InfiniteScrollDirective } from '../../shared/infinite-scroll.directive';

@Component({
  selector: 'app-subjects',
  imports: [FormsModule, RouterLink, InfiniteScrollDirective],
  templateUrl: './subjects.html',
})
export class Subjects implements OnInit {
  private service = inject(SubjectService);
  private auth = inject(AuthService);
  private dialog = inject(DialogService);

  subjects = signal<Subject[]>([]);
  total = signal(0);
  loading = signal(false);
  error = signal('');
  keyword = '';
  private page = 1;

  form: Subject = this.empty();
  editingId = signal<number | null>(null);
  showForm = signal(false);

  empty(): Subject { return { name: '', level: 'Đại học', description: '' }; }

  isStaff(): boolean {
    const role = this.auth.getRole();
    return role === 'Admin' || role === 'Teacher';
  }

  ngOnInit() { this.load(); }

  load(reset = true) {
    if (this.loading()) return;
    if (reset) {
      this.page = 1;
      this.subjects.set([]);
      this.total.set(0);
    }
    this.loading.set(true);
    this.error.set('');
    this.service.getPaged(this.page, 12, this.keyword).subscribe({
      next: (result) => {
        this.subjects.update(items => [...items, ...(result.items ?? [])]);
        this.total.set(result.total ?? 0);
        this.loading.set(false);
      },
      error: () => {
        this.error.set('Không gọi được API. Hãy kiểm tra Backend đang chạy.');
        this.loading.set(false);
      },
    });
  }

  search() { this.load(true); }
  hasMore() { return this.subjects().length < this.total(); }
  loadMore() {
    if (this.loading() || !this.hasMore()) return;
    this.page++;
    this.load(false);
  }

  levelColor(): string { return 'linear-gradient(135deg, #3156c7, #6856c9)'; }

  openAdd() { this.editingId.set(null); this.form = this.empty(); this.showForm.set(true); }
  edit(subject: Subject) { this.editingId.set(subject.id!); this.form = { ...subject }; this.showForm.set(true); }
  cancel() { this.showForm.set(false); this.editingId.set(null); this.form = this.empty(); }

  save() {
    if (!this.form.name.trim()) { this.error.set('Nhập tên học phần trước khi lưu.'); return; }
    this.error.set('');
    const request = this.editingId()
      ? this.service.update(this.editingId()!, this.form)
      : this.service.create(this.form);
    request.subscribe({
      next: () => { this.cancel(); this.load(); },
      error: () => this.error.set('Không thể lưu học phần.'),
    });
  }

  remove(id?: number) {
    if (!id) return;
    this.dialog.confirm('Xóa học phần', 'Bạn chắc chắn muốn xóa học phần này?').then((confirmed) => {
      if (!confirmed) return;
      this.service.remove(id).subscribe({
        next: () => this.load(),
        error: () => this.error.set('Không thể xóa vì học phần đang có câu hỏi hoặc đề thi.'),
      });
    });
  }
}
