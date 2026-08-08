import { Component, Input } from '@angular/core';
import { DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { inject } from '@angular/core';

/**
 * Bộ biểu tượng dùng chung cho toàn hệ thống.
 *
 * Trước đây giao diện dùng emoji làm biểu tượng. Emoji do phông chữ của từng
 * hệ điều hành vẽ nên mỗi máy hiển thị một kiểu, độ dày nét và màu sắc không
 * đồng bộ với giao diện — đó là lý do phần mềm chuyên nghiệp không dùng emoji.
 *
 * Toàn bộ icon dưới đây vẽ trên khung 24x24, chỉ dùng nét (không tô), độ dày
 * 1.75 và lấy màu bằng currentColor nên tự đổi theo màu chữ và theme sáng/tối.
 */
const PATHS: Record<string, string> = {
  home: '<path d="M3 10.2 12 3l9 7.2"/><path d="M5.5 9.4V20h13V9.4"/><path d="M9.75 20v-5.5h4.5V20"/>',
  book: '<path d="M4 4.5A1.5 1.5 0 0 1 5.5 3H19v14H5.5A1.5 1.5 0 0 0 4 18.5z"/><path d="M4 18.5A1.5 1.5 0 0 1 5.5 17H19v4H5.5A1.5 1.5 0 0 1 4 19.5z"/>',
  'book-open': '<path d="M12 6.5C10.5 5 8.5 4.5 3.5 4.5v13C8.5 17.5 10.5 18 12 19.5"/><path d="M12 6.5c1.5-1.5 3.5-2 8.5-2v13c-5 0-7 .5-8.5 2z"/>',
  'help-circle': '<circle cx="12" cy="12" r="9"/><path d="M9.5 9.3a2.6 2.6 0 1 1 3.4 2.5c-.6.2-.9.7-.9 1.3v.6"/><path d="M12 17h.01"/>',
  building: '<path d="M4 21V6.5L12 3l8 3.5V21"/><path d="M2.5 21h19"/><path d="M9.5 21v-4.5h5V21"/><path d="M8 9.5h.01M12 9.5h.01M16 9.5h.01M8 13h.01M16 13h.01"/>',
  'file-text': '<path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8z"/><path d="M14 3v5h5"/><path d="M8.5 12.5h7M8.5 16h5"/>',
  file: '<path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8z"/><path d="M14 3v5h5"/>',
  'bar-chart': '<path d="M4 20h16"/><path d="M7 20v-6"/><path d="M12 20V6"/><path d="M17 20v-9"/>',
  user: '<circle cx="12" cy="8" r="3.5"/><path d="M5 20c0-3.6 3.1-5.5 7-5.5s7 1.9 7 5.5"/>',
  users: '<circle cx="9.5" cy="8.5" r="3"/><path d="M3.5 19.5c0-3.1 2.7-4.8 6-4.8s6 1.7 6 4.8"/><path d="M16.5 6.2a3 3 0 0 1 0 5.8"/><path d="M18 14.9c1.7.6 2.8 1.8 2.8 3.6"/>',
  'user-check': '<circle cx="10" cy="8" r="3.5"/><path d="M3.5 20c0-3.6 2.9-5.5 6.5-5.5 1 0 1.9.1 2.7.4"/><path d="m16 16.5 2 2 3.5-3.5"/>',
  search: '<circle cx="10.8" cy="10.8" r="6.3"/><path d="m15.5 15.5 4.5 4.5"/>',
  clipboard: '<path d="M9 4.5H7.5a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h9a2 2 0 0 0 2-2v-12a2 2 0 0 0-2-2H15"/><rect x="9" y="2.8" width="6" height="3.4" rx="1"/><path d="M9 11h6M9 14.5h4"/>',
  clock: '<circle cx="12" cy="12" r="9"/><path d="M12 7v5.2l3.2 2"/>',
  moon: '<path d="M20 14.2A8.2 8.2 0 0 1 9.8 4 8.4 8.4 0 1 0 20 14.2"/>',
  sun: '<circle cx="12" cy="12" r="4"/><path d="M12 2.5v2M12 19.5v2M2.5 12h2M19.5 12h2M5.2 5.2l1.4 1.4M17.4 17.4l1.4 1.4M18.8 5.2l-1.4 1.4M6.6 17.4l-1.4 1.4"/>',
  check: '<path d="m4.5 12.5 5 5 10-11"/>',
  'check-circle': '<circle cx="12" cy="12" r="9"/><path d="m8 12.2 2.7 2.7L16 9.5"/>',
  'x-circle': '<circle cx="12" cy="12" r="9"/><path d="m9 9 6 6M15 9l-6 6"/>',
  x: '<path d="m5.5 5.5 13 13M18.5 5.5l-13 13"/>',
  plus: '<path d="M12 5v14M5 12h14"/>',
  logout: '<path d="M14.5 4.5h3a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2h-3"/><path d="M10 8.5 6 12l4 3.5"/><path d="M6 12h8.5"/>',
  menu: '<path d="M4 7h16M4 12h16M4 17h16"/>',
  alert: '<path d="M12 4.2 21 19H3z"/><path d="M12 10v4"/><path d="M12 16.8h.01"/>',
  folder: '<path d="M3.5 7.5a2 2 0 0 1 2-2h3.2l2 2.3h7.8a2 2 0 0 1 2 2v8.7a2 2 0 0 1-2 2h-13a2 2 0 0 1-2-2z"/>',
  archive: '<rect x="3.2" y="4.5" width="17.6" height="4.2" rx="1.2"/><path d="M5 8.7v9.3a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8.7"/><path d="M10 12.5h4"/>',
  pencil: '<path d="M16.4 4.6a2 2 0 0 1 2.8 2.8L8.4 18.2 4 19.5l1.3-4.4z"/>',
  trash: '<path d="M4.5 7h15"/><path d="M9.5 7V5.4a1.4 1.4 0 0 1 1.4-1.4h2.2A1.4 1.4 0 0 1 14.5 5.4V7"/><path d="M6.5 7v11.6A1.4 1.4 0 0 0 7.9 20h8.2a1.4 1.4 0 0 0 1.4-1.4V7"/><path d="M10.5 11v5M13.5 11v5"/>',
  printer: '<path d="M7 9V4h10v5"/><path d="M7 17H5.5a2 2 0 0 1-2-2v-4a2 2 0 0 1 2-2h13a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2H17"/><path d="M7 14h10v6H7z"/>',
  download: '<path d="M12 4v10.5"/><path d="m7.8 10.8 4.2 4.2 4.2-4.2"/><path d="M4.5 19.5h15"/>',
  upload: '<path d="M12 19.5V9"/><path d="m7.8 12.7 4.2-4.2 4.2 4.2"/><path d="M4.5 4.5h15"/>',
  shuffle: '<path d="M3.5 6.5h3.2l9.8 11h3.5"/><path d="M3.5 17.5h3.2l4-4.5"/><path d="M13.3 8 16.5 6.5h3.5"/><path d="m17.5 4 2.5 2.5L17.5 9"/><path d="m17.5 15 2.5 2.5L17.5 20"/>',
  grid: '<rect x="4" y="4" width="7" height="7" rx="1.2"/><rect x="13" y="4" width="7" height="7" rx="1.2"/><rect x="4" y="13" width="7" height="7" rx="1.2"/><rect x="13" y="13" width="7" height="7" rx="1.2"/>',
  hand: '<path d="M8.5 11V5.8a1.4 1.4 0 0 1 2.8 0V11"/><path d="M11.3 10.5V4.7a1.4 1.4 0 0 1 2.8 0v5.8"/><path d="M14.1 11V6.6a1.4 1.4 0 0 1 2.8 0V14a6 6 0 0 1-6 6H10a5.5 5.5 0 0 1-4.4-2.2L4 15.5a1.4 1.4 0 0 1 2.1-1.8l2.4 2"/>',
  eye: '<path d="M2.5 12S6 6 12 6s9.5 6 9.5 6-3.5 6-9.5 6-9.5-6-9.5-6"/><circle cx="12" cy="12" r="3"/>',
  target: '<circle cx="12" cy="12" r="8.5"/><circle cx="12" cy="12" r="4.8"/><circle cx="12" cy="12" r="1.4"/>',
  flame: '<path d="M12 3s4.5 4 4.5 8a4.5 4.5 0 0 1-9 0c0-1.4.6-2.6 1.3-3.5.2 1.4.9 2.3 1.8 2.3 1 0 1.4-1 1.4-2.4C12 5.9 12 3 12 3"/><path d="M7.5 11a7 7 0 0 0-.5 2.6 5 5 0 0 0 10 0c0-.9-.2-1.8-.5-2.6"/>',
  repeat: '<path d="M4 9.5A3.5 3.5 0 0 1 7.5 6h11"/><path d="m15.5 3 3 3-3 3"/><path d="M20 14.5a3.5 3.5 0 0 1-3.5 3.5h-11"/><path d="m8.5 21-3-3 3-3"/>',
  award: '<circle cx="12" cy="9.5" r="5.5"/><path d="m8.5 14.2-1.3 6.3 4.8-2.6 4.8 2.6-1.3-6.3"/>',
  lock: '<rect x="4.8" y="10" width="14.4" height="10" rx="2"/><path d="M8.2 10V7.6a3.8 3.8 0 0 1 7.6 0V10"/>',
  crown: '<path d="M3.5 7.5 7 12l5-6.5 5 6.5 3.5-4.5V18a1.5 1.5 0 0 1-1.5 1.5H5A1.5 1.5 0 0 1 3.5 18z"/>',
  lightbulb: '<path d="M9.2 16.5a6 6 0 1 1 5.6 0v1.6a1.4 1.4 0 0 1-1.4 1.4h-2.8a1.4 1.4 0 0 1-1.4-1.4z"/><path d="M10 20.8h4"/>',
  'graduation-cap': '<path d="m2.8 8.8 9.2-4 9.2 4-9.2 4z"/><path d="M6.5 10.5V16c0 1.4 2.5 2.5 5.5 2.5s5.5-1.1 5.5-2.5v-5.5"/><path d="M21.2 8.8v5"/>',
  'arrow-left': '<path d="M19 12H5"/><path d="m10.5 6.5-5 5.5 5 5.5"/>',
  'arrow-right': '<path d="M5 12h14"/><path d="m13.5 6.5 5 5.5-5 5.5"/>',
  inbox: '<path d="M3.5 12.5h4l1.5 3h6l1.5-3h4"/><path d="M5.6 5.4 3.5 12.5V18a2 2 0 0 0 2 2h13a2 2 0 0 0 2-2v-5.5L18.4 5.4a2 2 0 0 0-1.8-1.2H7.4a2 2 0 0 0-1.8 1.2z"/>',
  sparkle: '<path d="M12 3.5 13.8 9l5.7 1.8-5.7 1.8L12 18.2l-1.8-5.6-5.7-1.8L10.2 9z"/><path d="M18.5 16.5 19.2 19l2.3.8-2.3.8-.7 2.4"/>',
  door: '<path d="M4.5 20.5h15"/><path d="M6.5 20.5V4.7a1.2 1.2 0 0 1 1.5-1.2l7.5 1.6a1.2 1.2 0 0 1 1 1.2v14.2"/><path d="M13 12.2h.01"/>',
  info: '<circle cx="12" cy="12" r="9"/><path d="M12 11v5.2"/><path d="M12 7.6h.01"/>',
  'shield-check': '<path d="M12 3.2 19.5 6v6.2c0 4.2-3 7-7.5 8.6-4.5-1.6-7.5-4.4-7.5-8.6V6z"/><path d="m8.8 12 2.3 2.3 4.1-4.4"/>',
};

@Component({
  selector: 'app-icon',
  standalone: true,
  template: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75"
                  stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"
                  focusable="false" [style.width.px]="size" [style.height.px]="size"
                  [innerHTML]="body()"></svg>`,
  styles: [':host{display:inline-flex;align-items:center;justify-content:center;flex-shrink:0;line-height:0}'],
})
export class Icon {
  private sanitizer = inject(DomSanitizer);
  @Input({ required: true }) name = '';
  @Input() size = 20;

  body(): SafeHtml {
    // Nội dung lấy từ hằng số trong chính file này, không phải dữ liệu người dùng.
    return this.sanitizer.bypassSecurityTrustHtml(PATHS[this.name] ?? '');
  }
}
