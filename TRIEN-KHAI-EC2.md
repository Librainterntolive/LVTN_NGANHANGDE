# Triển khai: backend trên EC2, frontend trên Vercel

Tài liệu này liệt kê **toàn bộ biến môi trường bắt buộc** và các bước triển khai.
Không ghi giá trị bí mật nào ở đây — chỗ nào cần điền thì để trống.

---

## 1. Vì sao OTP không gửi được trên bản đã triển khai

Tệp `backend/.env` nằm trong `.gitignore` (đúng, vì chứa mật khẩu), nên **nó
không đi theo mã nguồn lên EC2**. Nếu container chạy mà thiếu biến `SMTP_*`,
hàm gửi thư dừng ngay tại
[`email_service.go:140-143`](backend/internal/service/email_service.go#L140)
và chỉ ghi log *"chưa cấu hình SMTP"*.

Hệ quả đúng như triệu chứng đã gặp: **tài khoản vẫn được tạo, màn hình nhập OTP
vẫn hiện ra, nhưng không có thư nào được gửi đi**. Lý do là trong
[`auth_service.go:27-58`](backend/internal/service/auth_service.go#L27), thứ tự
xử lý là *tạo tài khoản → lưu OTP → gửi thư*; gửi thư hỏng không làm mất hai
bước trước.

Đã kiểm chứng ngày 19/08/2026: trên máy cá nhân, cùng bộ mã nguồn này đăng nhập
SMTP Gmail thành công và Gmail nhận thư bình thường. Vậy vấn đề nằm ở **cấu hình
của môi trường triển khai**, không nằm ở mã nguồn.

---

## 2. Biến môi trường bắt buộc trên EC2

Thiếu bất kỳ biến nào ở nhóm "bắt buộc" thì tính năng tương ứng sẽ hỏng lặng lẽ.

### Cơ sở dữ liệu

| Biến | Bắt buộc | Ghi chú |
|---|---|---|
| `DB_HOST` | ✔ | Địa chỉ endpoint của RDS |
| `DB_PORT` | ✔ | Thường là `3306` |
| `DB_USER` | ✔ | |
| `DB_PASSWORD` | ✔ | |
| `DB_NAME` | ✔ | `quiz_db` |
| `AUTO_MIGRATE` | tùy | Đặt `true` **đúng một lần** khi dựng CSDL mới để GORM tạo bảng, sau đó bỏ đi cho khởi động nhanh. |

> **Về mã hóa đường truyền tới RDS:** hiện **chưa bật**. Ảnh Docker có tải sẵn CA
> bundle vào `/app/certs/regional.pem` nhưng mã nguồn chưa dùng tới, nên kết nối
> từ EC2 tới RDS đang ở dạng không mã hóa. Chấp nhận được khi cả hai nằm trong
> cùng một VPC riêng. Nếu sau này RDS bật `require_secure_transport` thì kết nối
> sẽ bị từ chối và lúc đó phải bổ sung tham số `tls` vào DSN.

### Gửi thư — chính là phần làm OTP hỏng

| Biến | Bắt buộc | Ghi chú |
|---|---|---|
| `SMTP_HOST` | ✔ | `smtp.gmail.com` |
| `SMTP_PORT` | ✔ | `587` |
| `SMTP_USERNAME` | ✔ | Địa chỉ Gmail dùng để gửi |
| `SMTP_PASSWORD` | ✔ | **Mật khẩu ứng dụng 16 ký tự** của Google, không phải mật khẩu đăng nhập Gmail. Dán kèm khoảng trắng cũng được, mã nguồn tự bỏ. |
| `SMTP_FROM` | ✔ | **Phải cùng địa chỉ với `SMTP_USERNAME`**, nếu khác Gmail sẽ từ chối. Dạng `Quiz System <dia-chi@gmail.com>` là hợp lệ. |

### Bảo mật và mạng

| Biến | Bắt buộc | Ghi chú |
|---|---|---|
| `JWT_SECRET` | ✔ | Chuỗi bí mật ký token đăng nhập. **Đặt chuỗi khác với máy cá nhân.** |
| `FILE_ENCRYPTION_KEY` | ✔ | Khóa mã hóa tệp bài nộp. **Đổi khóa này là không đọc lại được bài nộp cũ** — đặt một lần rồi giữ nguyên. |
| `ALLOWED_ORIGIN` | ✔ | Đúng địa chỉ Vercel, ví dụ `https://ten-du-an.vercel.app`. Bỏ trống thì mặc định là `http://localhost:4200` và trình duyệt sẽ chặn toàn bộ request từ bản đã triển khai. |
| `SERVER_PORT` | ✔ | Phải đặt `8080` cho khớp với `EXPOSE 8080` của Dockerfile. Bỏ trống thì mã nguồn dùng mặc định **8081** và cổng ánh xạ của container sẽ trỏ vào chỗ không có gì. |
| `TZ` | ✔ | `Asia/Ho_Chi_Minh`. Hạn nộp bài và hạn làm bài đều so theo giờ máy chủ; container mặc định chạy giờ UTC nên lệch 7 tiếng, sinh viên sẽ bị tính nộp muộn oan. |
| `UPLOAD_DIR` | tùy | Mặc định `data/uploads`, tính theo thư mục `/app` trong container. |
| `GIN_MODE` | tùy | Đặt `release` để bớt log. |

---

## 3. Chạy container trên EC2

> **Cách đang dùng: tự động qua GitHub Actions.**
> Quy trình nằm ở [`.github/workflows/docker-image.yml`](.github/workflows/docker-image.yml):
> đẩy mã lên nhánh `main` có đụng thư mục `backend/` là nó chạy kiểm thử → dựng
> ảnh Docker → đẩy lên DockerHub → SSH vào EC2 triển khai. Các biến ở mục 2 khai
> trong **Settings → Secrets and variables → Actions** của repo: giá trị bí mật
> (mật khẩu CSDL, `JWT_SECRET`, `FILE_ENCRYPTION_KEY`, `SMTP_PASSWORD`, khóa SSH)
> đặt ở **Secrets**; phần còn lại đặt ở **Variables**.
>
> Quy trình tự sinh tệp `.env` trên máy chủ, tự đặt `TZ=Asia/Ho_Chi_Minh`, tự gắn
> thư mục dữ liệu ngoài container và bật `--restart unless-stopped`. Biến
> `DATA_DIR` (Variables) đổi được chỗ chứa bài nộp, bỏ trống thì mặc định là
> `$HOME/quiz-backend/data` trên EC2.

Phần dưới là cách chạy tay, dùng khi cần thử nhanh hoặc khi quy trình tự động hỏng.


```bash
cd backend
docker build -t quiz-backend .

docker run -d --name quiz-backend \
  --restart unless-stopped \
  -p 8080:8080 \
  -v /var/lib/quiz-backend/data:/app/data \
  --env-file /etc/quiz-backend.env \
  quiz-backend
```

Hai điểm không được bỏ qua:

- **`-v` gắn ổ đĩa ngoài.** Tệp bài nộp của sinh viên nằm trong `/app/data`.
  Không gắn ổ ngoài thì mỗi lần triển khai lại là **mất sạch bài nộp**.
- **`--env-file` để ngoài mã nguồn.** Đặt tệp đó ở `/etc/quiz-backend.env`, quyền
  `chmod 600`, tuyệt đối không đưa vào repo.

### Nhóm bảo mật (Security Group) của EC2

- Mở cổng **8080** cho Internet (hoặc chỉ cho Vercel nếu muốn chặt hơn).
- Cổng **3306** của RDS chỉ mở cho Security Group của EC2, **không mở ra Internet**.
- Cổng **587** đi ra ngoài phải được phép, nếu không sẽ không gửi được thư.

> Lưu ý: tài khoản AWS mới thường bị **chặn cổng 25** ở chiều đi. Ở đây dùng cổng
> 587 nên không vướng, nhưng nếu đổi sang cổng 25 thì phải xin AWS gỡ chặn.

---

## 4. Frontend trên Vercel

Khai một biến môi trường:

| Biến | Giá trị |
|---|---|
| `API_URL` | `http://<dia-chi-EC2>:8080/api` |

`set-env.js` chạy tự động qua script `prebuild` và sinh ra
`src/environments/environment.ts` lúc build. Thiếu `API_URL` thì bản build **dừng
hẳn với thông báo lỗi rõ ràng**, thay vì lặng lẽ tạo ra một bản chạy được nhưng
gọi API hỏng.

> **Cảnh báo về HTTPS:** trang Vercel chạy `https://`, nên trình duyệt sẽ **chặn**
> mọi lời gọi tới `http://` (mixed content). Cần đặt chứng chỉ cho EC2 — dựng
> Nginx hoặc Caddy làm proxy có HTTPS trước container — rồi đặt `API_URL` thành
> `https://...`. Đây là việc bắt buộc, không phải tùy chọn.

---

## 5. Danh sách kiểm tra sau khi triển khai

Chạy lần lượt, thay `<EC2>` bằng địa chỉ thật:

```bash
# 1. Máy chủ sống chưa
curl -i http://<EC2>:8080/api/ping

# 2. CORS đã trỏ đúng Vercel chưa (phải thấy Access-Control-Allow-Origin đúng địa chỉ)
curl -s -D - -o /dev/null -H "Origin: https://<ten-du-an>.vercel.app" \
  http://<EC2>:8080/api/subjects/paged?page=1

# 3. Có kết nối được CSDL không (phải trả về danh sách học phần, không phải lỗi 500)
curl -s http://<EC2>:8080/api/subjects/paged?page=1&limit=1

# 4. Gửi thư có chạy không — dùng chính địa chỉ email của mình
curl -s -X POST http://<EC2>:8080/api/auth/password-reset-otp \
  -H "Content-Type: application/json" \
  -d '{"email":"<email-cua-ban>"}'
```

Bước 4 trả về `{"message":"Đã gửi OTP quên mật khẩu"}` **nghĩa là máy chủ thư đã
nhận thư thật** — hàm này trả lỗi nếu gửi hỏng
([`auth_service.go:123`](backend/internal/service/auth_service.go#L123)). Nếu vẫn
trả lỗi, xem log container:

```bash
docker logs quiz-backend --tail 50 | grep -i "thu\|smtp"
```

| Log gặp phải | Nguyên nhân |
|---|---|
| `chưa cấu hình SMTP_HOST/SMTP_USERNAME/SMTP_PASSWORD` | Thiếu biến môi trường |
| `535 ... BadCredentials` | Sai mật khẩu ứng dụng, hoặc đang dùng mật khẩu Gmail thường |
| `550 ... not allowed` | `SMTP_FROM` khác `SMTP_USERNAME` |
| Treo rồi hết giờ | Security Group chặn cổng 587 đi ra |

---

## 6. Dựng cấu trúc CSDL trên RDS

Repo **không mang theo dữ liệu** (bản dump nằm ở `backend/backups/`, đã gitignore).
Dựng bảng trên RDS bằng thư mục migration:

```bash
for f in backend/database/migrations/*.sql; do
  mysql -h <endpoint-RDS> -u <user> -p --default-character-set=utf8mb4 quiz_db < "$f"
done
```

Các tệp migration chạy lại nhiều lần vẫn an toàn: câu hỏi chặn trùng bằng
`content_hash`, nguồn chặn trùng bằng khóa duy nhất trên `url`.

Muốn chuyển luôn dữ liệu đang có ở máy cá nhân:

```bash
powershell -File backend/scripts/backup-quiz-db.ps1
mysql -h <endpoint-RDS> -u <user> -p --default-character-set=utf8mb4 quiz_db \
  < backend/backups/quiz_db-<ngay>-<gio>.sql
```

Bắt buộc có `--default-character-set=utf8mb4`, nếu không tiếng Việt sẽ lỗi phông.
