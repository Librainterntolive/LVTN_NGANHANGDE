# Frontend – QuizBank

Giao diện Angular cho website quản lý ngân hàng đề thi đại học.

## Chạy local

```powershell
cd frontend
npm install       # chỉ cần ở lần đầu hoặc khi package thay đổi
npm start
```

Mở `http://localhost:4200`. Backend phải chạy trước tại `http://localhost:8081`.

## Kiểm tra trước khi nộp

```powershell
npm run build
```

Build tạo thư mục `dist/frontend`. Các danh sách lớn dùng phân trang/lazy load; không tự thay đổi giới hạn tải khi thêm chức năng mới.

## Các màn hình chính

- Khách: giới thiệu, môn học đại học, đề công khai.
- Sinh viên: lớp của tôi, bài tập/nộp tệp, đề được giao, lịch sử kết quả.
- Giảng viên: nguồn/câu hỏi, tạo–in đề, Classroom, thống kê lớp.
- Admin: quản lý người dùng, duyệt cấp lại mật khẩu, quản lý dữ liệu dùng chung.
