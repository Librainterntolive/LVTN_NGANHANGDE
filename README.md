# Hệ thống quản lý ngân hàng đề thi đại học

Luận văn tốt nghiệp — Trường Đại học Công nghệ Sài Gòn.

Hệ thống quản lý ngân hàng câu hỏi và đề thi trắc nghiệm cho bậc đại học, kèm
không gian lớp học để giao bài, nộp bài và theo dõi kết quả.

## Công nghệ

| Thành phần | Công nghệ |
|---|---|
| Backend | Go 1.24, Gin, GORM |
| Frontend | Angular 21 (standalone component, signals), TypeScript 5.9 |
| Cơ sở dữ liệu | MySQL 8 |

## Chức năng chính

**Ngân hàng câu hỏi có kiểm duyệt.** Mỗi câu hỏi bắt buộc gắn với một nguồn tài
liệu đã được quản trị viên xác thực và ghi rõ vị trí tham chiếu (chương, trang,
điều). Câu hỏi phải qua bước duyệt mới được đưa vào đề thi công khai.

**Ngân hàng song ngữ.** Câu hỏi dịch từ tài liệu nước ngoài lưu song song bản gốc
và bản tiếng Việt. Nếu khai là bản dịch mà thiếu nguyên bản, thiếu ngôn ngữ nguồn
hoặc thiếu dẫn chứng cho cách dịch thuật ngữ thì hệ thống từ chối lưu.

**Soạn và phát hành đề thi.** Chọn câu thủ công hoặc sinh tự động theo ma trận
(chương × độ khó), xáo trộn câu và đáp án, giới hạn số lần làm, in đề ra PDF.

**Không gian lớp học.** Mỗi lớp có trang riêng gồm bốn phần: Bảng tin, Bài tập,
Thành viên và Điểm. Giảng viên giao bài kèm hạn nộp và mốc nộp muộn; sinh viên
nộp tệp; giảng viên chấm điểm và nhận xét.

**Thống kê.** Xem theo từng lớp, trong lớp xem từng sinh viên, kèm điểm trung
bình lớp tính theo hai cách: chỉ tính bài đã nộp, và tính cả bài chưa nộp là 0.

**Nhật ký thao tác.** Ghi lại các thao tác quản trị quan trọng để truy vết.

## Nguyên tắc dữ liệu

Hệ thống chỉ lưu dữ liệu thật. Mỗi bộ đề phải trả lời được ba câu hỏi: lấy từ
nguồn nào, nguồn đó đã được xác thực chưa, và ai là người phê duyệt. Không dùng
dữ liệu sinh tự động để lấp chỗ trống.

Script `backend/scripts/verify-real-data.ps1` kiểm tra ràng buộc này: câu hỏi
không nguồn, đề công khai chứa câu chưa duyệt, đáp án mồ côi, tài khoản thử
nghiệm còn sót.

## Cài đặt

Yêu cầu: Go 1.24, Node.js 20 trở lên, MySQL 8.

**1. Cơ sở dữ liệu**

```bash
mysql -u root -e "CREATE DATABASE quiz_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
```

Chạy lần lượt các file trong `backend/database/migrations/` theo thứ tự tên file.

**2. Backend**

```bash
cd backend && cp .env.example .env
```

Sửa `.env` cho đúng máy bạn. Hai khóa bắt buộc phải tự sinh, không dùng giá trị
mẫu:

- `JWT_SECRET` — chuỗi bí mật ký token đăng nhập
- `FILE_ENCRYPTION_KEY` — khóa base64 32 byte, dùng mã hóa tệp bài nộp

Sinh khóa mã hóa bằng PowerShell:

```powershell
[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Maximum 256 }))
```

Chạy máy chủ:

```bash
cd backend && go run ./cmd
```

**3. Frontend**

```bash
cd frontend && npm install && npm start
```

Mở `http://localhost:4200`. Backend chỉ chấp nhận yêu cầu từ cổng 4200.

## Kiểm thử

```bash
cd backend && go test ./...
```

```bash
cd frontend && npx ng test --watch=false
```

## Cấu trúc thư mục

```
backend/
  cmd/              điểm khởi động máy chủ
  config/           kết nối cơ sở dữ liệu
  internal/
    controller/     tầng nhận yêu cầu HTTP
    service/        nghiệp vụ và ràng buộc
    repository/     truy vấn cơ sở dữ liệu
    entity/         cấu trúc bảng
    dto/            cấu trúc dữ liệu vào/ra
  middleware/       giới hạn tần suất, giới hạn kích thước, header bảo mật
  database/
    migrations/     các bước thay đổi cấu trúc bảng
  scripts/          sao lưu và kiểm tra toàn vẹn dữ liệu

frontend/src/app/
  features/         từng màn hình
  services/         gọi API và trạng thái dùng chung
  shared/           thành phần dùng chung (bộ biểu tượng, cuộn vô hạn)
  auth/             chặn truy cập theo vai trò
```

## Lưu ý bảo mật

- `backend/.env` không được đưa lên repo. Dùng `.env.example` làm mẫu.
- `backend/database/quiz_db.sql` (bản dump toàn bộ dữ liệu) không được theo dõi
  vì chứa chuỗi băm mật khẩu và địa chỉ email thật.
- Tệp bài nộp của sinh viên được mã hóa trước khi lưu xuống đĩa.
