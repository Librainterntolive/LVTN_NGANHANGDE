# Kịch bản kiểm thử và nghiệm thu

## Chuẩn bị

- Frontend: `http://localhost:4200`.
- Backend: `http://localhost:8081/api/ping` phải trả `pong`.
- MySQL Wamp đang chạy và database là `quiz_db`.
- Dùng tài khoản Admin/Giảng viên/Sinh viên đã xác thực Gmail; không dùng tài khoản thử.
- Đề khách minh chứng: **Tin hoc dai cuong - Go basics (official documentation)**, gồm 20 câu từ nguồn `go.dev`.

## TC-01 — Khách làm đề công khai

1. Mở trang chủ khi chưa đăng nhập.
2. Kiểm tra thẻ đề có nhãn **Nguồn câu hỏi đã xác thực**.
3. Chọn đề công khai và mở màn làm bài.

**Kỳ vọng:** Có 20 câu, API báo giới hạn khách tối đa 20 câu, thứ tự có thể xáo trộn và không hiển thị đáp án đúng trước khi nộp.

## TC-02 — Đăng ký và xác thực Gmail OTP

1. Đăng ký tài khoản bằng một Gmail có thể nhận thư.
2. Kiểm tra email nhận OTP 6 số.
3. Thử đăng nhập trước khi xác minh, sau đó nhập OTP và đăng nhập lại.

**Kỳ vọng:** Đăng nhập bị chặn khi trạng thái `pending_verification`; chỉ đăng nhập thành công sau OTP hợp lệ. OTP sai quá giới hạn hoặc hết hạn phải bị từ chối.

## TC-03 — Nguồn tài liệu và kiểm duyệt câu hỏi

1. Đăng nhập Giảng viên, mở **Ngân hàng câu hỏi**.
2. Khai báo URL `https://...`, tên tài liệu và vị trí tham chiếu.
3. Tạo một câu hỏi có đúng một đáp án, gửi duyệt.
4. Đăng nhập Admin, xác thực nguồn và duyệt câu hỏi.

**Kỳ vọng:** URL không có `http://` hoặc `https://` bị chặn; câu hỏi chưa duyệt/chưa có nguồn xác thực không thể phát hành trong đề.

## TC-04 — Import câu hỏi an toàn

1. Tải template import, điền câu hỏi có `source_title`, `source_url`, `source_reference`.
2. Import tệp CSV/XLSX hợp lệ.
3. Thử tệp sai phần mở rộng, vượt 20 MB, vượt 2.000 dòng hoặc URL nguồn không hợp lệ.

**Kỳ vọng:** Tệp hợp lệ vào trạng thái chờ duyệt; tệp sai bị báo lỗi cụ thể và không làm treo server.

## TC-05 — Tạo, phát hành và in đề

1. Giảng viên chọn các câu đã duyệt, tạo đề; thiết lập thời gian, xáo câu/xáo đáp án, lượt làm và lớp nhận đề.
2. Thử phát hành đề chứa câu nháp/chưa xác thực.
3. Mở preview, dùng chức năng in và chọn **Save as PDF** trong hộp thoại trình duyệt.

**Kỳ vọng:** Chỉ đề có toàn bộ câu `active/approved` với nguồn `verified` được phát hành; bản in có bố cục A4, không hiện đáp án đúng.

## TC-06 — Classroom và quản lý sinh viên

1. Giảng viên tạo lớp, lấy mã lớp.
2. Sinh viên tham gia bằng mã lớp.
3. Giảng viên tìm email/tên sinh viên để thêm, sau đó xóa sinh viên.
4. Đăng nhập giảng viên khác và thử thay đổi danh sách sinh viên của lớp này.

**Kỳ vọng:** Chỉ chủ lớp hoặc Admin thêm/xóa sinh viên; giảng viên khác không được sửa danh sách, kể cả lớp dùng chung. Sinh viên có Gmail nhận email khi được thêm vào hoặc bị xóa khỏi lớp.

## TC-07 — Giao, nộp và chấm bài tập

1. Tạo bài tập có hạn nộp và hạn nộp muộn.
2. Sinh viên nộp tệp hợp lệ dưới 20 MB; ngắt mạng trong lúc nộp rồi mở lại trang để tiếp tục.
3. Nộp trong khoảng trễ và sau khi hết khoảng trễ.
4. Giảng viên tải bài, chấm điểm và gửi phản hồi.

**Kỳ vọng:** Upload theo mảnh có thể tiếp tục; bài trễ được gắn nhãn; sau hạn trễ không cho nộp; tệp lưu mã hóa và chỉ người nộp/chủ lớp/Admin tải được.

## TC-08 — Phân trang, tải dần và thống kê

1. Mở danh sách môn học, câu hỏi, đề, lớp, người dùng và lịch sử.
2. Kiểm tra lần tải đầu không quá 12 bản ghi; cuộn đến cuối hoặc bấm tải thêm.
3. Mở thống kê lớp, xem từng sinh viên và điểm trung bình.

**Kỳ vọng:** Server ép `limit` tối đa 15; mỗi lần tải thêm không nhân bản dữ liệu; thống kê thể hiện được từng sinh viên và trung bình lớp.

## Bằng chứng nên chụp cho báo cáo

- Email OTP, màn lỗi đăng nhập trước xác minh và màn xác minh thành công.
- Form nguồn/câu hỏi, trạng thái chờ duyệt và trạng thái đã duyệt.
- Thông báo lỗi import sai định dạng hoặc vượt giới hạn.
- Trang tạo đề, preview/in PDF và màn khách làm đề công khai.
- Trang Classroom, mã lớp, bài tập, trạng thái nộp muộn và chấm điểm.
- Trang thống kê lớp theo sinh viên và danh sách tải dần.
