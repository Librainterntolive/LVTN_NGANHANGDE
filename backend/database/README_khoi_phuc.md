# Khôi phục cơ sở dữ liệu

`quiz_db.sql` là bản sao đầy đủ **cấu trúc + dữ liệu** của hệ thống, xuất ngày
05/08/2026. Đây là dữ liệu thật đang chạy, không phải dữ liệu giả.

## Nội dung

| Bảng | Số bản ghi |
|---|---|
| subjects (môn học) | 65 — trong đó 27 môn Đại học đang hiện, 36 môn phổ thông tạm ẩn |
| questions (câu hỏi) | 1.399 |
| answers (đáp án) | 5.592 |
| exams (đề thi) | 68 |
| exam_questions | 1.538 |
| users (tài khoản) | 7 |

## Cách khôi phục

```bash
mysql -u root -e "CREATE DATABASE quiz_db CHARACTER SET utf8mb4;"
mysql -u root --default-character-set=utf8mb4 quiz_db < quiz_db.sql
```

Sau đó chạy backend bằng `.\run.ps1` là dùng được ngay.

## Lưu ý

- Phải có `--default-character-set=utf8mb4` khi khôi phục, nếu không tiếng Việt
  sẽ bị lỗi phông.
- Tệp có sẵn 7 tài khoản mẫu, mật khẩu đã mã hóa bằng bcrypt. Tài khoản quản
  trị: `admin` / `admin123`.
- Muốn hiện lại các môn phổ thông đã ẩn:
  `UPDATE subjects SET hidden = 0 WHERE level LIKE 'Khối%';`

## Xuất lại bản mới

```bash
mysqldump -u root --default-character-set=utf8mb4 --add-drop-table \
  --complete-insert --single-transaction --skip-extended-insert \
  quiz_db > quiz_db.sql
```
