import { Component, computed, input, output } from '@angular/core';

// Thanh phân trang dùng chung cho mọi danh sách.
//
// Vì sao thay cuộn-vô-tận: khi ngân hàng có hàng nghìn dòng, cuộn-vô-tận buộc
// người dùng tải tuần tự từ đầu mới tới được dòng ở giữa, và không có cách nào
// quay lại đúng chỗ vừa xem. Số trang cho biết tổng số trang và nhảy thẳng được.
//
// Component chỉ hiển thị và phát sự kiện; việc gọi API do màn hình cha lo.
@Component({
  selector: 'app-paginator',
  styles: [`
    .pager {
      display: flex; flex-wrap: wrap; align-items: center; gap: var(--sp-3);
      justify-content: space-between; margin-top: var(--sp-4);
      font-size: var(--fs-sm); color: var(--text-2);
    }
    .pages { display: flex; flex-wrap: wrap; align-items: center; gap: var(--sp-1); }
    .pages button {
      min-width: 34px; padding: 6px 10px; font-size: var(--fs-sm);
      border: 1px solid var(--border); border-radius: var(--r-sm);
      background: var(--surface); color: var(--text); cursor: pointer;
    }
    .pages button:hover:not(:disabled):not(.current) { background: var(--surface-2); }
    .pages button.current {
      background: var(--accent); border-color: var(--accent);
      color: var(--on-accent); font-weight: 600; cursor: default;
    }
    .pages button:disabled { opacity: .45; cursor: not-allowed; background: var(--surface); color: var(--text-3); }
    .gap { padding: 0 var(--sp-1); color: var(--text-3); }
    .size { display: flex; align-items: center; gap: var(--sp-2); }
    .size select {
      padding: 5px 8px; font-size: var(--fs-sm); border-radius: var(--r-sm);
      border: 1px solid var(--border); background: var(--surface); color: var(--text);
    }
    .count { color: var(--text-3); font-size: var(--fs-xs); }
  `],
  template: `
    @if (total() > 0) {
      <nav class="pager" role="navigation" aria-label="Phân trang">
        <div class="size">
          <label>
            Mỗi trang
            <!-- Đánh dấu chọn trên từng option, không đặt [value] cho cả thẻ select:
                 select được gán giá trị trước khi các option kịp dựng nên ô luôn
                 hiện giá trị đầu danh sách thay vì số dòng đang dùng. -->
            <select (change)="onLimit($event)" aria-label="Số dòng mỗi trang">
              @for (size of pageSizes(); track size) {
                <option [value]="size" [selected]="size === limit()">{{ size }}</option>
              }
            </select>
          </label>
          <span class="count">{{ fromItem() }}–{{ toItem() }} trên {{ total() }}</span>
        </div>

        @if (totalPages() > 1) {
          <div class="pages">
            <button type="button" (click)="go(page() - 1)" [disabled]="page() <= 1" aria-label="Trang trước">‹ Trước</button>
            @for (item of pageItems(); track $index) {
              @if (item === 0) {
                <span class="gap" aria-hidden="true">…</span>
              } @else {
                <button
                  type="button"
                  [class.current]="item === page()"
                  [attr.aria-current]="item === page() ? 'page' : null"
                  [disabled]="item === page()"
                  (click)="go(item)">{{ item }}</button>
              }
            }
            <button type="button" (click)="go(page() + 1)" [disabled]="page() >= totalPages()" aria-label="Trang sau">Sau ›</button>
          </div>
        }
      </nav>
    }
  `,
})
export class Paginator {
  total = input.required<number>();
  page = input.required<number>();
  limit = input<number>(10);
  pageSizes = input<number[]>([5, 10, 20, 50]);

  pageChange = output<number>();
  limitChange = output<number>();

  totalPages = computed(() => Math.max(1, Math.ceil(this.total() / Math.max(1, this.limit()))));
  fromItem = computed(() => (this.total() === 0 ? 0 : (this.page() - 1) * this.limit() + 1));
  toItem = computed(() => Math.min(this.total(), this.page() * this.limit()));

  // Dãy số trang rút gọn: luôn có trang đầu, trang cuối và lân cận trang hiện
  // tại. Số 0 là dấu ba chấm — dùng 0 vì không trang nào mang số đó.
  pageItems = computed<number[]>(() => {
    const last = this.totalPages();
    const current = this.page();
    if (last <= 7) return Array.from({ length: last }, (_, i) => i + 1);

    const items: number[] = [1];
    const start = Math.max(2, current - 1);
    const end = Math.min(last - 1, current + 1);
    if (start > 2) items.push(0);
    for (let p = start; p <= end; p++) items.push(p);
    if (end < last - 1) items.push(0);
    items.push(last);
    return items;
  });

  go(page: number) {
    if (page < 1 || page > this.totalPages() || page === this.page()) return;
    this.pageChange.emit(page);
  }

  onLimit(event: Event) {
    const value = Number((event.target as HTMLSelectElement).value);
    if (!value || value === this.limit()) return;
    this.limitChange.emit(value);
  }
}
