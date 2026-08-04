-- =====================================================================
-- Tập trung vào bậc Đại học
--   1. Tạm ẩn toàn bộ môn khối 10/11/12 (dữ liệu vẫn còn, chỉ không hiện)
--   2. Bổ sung nhóm Công nghệ thông tin và Kinh tế - Quản trị
--
-- Chạy:  mysql -u root quiz_db < database/seed-mon-dai-hoc.sql
-- Hiện lại môn phổ thông:  UPDATE subjects SET hidden=0 WHERE level LIKE 'Khối%';
-- =====================================================================

-- 1. Tạm ẩn môn phổ thông
UPDATE subjects SET hidden = 1 WHERE level IN ('Khối 10', 'Khối 11', 'Khối 12');

-- 2. Thêm môn mới (INSERT IGNORE tránh trùng khi chạy lại nhiều lần)
INSERT INTO subjects (name, level, description, hidden, created_at)
SELECT * FROM (
  -- Nhóm Công nghệ thông tin
  SELECT 'Lập trình C/C++'              AS name, 'Đại học' AS level, 'Nhập môn lập trình, cú pháp C/C++, con trỏ, hàm'      AS description, 0 AS hidden, NOW() AS created_at
  UNION ALL SELECT 'Cấu trúc dữ liệu và giải thuật', 'Đại học', 'Mảng, danh sách, cây, đồ thị, sắp xếp, tìm kiếm', 0, NOW()
  UNION ALL SELECT 'Cơ sở dữ liệu nâng cao',         'Đại học', 'Mô hình quan hệ, SQL, chuẩn hóa, giao dịch',      0, NOW()
  UNION ALL SELECT 'Mạng máy tính',                  'Đại học', 'Mô hình OSI/TCP-IP, định tuyến, giao thức mạng',  0, NOW()
  UNION ALL SELECT 'Hệ điều hành',                   'Đại học', 'Tiến trình, bộ nhớ, hệ thống tập tin, đồng bộ',   0, NOW()
  UNION ALL SELECT 'Lập trình Web nâng cao',         'Đại học', 'HTML/CSS/JS, HTTP, API, framework web',           0, NOW()
  UNION ALL SELECT 'Công nghệ phần mềm',             'Đại học', 'Quy trình phát triển, phân tích thiết kế, kiểm thử', 0, NOW()
  -- Nhóm Kinh tế - Quản trị
  UNION ALL SELECT 'Kinh tế vi mô',                  'Đại học', 'Cung cầu, hành vi người tiêu dùng, cấu trúc thị trường', 0, NOW()
  UNION ALL SELECT 'Kinh tế vĩ mô',                  'Đại học', 'GDP, lạm phát, thất nghiệp, chính sách tài khóa - tiền tệ', 0, NOW()
  UNION ALL SELECT 'Nguyên lý kế toán',              'Đại học', 'Tài khoản, định khoản, báo cáo tài chính',        0, NOW()
  UNION ALL SELECT 'Marketing căn bản',              'Đại học', 'Marketing mix 4P, phân khúc, định vị thị trường', 0, NOW()
  UNION ALL SELECT 'Quản trị học',                   'Đại học', 'Hoạch định, tổ chức, lãnh đạo, kiểm soát',        0, NOW()
) AS m
WHERE NOT EXISTS (SELECT 1 FROM subjects s WHERE s.name = m.name);

-- 3. Kiểm tra kết quả
SELECT level, COUNT(*) AS so_mon, SUM(hidden) AS dang_an FROM subjects GROUP BY level;
