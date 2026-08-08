import { Component, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { DatePipe } from '@angular/common';
import { Source, SourceService } from '../../services/source.service';
import { ToastService } from '../../services/toast.service';
import { InfiniteScrollDirective } from '../../shared/infinite-scroll.directive';

@Component({
  selector: 'app-source-manager',
  imports: [FormsModule, DatePipe, InfiniteScrollDirective],
  templateUrl: './source-manager.html',
})
export class SourceManager implements OnInit {
  private sourcesApi = inject(SourceService);
  private toast = inject(ToastService);

  sources = signal<Source[]>([]);
  total = signal(0);
  loading = signal(false);
  keyword = '';
  private page = 1;

  ngOnInit() { this.load(); }

  load(reset = true) {
    if (this.loading()) return;
    const page = reset ? 1 : this.page + 1;
    this.loading.set(true);
    this.sourcesApi.getPaged(page, 12, this.keyword).subscribe({
      next: result => {
        this.sources.set(reset ? (result.items ?? []) : [...this.sources(), ...(result.items ?? [])]);
        this.total.set(result.total ?? 0);
        this.page = page;
        this.loading.set(false);
      },
      error: () => { this.loading.set(false); this.toast.error('Không tải được danh sách nguồn.'); },
    });
  }

  hasMore() { return this.sources().length < this.total(); }

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
