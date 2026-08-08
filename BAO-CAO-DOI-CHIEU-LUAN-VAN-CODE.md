# Đối chiếu luận văn (LVTN_5chuong.docx) với code hiện tại

Đối chiếu thực hiện 08/2026, sau đợt trùng tu code gần nhất (migrations nhóm
`20260807`–`20260808`). Luận văn gốc mô tả đúng phần lõi (ngân hàng câu hỏi,
đề thi, lớp học, thống kê), nhưng thiếu 5 nhóm chức năng đã có trong code và
thiếu một số bảng trong ERD. File `LVTN_5chuong_CapNhat.docx` (bản mới, giữ
nguyên `LVTN_5chuong.docx` gốc) đã bổ sung các phần dưới đây.

## Chức năng có trong code nhưng luận văn chưa mô tả

1. **Xác thực OTP và khôi phục mật khẩu** — đăng ký Sinh viên bằng OTP email
   (6 số, hết hạn 10 phút, tối đa 5 lần sai), quên mật khẩu xác minh OTP rồi
   chờ Admin duyệt cấp mật khẩu tạm. Luận văn gốc không nhắc tới OTP ở bất kỳ
   đâu. → Đã thêm mục 2.1.8, use case, 2 sơ đồ tuần tự.

2. **Nguồn tài liệu bắt buộc + quy trình duyệt** — đây là điểm nhấn cốt lõi
   hiện tại của hệ thống (câu hỏi phải gắn nguồn đã Admin xác thực mới được
   duyệt và đưa vào đề công khai), nhưng bảng `SOURCES` hoàn toàn vắng mặt
   trong ERD gốc và mục 2.1.3 chỉ nói chung chung. → Đã bổ sung bảng SOURCES
   đầy đủ, sửa lại đoạn mô tả 2.1.3, thêm sơ đồ tuần tự và sơ đồ trạng thái.

3. **Bảng tin và bài tập lớp học** — giảng viên đăng thông báo, giao bài tập
   kèm hạn nộp/nộp muộn; sinh viên nộp tệp theo cơ chế tải lên từng phần, tệp
   mã hóa khi lưu; giảng viên chấm điểm. Luận văn gốc chỉ nói tới giao đề cho
   lớp, không có bảng tin/bài tập. → Đã thêm mục 2.1.10, use case, ERD, 3 sơ
   đồ tuần tự/hoạt động.

4. **Ngân hàng câu hỏi song ngữ** — câu hỏi dịch giữ bản gốc + bản dịch + dẫn
   chứng thuật ngữ, bắt buộc nếu khai là bản dịch. → Đã thêm mục 2.1.9.

5. **Nhật ký thao tác quản trị (audit log)** — ghi các thao tác quản trị quan
   trọng kèm người thực hiện/thời điểm. → Đã thêm mục 2.1.11, bảng AUDIT_LOGS,
   sơ đồ tuần tự.

## ERD: 11 bảng có trong code nhưng thiếu trong luận văn gốc

`SOURCES`, `CLASS_POSTS`, `ASSIGNMENTS`, `ASSIGNMENT_SUBMISSIONS`,
`UPLOAD_SESSIONS`, `FOLDERS`, `FOLDER_EXAMS`, `PRACTICE_ANSWERS`,
`AUDIT_LOGS`, `EMAIL_OTPS`, `PASSWORD_RESET_REQUESTS` — đã bổ sung đầy đủ vào
mục 5.1.2 (mô tả) và 5.2.2 (bảng thuộc tính chi tiết K/U/M) theo đúng khuôn
mẫu 12 bảng gốc.

## Số liệu/giới hạn kỹ thuật — luận văn gốc không có, code có

Đã gom vào mục mới **4.4 Tham số kỹ thuật và giới hạn hệ thống**: giới hạn
request 21 MB, import CSV/XLSX (2.000 dòng/32 cột/20 MB), phân trang 12/tối
đa 15, OTP 10 phút/5 lần sai, JWT 24 giờ, gia hạn nộp bài 60 giây, khách làm
thử tối đa 20 câu, luyện tập tối đa 20 câu/đúng liên tiếp 2 lần, bài tập nộp
file tối đa 20 MB/chunk 1 MB/tối đa 3 phiên song song/hết hạn 24 giờ.

## Đã kiểm tra và xác nhận khớp (không cần sửa)

- **Công nghệ**: Go 1.24 (`go.mod: go 1.24.0`) và Angular 21
  (`package.json: "@angular/core": "^21.2.0"`) đúng như luận văn nêu.
- **Phạm vi câu hỏi**: chỉ single-choice/true-false, không có multi-select
  hay tự luận — khớp với mục 5.2 "Các vấn đề còn tồn đọng" của luận văn.
- Cấu trúc Controller-Service-Repository, GORM AutoMigrate, JWT/bcrypt đúng
  như mô tả.

## Sơ đồ

Cả 27 sơ đồ đã được chèn thẳng vào `LVTN_5chuong_CapNhat_v2.docx` dưới dạng
Hình 3-x có đánh số liên tục (ảnh PNG render từ đúng nội dung .drawio):

- 13 sơ đồ tuần tự (Thêm) chèn vào cuối mục 3.2.2, đánh số Hình 3-24 → 3-36.
- 10 sơ đồ hoạt động (Sửa/Xóa) chèn vào mục 3.2.3, đánh số Hình 3-39 → 3-48
  (2 sơ đồ hoạt động gốc của luận văn được giữ nguyên, chỉ đổi số thành
  Hình 3-37 và 3-38).
- 4 sơ đồ trạng thái nằm trong mục mới **3.2.4 Sơ đồ trạng thái**, đánh số
  Hình 3-49 → 3-52.
- 16 hình màn hình gốc (mục 3.3) được renumber tự động từ Hình 3-26–3-41
  thành Hình 3-53–3-68 để không trùng số với các hình mới chèn.

File `.drawio` gốc (dùng để sửa lại khi cần) vẫn còn nguyên trong
`So_do_LVTN_CapNhat3/` — nay đã sửa layout 4 sơ đồ trạng thái cho không
chồng chữ. `00_DANH_SACH_SO_DO.txt` liệt kê đầy đủ.

## Việc còn lại

- **Mục lục (TOC) và Mục lục hình ảnh** ở đầu văn bản là field cache cũ,
  chưa phản ánh nội dung/số trang mới — mở file trong Word, bấm Ctrl+A rồi
  F9 để Word tự cập nhật (bạn đã nói sẽ tự làm phần này).
- File `LVTN_5chuong_CapNhat.docx` (bản v1, thiếu ảnh, đã lỗi định vị 2 mục
  do một bug đã sửa) không xóa được do khóa file trên máy bạn — bạn có thể
  tự xóa tay, chỉ dùng **`LVTN_5chuong_CapNhat_v2.docx`** (bản đầy đủ và đã
  soát lại từng trang).
