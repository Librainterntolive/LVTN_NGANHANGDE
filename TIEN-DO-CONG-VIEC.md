# Nhật ký công việc — hệ thống quản lý ngân hàng đề thi

Ghi lại những gì đã làm, đã kiểm chứng thế nào, và còn tồn đọng gì.
Cập nhật lần cuối: 18/08/2026.

Kho mã: `https://github.com/Librainterntolive/LVTN_NGANHANGDE` (riêng tư).
Nhánh `main` đã đồng bộ với GitHub. 277 tệp được theo dõi.

---

## 1. Chức năng đã hoàn thiện

**Ngân hàng câu hỏi có kiểm duyệt.** Mỗi câu hỏi bắt buộc gắn nguồn đã được
quản trị viên xác thực, kèm vị trí tham chiếu cụ thể. Câu hỏi phải qua bước
duyệt mới được dùng cho đề công khai.

**Ngân hàng song ngữ.** Mỗi câu lưu song song bản gốc theo ngôn ngữ tài liệu
nguồn và bản tiếng Việt hiển thị cho người học. Giao diện có nút *Xem nguyên
bản* để đối chiếu.

**Không gian lớp học kiểu Google Classroom.** Mỗi lớp có trang riêng với bốn
tab: Bảng tin, Bài tập, Thành viên, Điểm. Giảng viên giao bài kèm hạn nộp và
mốc nộp muộn; sinh viên nộp tệp; giảng viên tải tệp về, chấm điểm và nhận xét.

**Thống kê.** Xem theo từng lớp, trong lớp xem từng sinh viên, kèm điểm trung
bình lớp tính theo hai cách: chỉ tính bài đã nộp, và tính cả bài chưa nộp là 0.

**Nhật ký thao tác.** Ghi lại các thao tác quản trị quan trọng để truy vết.

**Bảo mật.** Mật khẩu băm bcrypt, xác thực JWT, giới hạn tần suất gọi API,
giới hạn kích thước request, header bảo mật, và mã hóa tệp bài nộp trên đĩa.

---

## 2. Nguyên tắc dữ liệu

Hệ thống chỉ lưu dữ liệu thật. Mỗi bộ đề phải trả lời được ba câu: lấy từ nguồn
nào, nguồn đó đã xác thực chưa, ai là người phê duyệt.

Đã xóa toàn bộ dữ liệu thử nghiệm còn sót từ giai đoạn phát triển: 6 lớp có tên
vô nghĩa và 9 tài khoản không sở hữu dữ liệu nào. Lệnh xóa có điều kiện bảo vệ
để không xóa nhầm tài khoản đang giữ câu hỏi, đề thi hay nguồn.

Script `backend/scripts/verify-real-data.ps1` kiểm tra ràng buộc này và hiện
báo **ĐẠT** trên toàn bộ các mục.

### Dữ liệu hiện có

| Bảng | Số dòng |
|---|---|
| Tài khoản | 3 |
| Học phần đang hiện | 29 |
| Câu hỏi (đã duyệt, có nguồn) | 20 |
| Nguồn đã xác thực | 2 |
| Đề thi | 1 |
| Lớp học | 2 |
| Bài tập | 1 |
| Bài nộp | 1 |
| Nhật ký thao tác | 7 |

---

## 3. Những lỗi đã sửa

### Ngôn ngữ hiển thị

Trước đây toàn bộ 168 thông báo API của backend viết không dấu, trong khi
frontend đã có dấu đầy đủ, nên người dùng thấy chỗ có dấu chỗ không.

Đã chuẩn hóa **180 chuỗi** sang tiếng Việt có dấu: thông báo lỗi API, mô tả
nhật ký hệ thống, và ba mẫu email gửi cho sinh viên/giảng viên.

### Email

Tiêu đề thư trước đây nhét UTF-8 thô vào header `Subject`, sai RFC 5322 nên có
thể hiện sai phông ở một số ứng dụng mail. Đã mã hóa theo RFC 2047, kèm ba bài
kiểm thử: giữ nguyên nội dung sau khi giải mã, bỏ qua chuỗi thuần ASCII, và
chặn chèn header qua ký tự xuống dòng.

