import { Injectable, signal } from '@angular/core';

interface DialogState {
  type: 'confirm' | 'prompt';
  title: string;
  message: string;
  value: string;            // dùng cho prompt (ô nhập)
  resolve: (v: any) => void;
}

// Hộp thoại tùy biến (thay window.confirm / window.prompt) để không hiện "localhost says".
@Injectable({ providedIn: 'root' })
export class DialogService {
  state = signal<DialogState | null>(null);

  // hỏi Yes/No -> trả về boolean
  confirm(title: string, message = ''): Promise<boolean> {
    return new Promise((resolve) =>
      this.state.set({ type: 'confirm', title, message, value: '', resolve })
    );
  }

  // nhập 1 chuỗi -> trả về string hoặc null (nếu hủy)
  prompt(title: string, defaultValue = ''): Promise<string | null> {
    return new Promise((resolve) =>
      this.state.set({ type: 'prompt', title, message: '', value: defaultValue, resolve })
    );
  }

  ok() {
    const s = this.state();
    if (!s) return;
    s.resolve(s.type === 'prompt' ? s.value : true);
    this.state.set(null);
  }

  cancel() {
    const s = this.state();
    if (!s) return;
    s.resolve(s.type === 'prompt' ? null : false);
    this.state.set(null);
  }
}
