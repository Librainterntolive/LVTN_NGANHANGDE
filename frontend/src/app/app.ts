import { Component, inject, signal } from '@angular/core';
import { RouterOutlet, RouterLink, RouterLinkActive, Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { AuthService } from './services/auth.service';
import { LayoutService } from './services/layout.service';
import { ToastService } from './services/toast.service';
import { DialogService } from './services/dialog.service';
import { ThemeService } from './services/theme.service';
import { I18nService } from './services/i18n.service';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, RouterLink, RouterLinkActive, FormsModule],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  protected auth = inject(AuthService);
  protected layout = inject(LayoutService);
  protected toast = inject(ToastService);
  protected dialog = inject(DialogService);
  protected theme = inject(ThemeService);
  protected i18n = inject(I18nService);
  private router = inject(Router);

  // trạng thái thu gọn sidebar (nhớ qua localStorage)
  collapsed = signal<boolean>(localStorage.getItem('sidebar_collapsed') === '1');
  // sidebar dạng overlay trên màn hình nhỏ
  mobileOpen = signal<boolean>(false);

  // ô tìm kiếm menu
  menuQuery = '';

  toggleSidebar() {
    if (window.innerWidth <= 900) {
      this.mobileOpen.update((v) => !v);
      return;
    }
    const v = !this.collapsed();
    this.collapsed.set(v);
    localStorage.setItem('sidebar_collapsed', v ? '1' : '0');
  }

  closeMobile() { this.mobileOpen.set(false); }

  // menu item có khớp từ khóa tìm kiếm không
  mt(label: string): boolean {
    const q = this.menuQuery.trim().toLowerCase();
    return !q || label.toLowerCase().includes(q);
  }

  initial(): string {
    const u = this.auth.currentUser();
    const name = u?.full_name || u?.username || '?';
    return name.charAt(0).toUpperCase();
  }

  logout() {
    this.auth.logout();
    this.router.navigate(['/login']);
  }
}
