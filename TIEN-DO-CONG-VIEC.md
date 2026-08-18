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

**13 trong 29 học phần chưa có câu hỏi.** Đã phủ 16 học phần. Còn trống:
Triết học Mác - Lênin, Toán cao cấp, Pháp luật đại cương, Giáo dục quốc phòng
và an ninh, Tiếng Anh, Kỹ năng mềm, Kinh tế vi mô, Kinh tế vĩ mô, Nguyên lý kế
toán, Marketing căn bản, Quản trị học và hai học phần cũ *Cơ sở dữ liệu*,
*Lập trình Web*.

**Bảng dùng lẫn hai engine.** 11 bảng là InnoDB (do GORM tạo), 12 bảng là MyISAM
(do các tệp SQL tạo, thừa hưởng mặc định của WAMP): `sources`, `assignments`,
`assignment_submissions`, `audit_logs`, `email_otps`, `password_reset_requests`,
`chapters`, `class_posts`, `folders`, `folder_exams`, `practice_answers`,
`upload_sessions`. MyISAM không có giao dịch, nên `START TRANSACTION ... COMMIT`
trong các tệp seed thực chất không bảo vệ được gì cho những bảng này; cũng không
có khoá ngoại. Nên chuyển sang InnoDB, nhưng đó là thay đổi diện rộng nên chưa làm.

**Commit có thể chưa gắn vào hồ sơ GitHub.** Git đang ký bằng
`truongvominhtu@gmail.com`. Nếu địa chỉ này chưa được thêm vào tài khoản
`Librainterntolive` thì biểu đồ đóng góp sẽ trống. Khắc phục bằng cách thêm
email đó trong phần Settings của GitHub.

**Kiến trúc CSS.** 16 tệp giao diện vẫn nhúng thẻ `<style>` trực tiếp. Angular
không cô lập loại style này nên chúng rò ra phạm vi toàn cục. Hiện chưa gây lỗi
hiển thị nào vì khung ứng dụng dùng tên lớp riêng, nhưng là rủi ro bảo trì.
Hai thành phần dùng chung mới (`paginator`, `searchable-select`) đã dùng `styles:`
của Angular nên style của chúng được cô lập đúng cách.

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

---

## 8. Đợt làm việc thứ ba

### Thêm 135 câu hỏi cho 9 học phần

Trước khi soạn, mỗi nguồn ứng viên đều được **tải thử thật** để không lặp lại
tình huống `cppreference.com` bị chặn ở đợt trước. Kết quả rà nguồn:
`thuvienphapluat.vn` trả 403; `vbpl.vn` và `congbao.chinhphu.vn` chỉ đăng phần
mô tả văn bản, toàn văn nằm trong tệp PDF; giáo trình lý luận chính trị do Bộ
Giáo dục và Đào tạo ban hành không có bản trực tuyến đọc được.

Chỉ dùng những nguồn đọc được toàn văn:

| Học phần | Số câu | Nguồn |
|---|---|---|
| Cấu trúc dữ liệu và giải thuật | 15 | Python 3 Documentation; Java SE 21 API Specification (Oracle) |
| Xác suất thống kê | 15 | NIST/SEMATECH e-Handbook of Statistical Methods |
| Đại số tuyến tính | 15 | NIST Digital Library of Mathematical Functions; LAPACK Users' Guide |
| Giải tích | 15 | NIST Digital Library of Mathematical Functions §1.4, §1.5 |
| Vật lý đại cương | 15 | NIST (đơn vị SI, 7 hằng số định nghĩa, tiền tố); BIPM |
| Chủ nghĩa xã hội khoa học | 15 | Cương lĩnh 2011 (Đại hội XI) |
| Kinh tế chính trị Mác - Lênin | 15 | Cương lĩnh 2011, mục III.1 về kinh tế |
| Tư tưởng Hồ Chí Minh | 15 | Di chúc Chủ tịch Hồ Chí Minh (bản 1969); Điều lệ Đảng; Cương lĩnh 2011 |
| Lịch sử Đảng Cộng sản Việt Nam | 15 | Điều lệ Đảng (Đại hội XI); Cương lĩnh 2011 phần I |

Ba văn kiện trong nước được tải về và đọc **toàn văn** trước khi soạn, không dựa
vào bài bình luận hay bản tóm tắt: Cương lĩnh 2011 (32.000 ký tự), Điều lệ Đảng
do Đại hội XI thông qua ngày 19/01/2011 (44.000 ký tự), và Di chúc công bố năm
1969.

Câu hỏi được sinh bằng script nên khuôn SQL đồng nhất; vị trí đáp án đúng được
xoay vòng thay vì dồn hết vào phương án A. Phân bố đáp án đúng của 135 câu mới:
A 21, B 22, C 27, D 27 câu.

### Lỗi phát hiện khi chạy thật: URL nguồn bị cắt âm thầm

