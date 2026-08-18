import { Component, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ClassService, AppClass } from '../../services/class.service';
import { RouterLink } from '@angular/router';
import { Paginator } from '../../shared/paginator';
import { ToastService } from '../../services/toast.service';
import { Icon } from '../../shared/icon';

@Component({
  selector: 'app-my-classes',
  imports: [FormsModule, RouterLink, Paginator, Icon],
  templateUrl: './my-classes.html',
})
export class MyClasses implements OnInit {
  private service = inject(ClassService);
  private toast = inject(ToastService);

  classes = signal<AppClass[]>([]);
  total = signal(0);
  page = signal(1);
  limit = signal(10);
  loading = signal(false);
  code = '';
  message = signal<string>('');
  error = signal<string>('');
  listError = signal<string>('');
  joining = signal(false);

  ngOnInit() { this.load(); }

  load() {
    if (this.loading()) return;
    this.listError.set('');
    this.loading.set(true);
    this.service.getMyClassesPaged(this.page(), this.limit()).subscribe({
      next: (result) => {
        this.classes.set(result.items ?? []);
        this.total.set(result.total ?? 0);
        this.loading.set(false);
      },
      error: () => { this.loading.set(false); this.listError.set('Không tải được danh sách lớp học. Vui lòng thử lại.'); },
    });
  }

  goToPage(page: number) { this.page.set(page); this.load(); }
  setLimit(limit: number) { this.limit.set(limit); this.page.set(1); this.load(); }

  join() {
    if (this.joining()) return;
    this.message.set(''); this.error.set('');
    if (!this.code.trim()) { this.error.set('Nhập mã lớp'); return; }
    this.joining.set(true);
    this.service.joinByCode(this.code.trim().toUpperCase()).subscribe({
      next: () => { this.joining.set(false); this.message.set('Tham gia lớp thành công!'); this.toast.success('Đã tham gia lớp học.'); this.code = ''; this.page.set(1); this.load(); },
      error: (e) => { this.joining.set(false); const message = e?.error?.error ?? 'Mã lớp không đúng'; this.error.set(message); this.toast.error(message); },
    });
  }
}
