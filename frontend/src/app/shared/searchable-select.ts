import {
  Component, ElementRef, HostListener, computed, effect, inject, input, model, signal,
} from '@angular/core';
import { Observable, Subject, debounceTime, switchMap } from 'rxjs';

// Combobox có ô gõ để tìm, thay cho thẻ <select> thường.
//
// Vì sao cần: <select> buộc người dùng lướt mắt qua từng dòng. Với 29 học phần
// đã khó, với hàng nghìn dòng thì không dùng được — chưa kể trước đây danh sách
// chỉ tải 12 mục mỗi lần nên mục thứ 13 trở đi đơn giản là không có trong ô chọn
// cho tới khi bấm "Tải thêm".
//
// Ở đây gõ tới đâu hỏi máy chủ tới đó (có chờ 250ms để không bắn request theo
// từng phím), nên số lượng bản ghi không còn ảnh hưởng tới thao tác chọn.
//
// Dùng:
//   <app-searchable-select
//     [(value)]="form.subject_id"
//     [fetch]="fetchSubjects"
//     [displayLabel]="subjectName(form.subject_id)"
//     placeholder="Chọn học phần" />
//
// fetch phải là arrow function thuộc tính của component cha (để giữ đúng this).
export interface SearchPage {
  items: any[];
  total: number;
}

@Component({
  selector: 'app-searchable-select',
  styles: [`
    :host { display: block; position: relative; }
    .field {
      display: flex; align-items: center; gap: var(--sp-1);
      border: 1px solid var(--border); border-radius: var(--r-sm);
      background: var(--surface-2); padding: 0 var(--sp-1) 0 0;
    }
    .field:focus-within { border-color: var(--accent); }
    .field.disabled { opacity: .6; }
    input {
      flex: 1; min-width: 0; border: none; background: transparent; color: var(--text);
      font: inherit; font-size: var(--fs-md); padding: 8px 10px; outline: none;
    }
    input::placeholder { color: var(--text-3); }
    .icon-btn {
      border: none; background: transparent; color: var(--text-3);
      cursor: pointer; padding: 2px 6px; font-size: var(--fs-md); line-height: 1; border-radius: var(--r-sm);
    }
    .icon-btn:hover { color: var(--text); background: var(--surface); }
    .menu {
      position: absolute; z-index: 40; left: 0; right: 0; top: calc(100% + 2px);
      max-height: 260px; overflow-y: auto;
      background: var(--surface); border: 1px solid var(--border);
      border-radius: var(--r-md); box-shadow: var(--shadow-lg); padding: var(--sp-1);
    }
    .opt {
      padding: 8px 10px; border-radius: var(--r-sm); cursor: pointer;
      font-size: var(--fs-md); color: var(--text);
    }
    .opt:hover, .opt.active { background: var(--surface-2); }
    .opt.chosen { font-weight: 600; }
    .note { padding: 8px 10px; font-size: var(--fs-sm); color: var(--text-3); }
    .more { padding: var(--sp-1); }
    .more button {
      width: 100%; padding: 6px; font-size: var(--fs-sm);
      border: 1px dashed var(--border); border-radius: var(--r-sm);
      background: transparent; color: var(--text-2); cursor: pointer;
    }
  `],
  template: `
    <div class="field" [class.disabled]="disabled()">
      <input
        #box
        type="text"
        role="combobox"
        aria-autocomplete="list"
        [attr.aria-expanded]="open()"
        [attr.aria-controls]="listId"
        [attr.aria-activedescendant]="open() && activeIndex() >= 0 ? listId + '-opt-' + activeIndex() : null"
        [disabled]="disabled()"
        [value]="text()"
        [placeholder]="placeholder()"
        (input)="onType($event)"
        (focus)="openMenu()"
        (keydown)="onKey($event)" />

      @if (allowClear() && hasValue() && !disabled()) {
        <button type="button" class="icon-btn" (click)="clear()" aria-label="Xóa lựa chọn" title="Xóa lựa chọn">×</button>
      }
      <button type="button" class="icon-btn" (click)="toggle()" [disabled]="disabled()" aria-label="Mở danh sách" tabindex="-1">▾</button>
    </div>

    @if (open()) {
      <div class="menu" role="listbox" [id]="listId">
        @if (loading() && !items().length) { <p class="note">Đang tìm…</p> }
        @else if (!items().length) { <p class="note">{{ emptyLabel() }}</p> }

        @for (item of items(); track $index) {
          <div
            class="opt"
            role="option"
            [id]="listId + '-opt-' + $index"
            [class.active]="$index === activeIndex()"
            [class.chosen]="idOf()(item) === value()"
            [attr.aria-selected]="idOf()(item) === value()"
            (mouseenter)="activeIndex.set($index)"
            (mousedown)="$event.preventDefault()"
            (click)="choose(item)">{{ labelOf()(item) }}</div>
        }

        @if (items().length < total()) {
          <div class="more">
            <button type="button" (click)="loadMore()" [disabled]="loading()">
              {{ loading() ? 'Đang tải…' : 'Tải thêm (' + items().length + '/' + total() + ')' }}
            </button>
          </div>
        }
      </div>
    }
  `,
})
export class SearchableSelect {
  private host = inject(ElementRef<HTMLElement>);