Cột `sources.url` khai báo `VARCHAR(191)`. URL của Cương lĩnh 2011 trên
`tulieuvankien.dangcongsan.vn` dài 194 ký tự. MySQL đang chạy ở chế độ không
nghiêm ngặt (`sql_mode` rỗng) nên **không báo lỗi mà cắt bớt** phần đuôi. Hệ quả
dây chuyền: câu lệnh tra id nguồn theo URL đầy đủ trả về `NULL`, kéo theo 30 câu
hỏi không được chèn — và toàn bộ quá trình vẫn báo chạy thành công.

Đã nới cột lên `VARCHAR(250)` và sửa thẻ GORM trong `entity.go` cho khớp. Không
nới được lên 512 vì bảng `sources` đang dùng engine MyISAM, giới hạn độ dài khoá
là 1000 byte, mà utf8mb4 tốn 4 byte một ký tự.

### Số liệu sau đợt ba

| Chỉ số | Giá trị |
|---|---|
| Câu hỏi / đáp án | 245 / 980 |
| Nguồn đã xác thực | 32 |
| Học phần có câu hỏi | 16 / 29 |
| Đề thi | 8 |
| Bài kiểm thử backend | 46 (toàn bộ đạt) |
| Câu thiếu nguồn / thiếu vị trí tham chiếu | 0 / 0 |
| Câu sai số đáp án đúng / không đủ 4 phương án | 0 / 0 |

Kiểm chứng: `scripts/verify-real-data.ps1` báo **ĐẠT** toàn bộ; `gofmt`,
`go build`, `go vet` sạch; toàn bộ kiểm thử backend đạt.


---

## 9. Đợt làm việc thứ tư — phân trang và ô chọn có tìm kiếm

### Vì sao phải đổi

Trước đợt này, 13 màn hình danh sách dùng cuộn-vô-tận: mỗi lần cuộn tải thêm 12
mục. Cách đó không tới được dòng ở giữa của danh sách dài, và không quay lại
đúng chỗ vừa xem được.

Nặng hơn là các ô chọn. Ô *Học phần* chỉ nạp 12 học phần đầu kèm nút *Tải thêm
môn*, nên học phần thứ 13 trở đi đơn giản là **không có trong ô chọn** cho tới
khi người dùng bấm tải thêm — với hàng nghìn bản ghi thì không dùng được.

### Hai thành phần dùng chung

`shared/paginator.ts` — thanh « Trước | 1 2 3 … | Sau », kèm ô chọn 5/10/20/50
dòng mỗi trang (mặc định 10) và dòng đếm *"1–10 trên 27"*. Dãy số trang rút gọn
khi nhiều hơn 7 trang: luôn giữ trang đầu, trang cuối và lân cận trang hiện tại.

`shared/searchable-select.ts` — ô chọn có gõ để tìm. Gõ tới đâu hỏi máy chủ tới
đó, chờ 250ms để không bắn request theo từng phím; đi lại bằng phím mũi tên,
Enter chọn, Escape đóng; có thuộc tính ARIA `combobox`/`listbox` và nút xóa lựa
chọn. Số lượng bản ghi không còn ảnh hưởng tới thao tác chọn.

### Đã thay ở đâu

Phân trang số trang (17 danh sách trên 13 màn hình): Học phần, Câu hỏi, Đề thi,
Người dùng (kèm danh sách yêu cầu cấp lại mật khẩu), Nguồn tài liệu, Nhật ký hệ
thống, Lớp học (lớp, sinh viên, đề đã giao), Chi tiết lớp (bảng tin, bài tập,
bài nộp, sinh viên, điểm), Lớp của tôi, Đề của tôi, Bài nộp của tôi, Góc học tập
(đề đã lưu, ngân hàng đề, sổ tay câu sai), Thống kê (theo đề, theo lớp), Chi
tiết học phần (đề thi, câu hỏi), và bảng chọn câu hỏi khi soạn đề.

Ô chọn có tìm kiếm: học phần (Câu hỏi — cả form và bộ lọc, Đề thi, Góc học tập),
nguồn tài liệu (Câu hỏi), lớp học (Thống kê), đề thi để lấy thêm câu (Đề thi).
Các ô chọn danh sách tĩnh như độ khó, vai trò, trạng thái vẫn giữ `<select>`
thường vì không có gì để tìm.

Directive `infinite-scroll.directive.ts` đã xóa vì không còn nơi nào dùng.

### Ba lỗi thật phát hiện khi làm

**Máy chủ âm thầm bỏ qua số dòng mỗi trang.** 20 chỗ trong controller đang chặn
`limit` ở mức 15: chọn 20 hoặc 50 dòng thì máy chủ lặng lẽ trả về 12. Đã nâng
trần lên 100.

**Ô "Mỗi trang" hiện sai số.** Ô chọn hiển thị 5 trong khi trang đang lấy 10
dòng. Nguyên nhân: `[value]` gán cho thẻ `<select>` chạy trước khi các `<option>`
kịp dựng, nên trình duyệt rơi về giá trị đầu danh sách. Đã chuyển sang đánh dấu
`[selected]` trên từng option. Lỗi này chỉ lộ ra khi mở trình duyệt xem thật.

