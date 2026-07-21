-- =====================================================================
-- Seed danh sách môn học: Cấp 3 (Khối 10/11/12) + Đại học phổ biến
-- Chạy: mysql -u root quiz_db --default-character-set=utf8mb4 < seed-subjects.sql
-- (qua cmd để giữ UTF-8). Có thể chạy nhiều lần - sẽ bỏ qua môn đã có.
-- =====================================================================
USE quiz_db;

-- Xóa môn test bị lỗi font (nếu có)
DELETE FROM subjects WHERE name = 'Hoa hoc 12';

-- ============== CẤP 3 ==============
-- Khối 10
INSERT INTO subjects (name, level, description) VALUES
('Toán 10', 'Khối 10', 'Môn cấp 3'),
('Ngữ văn 10', 'Khối 10', 'Môn cấp 3'),
('Tiếng Anh 10', 'Khối 10', 'Môn cấp 3'),
('Vật lí 10', 'Khối 10', 'Môn cấp 3'),
('Hóa học 10', 'Khối 10', 'Môn cấp 3'),
('Sinh học 10', 'Khối 10', 'Môn cấp 3'),
('Lịch sử 10', 'Khối 10', 'Môn cấp 3'),
('Địa lí 10', 'Khối 10', 'Môn cấp 3'),
('Giáo dục kinh tế và pháp luật 10', 'Khối 10', 'Môn cấp 3'),
('Tin học 10', 'Khối 10', 'Môn cấp 3'),
('Công nghệ 10', 'Khối 10', 'Môn cấp 3'),
('Giáo dục quốc phòng và an ninh 10', 'Khối 10', 'Môn cấp 3');

-- Khối 11
INSERT INTO subjects (name, level, description) VALUES
('Toán 11', 'Khối 11', 'Môn cấp 3'),
('Ngữ văn 11', 'Khối 11', 'Môn cấp 3'),
('Tiếng Anh 11', 'Khối 11', 'Môn cấp 3'),
('Vật lí 11', 'Khối 11', 'Môn cấp 3'),
('Hóa học 11', 'Khối 11', 'Môn cấp 3'),
('Sinh học 11', 'Khối 11', 'Môn cấp 3'),
('Lịch sử 11', 'Khối 11', 'Môn cấp 3'),
('Địa lí 11', 'Khối 11', 'Môn cấp 3'),
('Giáo dục kinh tế và pháp luật 11', 'Khối 11', 'Môn cấp 3'),
('Tin học 11', 'Khối 11', 'Môn cấp 3'),
('Công nghệ 11', 'Khối 11', 'Môn cấp 3'),
('Giáo dục quốc phòng và an ninh 11', 'Khối 11', 'Môn cấp 3');

-- Khối 12
INSERT INTO subjects (name, level, description) VALUES
('Toán 12', 'Khối 12', 'Môn cấp 3'),
('Ngữ văn 12', 'Khối 12', 'Môn cấp 3'),
('Tiếng Anh 12', 'Khối 12', 'Môn cấp 3'),
('Vật lí 12', 'Khối 12', 'Môn cấp 3'),
('Hóa học 12', 'Khối 12', 'Môn cấp 3'),
('Sinh học 12', 'Khối 12', 'Môn cấp 3'),
('Lịch sử 12', 'Khối 12', 'Môn cấp 3'),
('Địa lí 12', 'Khối 12', 'Môn cấp 3'),
('Giáo dục kinh tế và pháp luật 12', 'Khối 12', 'Môn cấp 3'),
('Tin học 12', 'Khối 12', 'Môn cấp 3'),
('Công nghệ 12', 'Khối 12', 'Môn cấp 3'),
('Giáo dục quốc phòng và an ninh 12', 'Khối 12', 'Môn cấp 3');

-- ============== ĐẠI HỌC (phổ biến) ==============
INSERT INTO subjects (name, level, description) VALUES
('Triết học Mác - Lênin', 'Đại học', 'Môn đại cương'),
('Kinh tế chính trị Mác - Lênin', 'Đại học', 'Môn đại cương'),
('Chủ nghĩa xã hội khoa học', 'Đại học', 'Môn đại cương'),
('Tư tưởng Hồ Chí Minh', 'Đại học', 'Môn đại cương'),
('Lịch sử Đảng Cộng sản Việt Nam', 'Đại học', 'Môn đại cương'),
('Giáo dục quốc phòng và an ninh', 'Đại học', 'Môn đại cương'),
('Pháp luật đại cương', 'Đại học', 'Môn đại cương'),
('Tiếng Anh (Đại học)', 'Đại học', 'Môn đại cương'),
('Tin học đại cương', 'Đại học', 'Môn đại cương'),
('Toán cao cấp', 'Đại học', 'Môn đại cương'),
('Đại số tuyến tính', 'Đại học', 'Môn đại cương'),
('Giải tích', 'Đại học', 'Môn đại cương'),
('Xác suất thống kê', 'Đại học', 'Môn đại cương'),
('Vật lý đại cương', 'Đại học', 'Môn đại cương'),
('Kỹ năng mềm', 'Đại học', 'Môn đại cương');
