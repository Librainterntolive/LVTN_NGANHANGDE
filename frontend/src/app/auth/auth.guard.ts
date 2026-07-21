import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

// Chặn truy cập trang nếu chưa đăng nhập -> chuyển về /login.
export const authGuard: CanActivateFn = () => {
  const auth = inject(AuthService);
  const router = inject(Router);

  if (auth.isLoggedIn()) {
    return true;
  }
  router.navigate(['/login']);
  return false;
};

// roleGuard: chỉ cho vào nếu vai trò nằm trong danh sách cho phép.
// Backend vẫn kiểm tra quyền riêng - đây chỉ để người dùng không lạc vào trang
// trống của vai trò khác khi gõ thẳng địa chỉ.
export const roleGuard = (...roles: string[]): CanActivateFn => {
  return () => {
    const auth = inject(AuthService);
    const router = inject(Router);

    if (!auth.isLoggedIn()) {
      router.navigate(['/login']);
      return false;
    }
    const role = auth.getRole();
    if (role && roles.includes(role)) {
      return true;
    }
    router.navigate(['/']); // sai vai trò -> về trang chủ
    return false;
  };
};
