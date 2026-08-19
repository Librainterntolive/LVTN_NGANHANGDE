// set-env.js
//
// Sinh src/environments/environment.ts lúc build, vì tệp đó KHÔNG được đưa lên
// git: mỗi máy và mỗi lần triển khai trỏ về một địa chỉ backend khác nhau.
//
// Chạy tự động qua script "prebuild" trong package.json, nên `npm run build`
// luôn có tệp cấu hình đúng.
//
// Quy ước: API_URL là địa chỉ GỐC của backend, KHÔNG kèm /api.
//   Ví dụ: API_URL=https://api.ten-mien.com  ->  apiUrl = https://api.ten-mien.com/api
const fs = require('fs');
const path = require('path');

const envDir = path.join(__dirname, 'src', 'environments');
const targetPath = path.join(envDir, 'environment.ts');

if (!fs.existsSync(envDir)) {
  fs.mkdirSync(envDir, { recursive: true });
}

// Bỏ dấu / thừa ở cuối để không sinh ra địa chỉ kiểu "https://may-chu//api".
const baseUrl = (process.env.API_URL || '').trim().replace(/\/+$/, '');

// Đang build trên máy chủ CI/CD (Vercel, GitHub Actions...) mà thiếu API_URL
// thì DỪNG HẲN. Nếu cứ lặng lẽ ghi một địa chỉ mẫu, bản build vẫn thành công
// nhưng mọi lời gọi API đều hỏng — kiểu lỗi rất mất công dò.
const onCI = !!(process.env.VERCEL || process.env.CI);
if (!baseUrl && onCI) {
  console.error('[set-env] THIEU bien moi truong API_URL.');
  console.error('[set-env] Khai bao API_URL trong phan Environment Variables,');
  console.error('[set-env] la dia chi GOC cua backend, KHONG kem /api.');
  console.error('[set-env] Vi du: https://api.ten-mien.com');
  process.exit(1);
}

// Build ở máy cá nhân: đã có environment.ts thì giữ nguyên, không ghi đè cấu
// hình đang dùng để lập trình.
if (!baseUrl && fs.existsSync(targetPath)) {
  console.log('[set-env] Khong co API_URL, giu nguyen environment.ts san co.');
  return;
}

const apiUrl = baseUrl ? `${baseUrl}/api` : 'http://localhost:8081/api';

fs.writeFileSync(
  targetPath,
  `// Tệp này được sinh tự động lúc build bởi set-env.js — đừng sửa tay.
export const environment = {
  production: ${onCI ? 'true' : 'false'},
  apiUrl: '${apiUrl}'
};
`,
  { encoding: 'utf8' },
);

console.log(`[set-env] Da ghi ${targetPath} voi apiUrl = ${apiUrl}`);
