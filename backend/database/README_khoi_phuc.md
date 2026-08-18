# Khôi phục cơ sở dữ liệu

Thư mục này **không chứa bản sao dữ liệu**. Bản sao được xuất vào
`backend/backups/` — thư mục đó nằm trong `.gitignore` vì bản dump chứa chuỗi
băm mật khẩu và địa chỉ email thật của người dùng.

Cấu trúc bảng dựng lại được từ `database/migrations/`, nên repo không cần mang
theo dữ liệu.

## Xuất một bản sao mới

```bash
powershell -File backend/scripts/backup-quiz-db.ps1
```

Script ghi tệp `quiz_db-<ngày>-<giờ>.sql` vào `backend/backups/`.

## Khôi phục từ một bản sao

```bash
mysql -u root -e "CREATE DATABASE IF NOT EXISTS quiz_db CHARACTER SET utf8mb4;"
mysql -u root --default-character-set=utf8mb4 quiz_db < backups/quiz_db-<ngày>-<giờ>.sql
```

Bắt buộc có `--default-character-set=utf8mb4`, nếu không tiếng Việt sẽ lỗi phông.

## Dựng mới từ đầu, không có bản sao

Chạy lần lượt các tệp trong `database/migrations/` theo thứ tự tên (tên tệp bắt
đầu bằng ngày nên xếp theo bảng chữ cái là đúng thứ tự):

```bash
for f in database/migrations/*.sql; do
  mysql -u root --default-character-set=utf8mb4 quiz_db < "$f"
done
```

Các tệp migration đều chạy lại được nhiều lần mà không nhân đôi dữ liệu: câu hỏi
chặn trùng bằng `content_hash`, nguồn chặn trùng bằng khóa duy nhất trên `url`.

Sau đó tạo tài khoản quản trị đầu tiên bằng màn hình đăng ký rồi nâng quyền
trực tiếp trong CSDL:

```sql
UPDATE users SET role = 'Admin', status = 'active' WHERE username = '<tên đăng nhập>';
```

Không đặt sẵn tài khoản mẫu kèm mật khẩu trong repo.

## Dữ liệu hiện có

Cập nhật 19/08/2026:

| Bảng | Số bản ghi |
|---|---|
| subjects (học phần) | 65 — 27 học phần Đại học đang hiện, còn lại là môn phổ thông tạm ẩn |
| questions (câu hỏi) | 245 — đều đã duyệt và có nguồn đã xác thực |
| answers (đáp án) | 980 |
| sources (nguồn) | 32 |
| exams (đề thi) | 8 |
| classes (lớp học) | 5 |
| users (tài khoản) | 7 |

Muốn hiện lại các môn phổ thông đang ẩn:

```sql
UPDATE subjects SET hidden = 0 WHERE level LIKE 'Khối%';
```

## Kiểm tra sau khi khôi phục

```bash
powershell -File backend/scripts/verify-real-data.ps1
```

Script chỉ đọc, không sửa dữ liệu. Nó kiểm tra không có câu hỏi thiếu nguồn,
không có câu sai số đáp án đúng, và không có đề công khai chứa câu chưa duyệt.
