import { Injectable, signal } from '@angular/core';

// Bật chế độ toàn màn hình (ẩn sidebar + topbar) — dùng khi đang làm bài thi.
@Injectable({ providedIn: 'root' })
export class LayoutService {
  fullscreen = signal<boolean>(false);
}
