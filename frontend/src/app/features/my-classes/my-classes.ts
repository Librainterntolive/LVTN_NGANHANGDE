import { Component, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ClassService, AppClass } from '../../services/class.service';
import { RouterLink } from '@angular/router';
import { InfiniteScrollDirective } from '../../shared/infinite-scroll.directive';
import { ToastService } from '../../services/toast.service';

@Component({
  selector: 'app-my-classes',
  imports: [FormsModule, RouterLink, InfiniteScrollDirective],
  templateUrl: './my-classes.html',
})
export class MyClasses implements OnInit {
  private service = inject(ClassService);
  private toast = inject(ToastService);

  classes = signal<AppClass[]>([]);
  total = signal(0);
  page = signal(1);
  loading = signal(false);
  code = '';
  message = signal<string>('');
  error = signal<string>('');
  listError = signal<string>('');
  joining = signal(false);

  ngOnInit() { this.load(); }

  load(reset = true) {
    if (this.loading()) return;
    const page = reset ? 1 : this.page() + 1;
    if (reset) this.listError.set('');
    this.loading.set(true);
    this.service.getMyClassesPaged(page).subscribe({
      next: (result) => {
        this.classes.set(reset ? (result.items ?? []) : [...this.classes(), ...(result.items ?? [])]);
        this.total.set(result.total ?? 0);
        this.page.set(page);
        this.loading.set(false);
      },
      error: () => { this.loading.set(false); this.listError.set('Không tải được danh sách lớp học. Vui lòng thử lại.'); },
    });
  }

  hasMore() { return this.classes().length < this.total(); }

  join() {
    if (this.joining()) return;
    this.message.set(''); this.error.set('');
    if (!this.code.trim()) { this.error.set('Nhập mã lớp'); return; }
    this.joining.set(true);
    this.service.joinByCode(this.code.trim().toUpperCase()).subscribe({
      next: () => { this.joining.set(false); this.message.set('Tham gia lớp thành công!'); this.toast.success('Đã tham gia lớp học.'); this.code = ''; this.load(true); },
      error: (e) => { this.joining.set(false); const message = e?.error?.error ?? 'Mã lớp không đúng'; this.error.set(message); this.toast.error(message); },
    });
  }
}
