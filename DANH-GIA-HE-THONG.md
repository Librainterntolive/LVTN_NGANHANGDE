# Tự đánh giá – Website quản lý ngân hàng đề thi đại học

## 1. Phạm vi triển khai hiện tại

Đề tài giữ nguyên tên **“Xây dựng website quản lý ngân hàng đề thi”** và được thu hẹp nghiệp vụ vào học phần bậc đại học. Hệ thống không cố mô phỏng đồng thời quy trình biểu mẫu của tiểu học, THCS, THPT và sau đại học.

| Nhóm nghiệp vụ | Mức độ | Minh chứng triển khai |
|---|---|---|
| Tài khoản, vai trò Admin/Giảng viên/Sinh viên | Hoàn thành | JWT, khóa tài khoản, OTP Gmail, đổi mật khẩu, cấp lại mật khẩu có Admin duyệt |
| Ngân hàng câu hỏi | Hoàn thành | Môn học, chương, độ khó, đáp án một lựa chọn, nguồn trích dẫn đã xác thực, trạng thái duyệt |
| Nhập câu hỏi | Hoàn thành | CSV/XLSX, giới hạn dung lượng, kiểm tra cột/dòng, báo lỗi nhập |
| Tạo và quản lý đề | Hoàn thành | Chọn câu hỏi/kho đề, ma trận chương–độ khó, xáo câu/đáp án, nhân bản, in A4/trình duyệt lưu PDF |
| Lớp học kiểu Classroom | Hoàn thành | Mã lớp, tự tham gia, thêm/xóa sinh viên, tìm bằng email/tên đăng nhập, giao bài, chấm điểm |
| Nộp bài tệp | Hoàn thành | Tối đa 20 MB, chia mảnh 1 MB, tự thử lại, tiếp tục sau rớt mạng, xác thực chữ ký tệp, AES-256-GCM |
| Thống kê | Hoàn thành cơ bản | Theo đề và theo lớp; từng sinh viên có số bài nộp, bài muộn, TB bài nộp và TB tính vắng |
| Hiệu năng giao diện | Hoàn thành cơ bản | Danh sách câu hỏi/đề/lớp/người dùng tải theo trang 12–15 bản ghi, có nút tải thêm/scroll |
| Thiết bị di động | Hoàn thành cơ bản | Sidebar dạng drawer, bảng cuộn ngang, form và thẻ co giãn |

## 2. Điểm mạnh để trình bày khi bảo vệ

1. **Phạm vi tập trung:** quản lý ngân hàng đề và tổ chức học phần đại học, không đưa AI vào phần bắt buộc.
2. **Nguồn câu hỏi có kiểm soát:** Admin xác thực URL/tài liệu nguồn trước; mỗi câu hỏi phải gắn nguồn và vị trí tham chiếu, sau đó mới được duyệt để dùng trong đề.
3. **Nghiệp vụ thực tế hơn bản trắc nghiệm cơ bản:** có lớp học, bài tập nộp tệp, hạn nộp muộn, chấm điểm, thống kê lớp và email thông báo.
4. **Bảo mật có thể giải thích:** bcrypt cho mật khẩu, JWT phân quyền, OTP tách mục đích đăng ký/quên mật khẩu, giới hạn 5 lần nhập OTP sai, tệp bài nộp mã hóa AES-256-GCM.
5. **Khả năng mở rộng:** kiến trúc Controller → Service → Repository; các bảng `sources`, `assignments`, `assignment_submissions`, `upload_sessions` độc lập để thêm tính năng sau này.

## 3. Hạn chế cần nói trung thực

| Hạn chế | Lý do/ghi chú | Hướng phát triển |
|---|---|---|
| Chưa có hàng đợi gửi email | SMTP hiện gửi nền trong tiến trình backend | Dùng Redis + worker/queue, lưu lịch sử gửi |
| Chưa có quét virus tệp | Đã chặn loại/kích thước/chữ ký tệp và mã hóa | Tích hợp ClamAV hoặc dịch vụ quét tệp trước khi phát hành |
| Chưa có audit log đầy đủ | Hiện chỉ có dữ liệu nghiệp vụ chính | Bổ sung bảng `audit_logs` cho tạo/sửa/xóa/duyệt/tải tệp |
| Chưa có xuất DOCX mẫu trường | Hiện hỗ trợ bản in A4 qua trình duyệt/lưu PDF | Cho phép Admin cấu hình mẫu DOCX/PDF theo trường/khoa |
| Chưa có phân tích chất lượng câu hỏi | Có thống kê điểm cơ bản | Thêm độ khó thực nghiệm, độ phân biệt, độ tin cậy Cronbach’s alpha |
| Chưa có SSO/LMS | Hệ thống dùng tài khoản nội bộ | Kết nối Google/Microsoft hoặc Moodle qua OAuth/LTI |
| Chưa có AI | Chủ động ngoài phạm vi luận văn | AI chỉ nên gợi ý, luôn cần nguồn/trạng thái duyệt của giảng viên |

## 4. Thứ tự nâng cấp đề xuất

1. Audit log và sao lưu/khôi phục CSDL định kỳ.
2. Hàng đợi email + quét virus tệp bài nộp.
3. Xuất DOCX/PDF theo mẫu phòng đào tạo.
4. Dashboard phân tích chất lượng ngân hàng câu hỏi.
5. Tích hợp LMS/SSO và AI hỗ trợ soạn câu hỏi có kiểm duyệt.

## 5. Kiểm thử tối thiểu trước buổi bảo vệ

1. Đăng ký sinh viên → nhận OTP Gmail → xác minh → đăng nhập.
2. Giảng viên tạo lớp → thêm sinh viên bằng email hoặc để sinh viên vào bằng mã lớp.
3. Tạo câu hỏi có nguồn → duyệt câu hỏi → tạo đề → in/lưu PDF.
4. Giao bài tập → sinh viên nộp PDF/DOCX → ngắt mạng thử tải lại → chấm điểm.
5. Mở thống kê lớp để kiểm tra điểm trung bình theo hai cách tính.
