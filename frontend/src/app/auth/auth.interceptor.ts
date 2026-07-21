import { HttpInterceptorFn } from '@angular/common/http';

// Tự động gắn "Authorization: Bearer <token>" vào mọi request nếu đã đăng nhập.
export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const token = localStorage.getItem('token');
  if (token) {
    req = req.clone({
      setHeaders: { Authorization: `Bearer ${token}` },
    });
  }
  return next(req);
};
