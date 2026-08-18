// set-env.js
const fs = require('fs');
const path = require('path');

// Đảm bảo thư mục src/environments tồn tại
const envDir = path.join(__dirname, 'src', 'environments');
if (!fs.existsSync(envDir)) {
  fs.mkdirSync(envDir, { recursive: true });
}

// Lấy biến từ process.env của Vercel (kèm fallback nếu chạy local)
const apiUrl = process.env.API_URL || 'https://api.yourdomain.com';
// Nội dung file environment sẽ được sinh ra
const envConfigFile = `// File này được sinh tự động trong quá trình build trên Vercel
export const environment = {
  production: false,
  apiUrl: '${apiUrl}'
};
`;

const targetPath = path.join(envDir, 'environment.ts');
fs.writeFileSync(targetPath, envConfigFile, { encoding: 'utf8' });

console.log(`[Vercel Build] Đã tạo file cấu hình tại: ${targetPath}`);