### Giao diện

Giao diện cũ mang dấu hiệu của bản dựng chắp vá: các giá trị px tùy tiện, ba
lớp biến màu chồng lên nhau, và emoji dùng làm biểu tượng.

| Chỉ số | Trước | Sau |
|---|---|---|
| Cỡ chữ khác nhau | 28 | 9 bậc |
| Bo góc khác nhau | 18 | 4 bậc |
| Công thức đổ bóng | 30 | 3 bậc |
| Mã màu đặt cứng | 176 | 41 |
| Emoji làm biểu tượng | 163 | 0 |
| Lớp biến màu chồng nhau | 3 | 1 |

Thay toàn bộ emoji bằng bộ 47 biểu tượng SVG một nét, dùng `currentColor` nên
tự đổi theo chế độ sáng/tối. Bỏ khối trang trí orbit, bỏ gradient đổi tông
xanh sang tím, và gộp sáu thẻ thống kê sáu màu cầu vồng về một kiểu thẻ chung.

### Tương phản màu

Khi đổi dải tiêu đề sang màu chủ đạo, chế độ tối cho tương phản chỉ 2,26 —
dưới ngưỡng WCAG AA là 4,5 — vì ở chế độ tối màu chủ đạo là màu sáng. Đã tách
biến riêng giữ nền đậm ở cả hai chế độ, đưa tỷ lệ lên 13,17. Cũng phát hiện
màu chữ mờ cũ chỉ đạt 3,75 trên nền trắng, đã chỉnh thành 4,88.

Toàn bộ 17 cặp màu hiện đạt WCAG AA ở cả chế độ sáng và tối.

### Lỗi lộ ra khi chạy thật

Ba lỗi dưới đây chỉ xuất hiện khi đăng nhập và thao tác thật, không thấy được
khi đọc mã nguồn:

1. **Bố cục trang chủ vỡ.** Sau khi thay emoji bằng `app-icon`, ba quy tắc CSS
   nhắm vào thẻ `span` mất tác dụng, làm đoạn mô tả bị ép vào cột 34px.
2. **Trạng thái tài khoản hiển thị sai.** Màn hình Người dùng chỉ kiểm tra
   trạng thái `locked`; mọi trạng thái khác đều hiện là *Hoạt động*. Tài khoản
   chưa xác minh email vì thế trông như dùng được, trong khi thực tế không
   đăng nhập được.
3. **Màn hình chấm bài không hiện tên sinh viên.** Chỉ hiện `Sinh viên #23`.
   Entity có sẵn hai trường tên nhưng không có chỗ nào điền dữ liệu vào.

---

## 4. Bảo mật kho mã

Trước khi đẩy lên GitHub đã rà và xử lý:

- `backend/.env` không được theo dõi — chỉ có `.env.example` với giá trị mẫu
- `backend/database/quiz_db.sql` chứa 7 chuỗi băm mật khẩu và 6 địa chỉ email
  thật, đã gỡ khỏi theo dõi
- `backend/data/` chứa tệp bài nộp của sinh viên, đã bổ sung vào `.gitignore`
  trước khi kịp bị đẩy lên
- Đã xóa địa chỉ email trong chú thích của migration dọn dữ liệu

**Lưu ý còn tồn:** bản dump cơ sở dữ liệu vẫn nằm trong hai commit cũ
(`f78299b`, `634cf9f`). Với kho riêng tư thì rủi ro thấp. **Nếu chuyển kho sang
công khai thì phải viết lại lịch sử trước.**

---

## 5. Mức độ kiểm chứng

- `gofmt`, `go build`, `go vet` đều sạch
- Toàn bộ kiểm thử backend đạt, trong đó có 8 bài cho ràng buộc chống bịa bản
  dịch và 3 bài cho mã hóa tiêu đề thư
- Angular build sạch, 8 bài kiểm thử frontend đạt
- Gọi API thật xác nhận thông báo đã có dấu
- Đã chạy thật toàn bộ luồng lớp học: tạo lớp, giao bài, nộp bài, khóa nộp,
  xem bài nộp, tải tệp

