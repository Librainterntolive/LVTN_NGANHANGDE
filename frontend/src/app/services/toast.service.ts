import { Injectable, signal } from '@angular/core';

export interface Toast {
  id: number;
  text: string;
  type: 'success' | 'error' | 'info';
}

// Thông báo dạng toast (popup nhỏ ở góc màn hình), tự ẩn sau vài giây.
@Injectable({ providedIn: 'root' })
export class ToastService {
  toasts = signal<Toast[]>([]);
  private counter = 0;

  show(text: string, type: Toast['type'] = 'info', ms = 3500) {
    const t: Toast = { id: ++this.counter, text, type };
    this.toasts.update((a) => [...a, t]);
    setTimeout(() => this.dismiss(t.id), ms);
  }
  success(text: string) { this.show(text, 'success'); }
  error(text: string) { this.show(text, 'error'); }
  info(text: string) { this.show(text, 'info'); }

  dismiss(id: number) {
    this.toasts.update((a) => a.filter((x) => x.id !== id));
  }
}