  // Giá trị đang chọn (thường là id). Hai chiều: [(value)]
  value = model<any>(null);

  // Hàm gọi API. Nhận từ khóa và số trang, trả về trang kết quả.
  fetch = input.required<(keyword: string, page: number, limit: number) => Observable<SearchPage>>();

  labelOf = input<(item: any) => string>((item) => item?.name ?? item?.title ?? String(item));
  // KHÔNG đặt tên input là valueOf: Angular gom input/output vào một object
  // thường, mà valueOf lại là hàm có sẵn trên Object.prototype nên bảng binding
  // trả về hàm kế thừa thay vì mảng, làm hỏng toàn bộ màn hình lúc dựng.
  idOf = input<(item: any) => any>((item) => item?.id);

  // Nhãn của giá trị đang chọn khi mục đó chưa nằm trong trang kết quả hiện tại
  // (ví dụ mở form sửa: chỉ có id, chưa gọi API lần nào).
  displayLabel = input<string>('');
  placeholder = input<string>('Gõ để tìm…');
  emptyLabel = input<string>('Không tìm thấy mục nào');
  disabled = input<boolean>(false);
  allowClear = input<boolean>(true);
  limit = input<number>(10);
  // Nhiều form trong hệ thống dùng 0 nghĩa là "chưa chọn", số khác thì dùng null.
  clearValue = input<any>(0);

  readonly listId = 'ss-' + Math.random().toString(36).slice(2, 9);

  open = signal(false);
  loading = signal(false);
  items = signal<any[]>([]);
  total = signal(0);
  activeIndex = signal(-1);
  keyword = signal('');
  private page = 1;
  private chosenLabel = signal<string>('');

  private queries = new Subject<{ keyword: string; page: number }>();

  // Chữ hiện trong ô: đang mở thì hiện từ khóa đang gõ, đóng lại thì hiện nhãn
  // của mục đã chọn.
  text = computed(() => (this.open() ? this.keyword() : this.currentLabel()));
  currentLabel = computed(() => this.chosenLabel() || this.displayLabel());
  hasValue = computed(() => this.value() !== null && this.value() !== undefined && this.value() !== 0 && this.value() !== '');

  constructor() {
    this.queries
      .pipe(
        debounceTime(250),
        switchMap(({ keyword, page }) => {
          this.loading.set(true);
          return this.fetch()(keyword, page, this.limit());
        }),
      )
      .subscribe({
        next: (result) => {
          const list = result?.items ?? [];
          this.items.set(this.page === 1 ? list : [...this.items(), ...list]);
          this.total.set(result?.total ?? list.length);
          this.activeIndex.set(list.length ? 0 : -1);
          this.loading.set(false);
        },
        error: () => { this.loading.set(false); this.total.set(0); },
      });

    // Cha xóa giá trị (ví dụ bấm Hủy form) thì nhãn đã chọn cũng phải mất theo.
    effect(() => {
      if (!this.hasValue()) this.chosenLabel.set('');
    });
  }

  openMenu() {
    if (this.disabled() || this.open()) return;
    this.open.set(true);
    this.keyword.set('');
    this.reload('');
  }

  toggle() {
    if (this.open()) { this.close(); return; }
    this.openMenu();
  }

  close() {
    this.open.set(false);
    this.activeIndex.set(-1);
  }

  onType(event: Event) {
    const keyword = (event.target as HTMLInputElement).value;
    this.keyword.set(keyword);
    if (!this.open()) this.open.set(true);
    this.reload(keyword);
  }

  private reload(keyword: string) {
    this.page = 1;
    this.items.set([]);
    this.queries.next({ keyword, page: 1 });
  }

  loadMore() {
    if (this.loading() || this.items().length >= this.total()) return;
    this.page++;
    this.queries.next({ keyword: this.keyword(), page: this.page });
  }

  choose(item: any) {
    this.value.set(this.idOf()(item));
    this.chosenLabel.set(this.labelOf()(item));
    this.close();
  }

  clear() {
    this.value.set(this.clearValue());
    this.chosenLabel.set('');
    this.close();
  }

  onKey(event: KeyboardEvent) {
    if (event.key === 'ArrowDown' || event.key === 'ArrowUp') {
      event.preventDefault();
      if (!this.open()) { this.openMenu(); return; }
      const count = this.items().length;
      if (!count) return;
      const step = event.key === 'ArrowDown' ? 1 : -1;
      this.activeIndex.set((this.activeIndex() + step + count) % count);
      return;
    }
    if (event.key === 'Enter') {
      if (!this.open()) return;
      event.preventDefault();
      const item = this.items()[this.activeIndex()];
      if (item) this.choose(item);
      return;
    }
    if (event.key === 'Escape') {
      if (!this.open()) return;
      event.preventDefault();
      this.close();
      return;
    }
    if (event.key === 'Tab') this.close();
  }

  @HostListener('document:click', ['$event'])
  onDocumentClick(event: MouseEvent) {
    if (!this.open()) return;
    if (!this.host.nativeElement.contains(event.target as Node)) this.close();
  }
}
