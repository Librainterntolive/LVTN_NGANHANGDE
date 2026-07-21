import { Injectable, signal } from '@angular/core';

export type ThemeMode = 'auto' | 'light' | 'dark';

// Quản lý giao diện sáng/tối: auto = theo hệ điều hành, hoặc người dùng tự bật.
@Injectable({ providedIn: 'root' })
export class ThemeService {
  mode = signal<ThemeMode>((localStorage.getItem('theme_mode') as ThemeMode) || 'auto');
  isDark = signal<boolean>(false);

  private media = window.matchMedia('(prefers-color-scheme: dark)');

  constructor() {
    // hệ điều hành đổi theme -> cập nhật nếu đang ở chế độ auto
    this.media.addEventListener('change', () => {
      if (this.mode() === 'auto') this.apply();
    });
    this.apply();
  }

  setMode(m: ThemeMode) {
    this.mode.set(m);
    localStorage.setItem('theme_mode', m);
    this.apply();
  }

  // bật/tắt bằng công tắc (chuyển sang chế độ thủ công)
  toggleDark() {
    this.setMode(this.isDark() ? 'light' : 'dark');
  }

  private apply() {
    const dark = this.mode() === 'auto' ? this.media.matches : this.mode() === 'dark';
    this.isDark.set(dark);
    document.documentElement.setAttribute('data-theme', dark ? 'dark' : 'light');
  }
}