### Nghiệp vụ hạn nộp — đã kiểm chứng bằng thao tác thật

Bài tập đặt hạn nộp 19:25, cho nộp muộn đến 19:30:

| Thời điểm | Kết quả |
|---|---|
| Nộp lúc 19:27 | Nhận bài, gắn nhãn **nộp muộn**, CSDL ghi `status = late` |
| Nộp sau 19:30 | Từ chối, báo *Bài tập đã đóng nộp* |

### Mã hóa tệp bài nộp — đã kiểm chứng trên đĩa

Tệp lưu dưới tên ngẫu nhiên `.bin`, không lộ tên gốc. Bốn byte đầu là
`b9 08 3e 94`, không phải `%PDF`, nên không mở được bằng trình đọc PDF. Chỉ khi
tải qua hệ thống, đúng người có quyền, tệp mới được giải mã.

---

## 6. Còn tồn đọng

**Gửi email chưa hoạt động.** `SMTP_PASSWORD` trong `.env` vẫn là chuỗi mẫu, không
phải mật khẩu ứng dụng Gmail thật. Gmail trả về `535 BadCredentials`. Hệ quả là
luồng xác minh OTP khi đăng ký không chạy được; hiện phải nhờ quản trị viên tạo
hoặc kích hoạt tài khoản trực tiếp. Muốn bật thì tạo App Password của Google rồi
dán vào `SMTP_PASSWORD=`.

**Lỗi SMTP lộ nguyên văn ra người dùng.** Màn hình xác minh hiện cả mã lỗi
`535 5.7.8` lẫn đường dẫn hỗ trợ của Google. Nên đổi thành thông báo thân thiện
và chỉ ghi chi tiết vào log.

**Dữ liệu vận hành còn mỏng.** Mới có 1 lớp thật với 1 sinh viên, 1 bài tập,
1 bài nộp chưa chấm. Muốn màn hình Thống kê có số liệu thì cần chấm bài này và
bổ sung thêm sinh viên thật.

**28 trong 29 học phần chưa có câu hỏi.** Chỉ *Tin học đại cương* có 20 câu.

**Commit có thể chưa gắn vào hồ sơ GitHub.** Git đang ký bằng
`truongvominhtu@gmail.com`. Nếu địa chỉ này chưa được thêm vào tài khoản
`Librainterntolive` thì biểu đồ đóng góp sẽ trống. Khắc phục bằng cách thêm
email đó trong phần Settings của GitHub.

**Kiến trúc CSS.** 16 tệp giao diện vẫn nhúng thẻ `<style>` trực tiếp. Angular
không cô lập loại style này nên chúng rò ra phạm vi toàn cục. Hiện chưa gây lỗi
hiển thị nào vì khung ứng dụng dùng tên lớp riêng, nhưng là rủi ro bảo trì.

---

## 7. Đợt làm việc thứ hai

### Email gửi cho người dùng

Gmail từ chối gửi với mã `535 BadCredentials`. Nguyên nhân: `SMTP_PASSWORD` là
chuỗi mẫu, chưa từng được thay. Sau khi thay bằng App Password thật thì phát
hiện thêm mật khẩu được dán kèm khoảng trắng theo đúng cách Google hiển thị
(`abcd efgh ijkl mnop`), khiến máy chủ vẫn từ chối. Đã sửa trong mã nguồn: hàm
gửi thư tự bỏ khoảng trắng, nên người cài đặt hệ thống về sau không vấp chỗ này.

Cũng phát hiện `SMTP_FROM` không khớp `SMTP_USERNAME` — Gmail bắt buộc trùng.

**Lỗi lộ thông tin:** màn hình xác minh hiện nguyên văn mã lỗi SMTP kèm đường
dẫn hỗ trợ của Google. Người dùng cuối không dùng được thông tin đó, và nó để
lộ cấu hình hệ thống thư bên trong. Nay chi tiết chỉ ghi vào log, người dùng
thấy một thông báo thân thiện duy nhất.

