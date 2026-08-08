import { inject } from '@angular/core';
import { HttpErrorResponse, HttpInterceptorFn } from '@angular/common/http';
import { Router } from '@angular/router';
import { catchError, throwError } from 'rxjs';
import { AuthService } from '../services/auth.service';

// Tự động gắn "Authorization: Bearer <token>" vào mọi request nếu đã đăng nhập.
export const authInterceptor: HttpInterceptorFn = (req, next) => {
	const router = inject(Router);
	const auth = inject(AuthService);
  const token = localStorage.getItem('token');
  if (token) {
    req = req.clone({
      setHeaders: { Authorization: `Bearer ${token}` },
    });
  }
  return next(req).pipe(
    catchError((error: HttpErrorResponse) => {
      if (error.status === 401 && token && !req.url.includes('/auth/login')) {
		auth.logout();
        if (!router.url.startsWith('/login')) {
          void router.navigate(['/login'], { queryParams: { reason: 'expired' } });
        }
      }
      return throwError(() => error);
    })
  );
};
