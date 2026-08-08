import { Directive, ElementRef, EventEmitter, OnDestroy, AfterViewInit, Output, inject } from '@angular/core';

// Đặt directive này lên 1 thẻ "sentinel" ở cuối danh sách.
// Khi thẻ đó lọt vào màn hình (người dùng cuộn tới), phát sự kiện (scrolled).
@Directive({
  selector: '[appInfiniteScroll]',
})
export class InfiniteScrollDirective implements AfterViewInit, OnDestroy {
  @Output() scrolled = new EventEmitter<void>();
  private el = inject(ElementRef);
  private observer?: IntersectionObserver;
  private intersecting = false;

  ngAfterViewInit() {
    this.observer = new IntersectionObserver((entries) => {
      const entry = entries[0];
      if (!entry?.isIntersecting) {
        this.intersecting = false;
        return;
      }
      if (this.intersecting) return;
      this.intersecting = true;
      this.scrolled.emit();
    }, { rootMargin: '120px' });
    this.observer.observe(this.el.nativeElement);
  }

  ngOnDestroy() {
    this.observer?.disconnect();
  }
}
