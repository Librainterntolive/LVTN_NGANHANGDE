import { ApplicationConfig, Injectable, provideBrowserGlobalErrorListeners } from '@angular/core';
import { provideRouter, TitleStrategy, RouterStateSnapshot, withInMemoryScrolling } from '@angular/router';
import { Title } from '@angular/platform-browser';
import { provideHttpClient, withInterceptors } from '@angular/common/http';

import { routes } from './app.routes';
import { authInterceptor } from './auth/auth.interceptor';

const APP_NAME = 'Hệ thống thi trắc nghiệm';

// Ghép tên trang với tên hệ thống: "Đề thi · Hệ thống thi trắc nghiệm".
// Nhờ vậy tab trình duyệt cho biết đang ở đâu, thay vì luôn hiện một tên chung.
@Injectable({ providedIn: 'root' })
export class PageTitleStrategy extends TitleStrategy {
  constructor(private readonly title: Title) {
    super();
  }

  override updateTitle(snapshot: RouterStateSnapshot) {
    const page = this.buildTitle(snapshot);
    this.title.setTitle(page ? `${page} · ${APP_NAME}` : APP_NAME);
  }
}

export const appConfig: ApplicationConfig = {
  providers: [
    provideBrowserGlobalErrorListeners(),
    provideRouter(
      routes,
      // chuyển trang thì cuộn lên đầu, bấm Back thì trả về đúng chỗ cũ
      withInMemoryScrolling({ scrollPositionRestoration: 'enabled', anchorScrolling: 'enabled' })
    ),
    { provide: TitleStrategy, useClass: PageTitleStrategy },
    provideHttpClient(withInterceptors([authInterceptor]))
  ]
};
