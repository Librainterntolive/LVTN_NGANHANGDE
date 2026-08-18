import { Component, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { DatePipe } from '@angular/common';
import { Source, SourceService } from '../../services/source.service';
import { ToastService } from '../../services/toast.service';
import { Paginator } from '../../shared/paginator';

@Component({
  selector: 'app-source-manager',
  imports: [FormsModule, DatePipe, Paginator],
  templateUrl: './source-manager.html',
})
export class SourceManager implements OnInit {
  private sourcesApi = inject(SourceService);
  private toast = inject(ToastService);

  sources = signal<Source[]>([]);
  total = signal(0);
  loading = signal(false);
  keyword = '';
  page = signal(1);
  limit = signal(10);

  ngOnInit() { this.load(); }

  load() {
    if (this.loading()) return;
    this.loading.set(true);
    this.sourcesApi.getPaged(this.page(), this.limit(), this.keyword).subscribe({
      next: result => {
        this.sources.set(result.items ?? []);
        this.total.set(result.total ?? 0);
        this.loading.set(false);
      },
      error: () => { this.loading.set(false); this.toast.error('Không tải được danh sách nguồn.'); },
    });
  }

  // Đổi từ khóa thì quay về trang 1, nếu không sẽ rơi vào trang trống.
  search() { this.page.set(1); this.load(); }
  goToPage(page: number) { this.page.set(page); this.load(); }
  setLimit(limit: number) { this.limit.set(limit); this.page.set(1); this.load(); }

  review(source: Source, status: 'verified' | 'rejected') {
    if (!source.id) return;
    this.sourcesApi.review(source.id, status).subscribe({
      next: updated => {
        this.sources.update(items => items.map(item => item.id === updated.id ? updated : item));
        this.toast.success(status === 'verified' ? 'Đã xác thực nguồn.' : 'Đã từ chối nguồn.');
      },
      error: error => this.toast.error(error?.error?.error ?? 'Không thể cập nhật nguồn.'),
    });
  }

  statusLabel(status?: string) {
    return status === 'verified' ? 'Đã xác thực' : status === 'rejected' ? 'Từ chối' : 'Chờ xác thực';
  }
}