**Nâng chuẩn thư:** thư OTP và mật khẩu tạm nay là thư giao dịch đúng chuẩn —
mã hiển thị nổi bật trong khung riêng, có cảnh báo bảo mật chống lừa đảo qua
điện thoại, có chân thư, và gửi kèm bản văn bản thuần cho ứng dụng mail cũ.
Mọi nội dung đưa vào thư đều được thoát ký tự HTML.

### Ngân hàng câu hỏi

Trước đây chỉ 1 trong 29 học phần có câu hỏi, nên chọn học phần khác thì bộ
chọn câu hỏi trống và không tạo được đề thi — đúng lỗi đã gặp.

Đã bổ sung **90 câu hỏi cho 6 học phần**, đọc thật tài liệu gốc rồi mới soạn:

| Học phần | Nguồn |
|---|---|
| Cơ sở dữ liệu nâng cao | MySQL 8.4 Reference Manual |
| Hệ điều hành | Linux man-pages `fork(2)`, `signal(7)` |
| Công nghệ phần mềm | Git Documentation |
| Mạng máy tính | RFC 9110, RFC 9293 |
| Lập trình Web nâng cao | MDN Web Docs |
| Lập trình C/C++ | C++ Core Guidelines |

`cppreference.com` chặn truy cập nên đã đổi sang C++ Core Guidelines thay vì
đoán nội dung.

### In đề thi nhiều mã đề

Bản in cũ luôn giữ nguyên thứ tự dù đề đã bật xáo trộn — in bao nhiêu bản cũng
giống hệt nhau, không chống được nhìn bài.

Nay in được tối đa 8 mã đề, mỗi mã có thứ tự câu và đáp án riêng. Ba điểm quan
trọng: seed suy ra từ mã đề thi và số thứ tự mã đề chứ không dùng thời gian nên
in bù ra đúng tờ giấy cũ; sau khi xáo thì đáp án được đánh lại nhãn A/B/C/D; và
bảng đáp án nằm ở tệp riêng, có dòng cảnh báo không phát cho sinh viên.

### Giao diện

Đổi bảng màu sang tông sage theo yêu cầu. Bảng màu gốc gồm bốn màu đều sáng nên
tự nó không đủ làm giao diện — màu đậm nhất đặt lên màu sáng nhất chỉ đạt tương
phản 2.34. Đã bổ sung sắc độ đậm cùng họ cho phần chữ và nút, dò từng giá trị
để đạt WCAG AA.

Thay logo Angular mặc định bằng logo riêng: tờ đề thi kèm dấu kiểm duyệt.

### Lỗi khác đã sửa

- Lỗi nghiệp vụ khi tạo đề trả về `500` thay vì `400`, khiến người dùng tưởng
  máy chủ hỏng
- Liên kết trong màn hình Đề thi không bấm được vì thiếu import `RouterLink` —
  Angular không báo lỗi vì đó là thuộc tính tĩnh
- Chip lọc gần như đọc không ra: chữ trắng trên nền xám nhạt, tương phản 1.2
- Hàng đáp án bị vỡ do quy tắc `input{width:100%}` áp cả cho nút tròn
- Màn hình Người dùng hiện tài khoản chưa xác minh là "Hoạt động"
- Màn hình chấm bài chỉ hiện `Sinh viên #23` thay vì họ tên
- Yêu cầu cấp lại mật khẩu không hiện tên vì entity thiếu thẻ JSON

### Nguyên nhân "test không chạy"

Toàn bộ dịch vụ WAMP ở trạng thái Stopped, kiểu khởi động Manual — máy khởi
động lại là mất. Không có cơ sở dữ liệu thì mọi thứ đứng im. Nên đặt dịch vụ
sang Automatic, hoặc mở WAMP từ khay hệ thống trước khi làm việc.

### Số liệu hiện tại

| Chỉ số | Giá trị |
|---|---|
| Câu hỏi / đáp án | 110 / 440 |
| Nguồn đã xác thực | 14 |
| Học phần đang hiện | 29 |
| Đề thi | 8 |
| Bài kiểm thử backend | 46 |
| Emoji làm biểu tượng | 0 |
| Cỡ chữ và bo góc đặt tùy ý | 0 |
