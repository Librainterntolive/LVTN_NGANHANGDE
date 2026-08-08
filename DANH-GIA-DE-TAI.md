# Đánh giá hiện trạng đề tài

## Phạm vi đã chốt

Đề tài giữ tên **XÂY DỰNG WEBSITE QUẢN LÝ NGÂN HÀNG ĐỀ THI** và được triển khai theo phạm vi học phần đại học. Hệ thống hiện chỉ hỗ trợ câu hỏi trắc nghiệm một đáp án đúng. Phạm vi này tránh phải xử lý quy chế đề thi khác nhau giữa phổ thông, đại học và sau đại học.

## Chức năng đã có

- Đăng ký bằng Gmail OTP, chặn đăng nhập khi chưa xác thực email, quên mật khẩu có OTP và bước Admin phê duyệt.
- Ba vai trò Admin, Giảng viên và Sinh viên; phân quyền API bằng JWT.
- Học phần đại học, chương/chủ đề, ngân hàng câu hỏi, câu hỏi một đáp án đúng, lọc theo người tạo và trạng thái duyệt.
- Nguồn tài liệu bắt buộc cho câu hỏi: URL HTTP/HTTPS, vị trí tham chiếu, trạng thái chờ duyệt/xác thực/từ chối.
- Import CSV/XLSX giới hạn 20 MB, 2.000 dòng, 32 cột, kiểm tra cấu trúc tệp, URL nguồn và câu hỏi trùng.
- Tạo đề thủ công, tạo theo ma trận chương × độ khó, sao chép đề, giao đề cho lớp, làm bài có giới hạn thời gian/lượt làm và xáo trộn.
- In đề A4 hoặc lưu PDF qua trình duyệt.
- Classroom: mã lớp, tham gia lớp, thêm/xóa sinh viên, bảng tin, bài tập, hạn nộp và nộp muộn có thời hạn.
- Nộp tệp có chia mảnh, tiếp tục khi rớt mạng, giới hạn 20 MB, kiểm tra định dạng và mã hóa lưu trữ.
- Thống kê lớp, sinh viên, đề thi và lịch sử làm bài; nhật ký thao tác Admin.
- Tải dần 12 bản ghi/lần, cuộn để nạp thêm và chỉ mục MySQL cho truy vấn lớn.

## Điểm mạnh để trình bày luận văn

1. Không chỉ là CRUD: hệ thống có quy trình kiểm duyệt nguồn → kiểm duyệt câu hỏi → phát hành đề.
2. Có nghiệp vụ Classroom hoàn chỉnh hơn một ngân hàng câu hỏi đơn thuần: lớp, bài tập, nộp bài, trễ hạn và chấm điểm.
3. Có xử lý dữ liệu lớn thực tế: phân trang server-side, infinite scroll có chống gọi lặp, index MySQL và giới hạn import.
4. Có bảo mật và vận hành: OTP, phân quyền, rate limit, header bảo mật, giới hạn request body, mã hóa bài nộp, audit log.

## Điều kiện bắt buộc trước nghiệm thu

- Nhập câu hỏi từ tài liệu có thật, giữ URL/tên tài liệu/trang hoặc điều tham chiếu cho từng câu.
- Admin xác thực nguồn và duyệt câu hỏi trước khi phát hành; chỉ khi đó đề mới được công khai cho khách.
- Không dùng các đề thử hoặc tài khoản thử trong phần dữ liệu minh chứng. Migration `20260808_remove_demo_exams.sql` dọn các đề thử cũ khi khôi phục database.
- Chuẩn bị ít nhất một bộ dữ liệu thật theo một học phần đại học để demo xuyên suốt: nguồn → câu hỏi → đề → lớp → bài nộp → thống kê.
- Hai file seed `backend/database/seed-go-official-basics.sql` và `backend/database/seed-go-official-spec-supplement.sql` cung cấp 2 nguồn `go.dev`, 20 câu đã duyệt và 1 đề công khai 20 câu cho học phần Tin học đại cương; đây là dữ liệu minh chứng có nguồn, không thay thế bộ câu hỏi thật của học phần được chọn để bảo vệ.

## Hạng mục nên làm tiếp

### Cần cho luận văn

- Viết kịch bản kiểm thử theo vai trò và đưa ảnh/chứng cứ kết quả vào chương kiểm thử.
- Chụp sơ đồ ERD, use case, activity cho các luồng: đăng ký OTP, import/duyệt câu hỏi, tạo/giao đề, nộp bài trễ.
- Có tài khoản demo tách biệt, dùng Gmail thật và dữ liệu nguồn thật đã kiểm chứng.
- Sao lưu database trước khi demo, kiểm tra SMTP và file upload trên đúng máy trình bày.

### Nâng cao sau bảo vệ

- Bổ sung hàng đợi gửi email, Redis cho rate limit/cache và object storage cho tệp bài nộp.
- Thêm kiểm thử integration/E2E, CI/CD và giám sát lỗi.
- Xây dựng bộ tiêu chí chất lượng câu hỏi, phân tích độ khó/phân biệt dựa trên kết quả làm bài.
- Chỉ cân nhắc AI sau khi quy trình nguồn, kiểm duyệt và dữ liệu thật đã ổn định.

## Kết luận

Về mã nguồn, đề tài đã vượt mức website CRUD cơ bản. Phần quyết định chất lượng khi bảo vệ không phải thêm AI, mà là dữ liệu thật có nguồn kiểm chứng, kịch bản demo nhất quán và bằng chứng kiểm thử cho các quy trình nghiệp vụ.