**Danh sách lớp chưa tìm được theo từ khóa.** `/classes/paged` và
`/classes/assignable/paged` chưa nhận tham số `keyword`, nên ô chọn lớp có tìm
kiếm không hoạt động được. Đã bổ sung từ repository lên tới controller.

### Ghi chú kỹ thuật

Bảng Đề thi chỉ có `subject_id` chứ không kèm tên học phần. Trước đây tên lấy từ
danh sách học phần đã nạp sẵn — chính là thứ vừa bỏ đi. Nay tên được tra một lần
theo id rồi nhớ lại trong bộ nhớ màn hình, nên không phải tải cả danh mục học
phần chỉ để hiện một cái tên.

Tệp `frontend/src/environments/environment.ts` đã bỏ khỏi theo dõi git và thêm
vào `.gitignore`, kèm `environment.example.ts` làm mẫu — mỗi máy và mỗi lần
triển khai trỏ về một địa chỉ API khác nhau.

### Lỗi làm trắng bốn màn hình — build xanh vẫn không chạy được

Sau khi thay xong, các màn hình Đề thi, Thống kê, Góc học tập và Ngân hàng câu
hỏi **không hiển thị gì**; đăng nhập xong cũng đứng lại ở trang đăng nhập, vì
sau khi đăng nhập router đưa thẳng vào `/exams` mà màn hình đó ném lỗi.

Nguyên nhân: component ô chọn có một input đặt tên `valueOf`. Angular gom
input/output của directive vào một object thường, mà `valueOf` là hàm có sẵn
trên `Object.prototype`, nên khi tra bảng binding Angular nhận về hàm kế thừa
thay vì mảng và ném `TypeError: bindings[publicName].push is not a function`
ngay lúc dựng màn hình. Đã đổi tên input thành `idOf`.

Đáng nói là `ng build` **báo thành công** với lỗi này — nó chỉ lộ ra lúc chạy.
Vì vậy đã thêm `shared/man-hinh-dung-duoc.spec.ts`: dựng thật 14 màn hình có
dùng phân trang hoặc ô chọn, chỉ cần dựng được là đạt. Bài kiểm thử này tái hiện
đúng lỗi trên, nên lần sau loại lỗi đó không lọt được nữa.

### Kiểm chứng

- `gofmt`, `go build`, `go vet` sạch; 46 bài kiểm thử backend đạt
- Angular build sạch; 22 bài kiểm thử frontend đạt (8 bài cũ + 14 màn hình dựng thật)
- Chạy thật trên trình duyệt màn hình Học phần: hiển thị đúng 10 dòng, chuyển
  sang trang 2 đổi đúng nội dung (11–20 trên 27), đổi sang 5 dòng/trang thì
  quay về trang 1 và tách thành 6 trang. Mỗi lần đổi trang chỉ gọi API một lần
  với đúng `page` và `limit`, không có lỗi nào trong console.
- **Chưa chạy thật** phần ô chọn có tìm kiếm trên trình duyệt vì các màn hình đó
  cần đăng nhập; mới kiểm ở mức dựng được bằng bài kiểm thử.

### Dọn dẹp sau khi chạy thử

**Ô chọn học phần hiện dấu hỏi.** Khi chưa chọn gì, ô chọn hiện `?` thay vì dòng
gợi ý, do hàm tra tên học phần trả về `?` cho id bằng 0. Đã sửa ở hai chỗ: form
tạo đề thi và bộ lọc ngân hàng đề trong Góc học tập.

**Gỡ bản dump cũ khỏi mã nguồn.** `backend/database/quiz_db.sql` là bản chụp
ngày 05/08, đã lỗi thời (chưa có 135 câu hỏi bổ sung) và chứa chuỗi băm mật khẩu
cùng email thật. Tệp không được git theo dõi nên xóa an toàn. Bản sao lưu nay
nằm ở `backend/backups/` — thư mục đã có trong `.gitignore`; bản mới nhất đã
kiểm đủ 245 câu hỏi, 980 đáp án, 32 nguồn, 65 học phần, 7 tài khoản.

**Viết lại `database/README_khoi_phuc.md`.** Tài liệu cũ trỏ tới tệp vừa xóa, số
liệu còn của giai đoạn dữ liệu thử nghiệm (1.399 câu hỏi, 68 đề), và **ghi thẳng
mật khẩu quản trị `admin/admin123` trong tệp được git theo dõi**. Bản mới hướng
dẫn xuất/khôi phục từ `backend/backups/`, cách dựng lại từ đầu bằng thư mục
`migrations/`, và bỏ hẳn tài khoản mẫu kèm mật khẩu — muốn có quản trị viên thì
đăng ký rồi nâng quyền bằng một câu lệnh SQL.
