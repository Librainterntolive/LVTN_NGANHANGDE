# Backend - Hệ thống thi trắc nghiệm (Go + Gin + GORM + MySQL)

Kiến trúc phân tầng: **Controller → Service → Repository** (có DTO, Router, PKG), dùng dependency injection.

## 1. Cài đặt công cụ (làm 1 lần)
- Cài **Go**: https://go.dev/dl/ (gõ `go version` để kiểm tra)
- Cài **MySQL** (hoặc WampServer). Tạo database tên `quiz_db`.

## 2. Cấu hình
1. Copy `.env.example` thành `.env`
2. Sửa `DB_USER`, `DB_PASSWORD`, `DB_NAME` cho đúng máy bạn.

## 3. Chạy backend
```powershell
cd backend
go mod tidy        # tải thư viện (lần đầu)
.\run.ps1          # chạy server (điểm khởi động ở cmd/main.go)
```
Server chạy tại http://localhost:8081

### Vì sao dùng `run.ps1` thay cho `go run ./cmd`?
`go run` biên dịch ra một file `.exe` **mới trong thư mục tạm mỗi lần chạy**, nên
Windows Defender phải quét lại từ đầu mỗi lần. `run.ps1` biên dịch ra một file cố
định (`bin/server.exe`) và bỏ qua bước biên dịch nếu mã nguồn không đổi.

Đo thực tế trên máy (thời gian từ lúc gõ lệnh đến khi API trả lời):

| Cách chạy | Thời gian |
|---|---|
| `go run ./cmd` | 11.468 ms |
| `.\run.ps1` (có sửa code) | 2.752 ms |
| `.\run.ps1` (không sửa code) | 921 ms |

Hai công tắc trong `.env` cũng ảnh hưởng tốc độ:
- `AUTO_MIGRATE` — chỉ đặt `true` khi vừa sửa `internal/entity/entity.go`, chạy 1
  lần cho bảng được cập nhật rồi đặt lại `false`.
- `GIN_MODE=release` — bỏ việc in ~60 dòng route ra console mỗi lần khởi động.
Thử: http://localhost:8081/api/ping → `{"message":"pong"}`

Tài khoản mẫu: **admin / admin123** (Admin), **sv01 / 123456** (Student).

## 4. Cấu trúc thư mục (phân tầng)
```
backend/
├── cmd/
│   └── main.go                # điểm khởi động: load .env, CORS, gọi router
├── config/
│   └── database.go            # kết nối MySQL + AutoMigrate
├── internal/
│   ├── entity/                # struct bảng dữ liệu (model)
│   ├── dto/                   # struct request/response
│   ├── repository/            # tầng truy cập CSDL (GORM)
│   ├── service/               # tầng nghiệp vụ (validate, hash, chấm điểm...)
│   ├── controller/            # tầng HTTP (nhận request, trả response)
│   └── router/                # lắp ráp repo→service→controller + khai báo route
├── middleware/                # xác thực JWT, phân quyền
├── pkg/                       # tiện ích dùng chung (JWT)
└── database/                  # file SQL + CSV mẫu import
```

## 5. Luồng 1 request (ví dụ tạo môn học)
```
HTTP POST /api/subjects
  → controller.SubjectController.Create   (đọc dữ liệu, gọi service)
    → service.SubjectService.Create       (xử lý nghiệp vụ)
      → repository.SubjectRepository.Create (lưu vào DB)
```

## 6. Thêm chức năng mới (theo mẫu)
1. Thêm struct vào `internal/entity` (nếu cần bảng mới) + `dto`
2. Viết `repository/xxx_repository.go`
3. Viết `service/xxx_service.go`
4. Viết `controller/xxx_controller.go`
5. Khai báo trong `internal/router/router.go`
