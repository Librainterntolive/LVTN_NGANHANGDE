-- Bo sung cau hoi cho 4 hoc phan nhom Ly luan chinh tri.
--
-- Nguon deu la van kien chinh thuc, da tai ve va doc TOAN VAN truoc khi soan cau hoi;
-- khong viet theo tri nho, khong dua tren bai binh luan hay tom tat.
-- Cau hoi bang tieng Viet va nguon cung bang tieng Viet nen translation_status='original'.
--
-- Nguon su dung:
--   Cương lĩnh xây dựng đất nước trong thời kỳ quá độ lên chủ nghĩa xã hội (Bổ sung, phát triển năm 2011) (Đảng Cộng sản Việt Nam — Đại hội đại biểu toàn quốc lần thứ XI) — https://tulieuvankien.dangcongsan.vn/ban-chap-hanh-trung-uong-dang/dai-hoi-dang/lan-thu-xi/cuong-linh-xay-dung-dat-nuoc-trong-thoi-ky-qua-do-len-chu-nghia-xa-hoi-bo-sung-phat-trien-nam-2011-1528
--   Điều lệ Đảng Cộng sản Việt Nam (Đại hội đại biểu toàn quốc lần thứ XI thông qua ngày 19/01/2011) (Đảng Cộng sản Việt Nam) — https://tulieuvankien.dangcongsan.vn/van-kien-tu-lieu-ve-dang/dieu-le-dang/dieu-le-dang-do-dai-hoi-dai-bieu-toan-quoc-lan-thu-xi-cua-dang-thong-qua-3431
--   Di chúc của Chủ tịch Hồ Chí Minh (bản công bố năm 1969) (Trang tin điện tử Hồ Chí Minh — hochiminh.vn) — https://hochiminh.vn/hoc-va-lam-theo-bac/di-chuc/toan-van-di-chuc-cua-chu-tich-ho-chi-minh-cong-bo-nam-1969-109
--
-- Chay: mysql -u root quiz_db --default-character-set=utf8mb4 < 20260818_seed_questions_4_hoc_phan_llct.sql
-- Chay lai nhieu lan van an toan: moi cau chan trung bang content_hash.

START TRANSACTION;

SET @admin := (SELECT id FROM users WHERE role='Admin' AND status='active' ORDER BY id LIMIT 1);

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'Cương lĩnh xây dựng đất nước trong thời kỳ quá độ lên chủ nghĩa xã hội (Bổ sung, phát triển năm 2011)', 'Đảng Cộng sản Việt Nam — Đại hội đại biểu toàn quốc lần thứ XI', 'https://tulieuvankien.dangcongsan.vn/ban-chap-hanh-trung-uong-dang/dai-hoi-dang/lan-thu-xi/cuong-linh-xay-dung-dat-nuoc-trong-thoi-ky-qua-do-len-chu-nghia-xa-hoi-bo-sung-phat-trien-nam-2011-1528', '2011', 'Van kien chinh thuc dang tren Co so du lieu Tu lieu - Van kien cua Dang Cong san Viet Nam; cau hoi trich tu noi dung toan van.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_cl2011 := (SELECT id FROM sources WHERE url = 'https://tulieuvankien.dangcongsan.vn/ban-chap-hanh-trung-uong-dang/dai-hoi-dang/lan-thu-xi/cuong-linh-xay-dung-dat-nuoc-trong-thoi-ky-qua-do-len-chu-nghia-xa-hoi-bo-sung-phat-trien-nam-2011-1528');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'Điều lệ Đảng Cộng sản Việt Nam (Đại hội đại biểu toàn quốc lần thứ XI thông qua ngày 19/01/2011)', 'Đảng Cộng sản Việt Nam', 'https://tulieuvankien.dangcongsan.vn/van-kien-tu-lieu-ve-dang/dieu-le-dang/dieu-le-dang-do-dai-hoi-dai-bieu-toan-quoc-lan-thu-xi-cua-dang-thong-qua-3431', '2011', 'Van kien chinh thuc dang tren Co so du lieu Tu lieu - Van kien cua Dang Cong san Viet Nam; cau hoi trich tu noi dung toan van.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_dieule11 := (SELECT id FROM sources WHERE url = 'https://tulieuvankien.dangcongsan.vn/van-kien-tu-lieu-ve-dang/dieu-le-dang/dieu-le-dang-do-dai-hoi-dai-bieu-toan-quoc-lan-thu-xi-cua-dang-thong-qua-3431');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'Di chúc của Chủ tịch Hồ Chí Minh (bản công bố năm 1969)', 'Trang tin điện tử Hồ Chí Minh — hochiminh.vn', 'https://hochiminh.vn/hoc-va-lam-theo-bac/di-chuc/toan-van-di-chuc-cua-chu-tich-ho-chi-minh-cong-bo-nam-1969-109', '1969', 'Toan van Di chuc cong bo nam 1969, dang tren trang tin dien tu Ho Chi Minh; cau hoi trich tu noi dung toan van.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_dichuc69 := (SELECT id FROM sources WHERE url = 'https://hochiminh.vn/hoc-va-lam-theo-bac/di-chuc/toan-van-di-chuc-cua-chu-tich-ho-chi-minh-cong-bo-nam-1969-109');

-- ===== Hoc phan #44: Chủ nghĩa xã hội khoa học (15 cau) =====
SET @q1 := 'Theo Cương lĩnh 2011, đặc trưng tổng quát đầu tiên của xã hội xã hội chủ nghĩa mà nhân dân ta xây dựng được diễn đạt bằng cụm từ nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 44, @admin, @q1, @q1, 'vi', 'original', NULL, SHA2(LOWER(@q1),256), 'single', 'easy', NOW(3), 'active', @src_cl2011, 'Mục II.2 — tám đặc trưng của xã hội xã hội chủ nghĩa', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q1),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q1),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Công nghiệp hóa, hiện đại hóa, hội nhập quốc tế', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Dân giàu, nước mạnh, dân chủ, công bằng, văn minh', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Độc lập, tự do, hạnh phúc', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Hòa bình, thống nhất, độc lập, dân chủ và giàu mạnh', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q2 := 'Cương lĩnh 2011 nêu đặc trưng về kinh tế của xã hội xã hội chủ nghĩa ở nước ta như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 44, @admin, @q2, @q2, 'vi', 'original', NULL, SHA2(LOWER(@q2),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục II.2 — đặc trưng về kinh tế', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q2),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q2),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Có nền kinh tế thị trường tự do, nhà nước không can thiệp', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Có nền kinh tế dựa hoàn toàn vào sở hữu toàn dân về tư liệu sản xuất', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Có nền kinh tế phát triển cao dựa trên lực lượng sản xuất hiện đại và quan hệ sản xuất tiến bộ phù hợp', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Có nền kinh tế kế hoạch hóa tập trung, thống nhất trong cả nước', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q3 := 'Đặc trưng về văn hóa của xã hội xã hội chủ nghĩa được Cương lĩnh 2011 nêu ra sao?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 44, @admin, @q3, @q3, 'vi', 'original', NULL, SHA2(LOWER(@q3),256), 'single', 'easy', NOW(3), 'active', @src_cl2011, 'Mục II.2 — đặc trưng về văn hóa', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q3),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q3),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Có nền văn hóa hội nhập hoàn toàn với văn hóa thế giới', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Có nền văn hóa thuần túy truyền thống, không tiếp thu bên ngoài', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Có nền văn hóa đại chúng, phổ cập tới mọi tầng lớp', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Có nền văn hóa tiên tiến, đậm đà bản sắc dân tộc', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q4 := 'Theo Cương lĩnh 2011, xã hội xã hội chủ nghĩa mà nhân dân ta xây dựng có nhà nước như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 44, @admin, @q4, @q4, 'vi', 'original', NULL, SHA2(LOWER(@q4),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục II.2 — đặc trưng về nhà nước', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q4),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q4),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Nhà nước pháp quyền xã hội chủ nghĩa của nhân dân, do nhân dân, vì nhân dân do Đảng Cộng sản lãnh đạo', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Nhà nước dân chủ nhân dân do Mặt trận Tổ quốc lãnh đạo', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Nhà nước liên bang gồm nhiều chủ thể tự trị', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Nhà nước quản lý toàn bộ hoạt động kinh tế bằng mệnh lệnh hành chính', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q5 := 'Cương lĩnh 2011 nêu đặc trưng về quan hệ giữa các dân tộc trong cộng đồng Việt Nam như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 44, @admin, @q5, @q5, 'vi', 'original', NULL, SHA2(LOWER(@q5),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục II.2 — đặc trưng về quan hệ dân tộc', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q5),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q5),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Hòa nhập thành một cộng đồng văn hóa duy nhất', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Bình đẳng, đoàn kết, tôn trọng và giúp nhau cùng phát triển', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Ưu tiên tuyệt đối cho các dân tộc thiểu số trong mọi lĩnh vực', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Tự trị về chính trị theo từng vùng dân tộc', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q6 := 'Mục tiêu tổng quát khi kết thúc thời kỳ quá độ ở nước ta được Cương lĩnh 2011 xác định là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 44, @admin, @q6, @q6, 'vi', 'original', NULL, SHA2(LOWER(@q6),256), 'single', 'hard', NOW(3), 'active', @src_cl2011, 'Mục II.2 — mục tiêu tổng quát khi kết thúc thời kỳ quá độ', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q6),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q6),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Xóa bỏ hoàn toàn các thành phần kinh tế ngoài nhà nước', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Hoàn thành xây dựng chủ nghĩa cộng sản trên phạm vi cả nước', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Xây dựng được về cơ bản nền tảng kinh tế của chủ nghĩa xã hội với kiến trúc thượng tầng về chính trị, tư tưởng, văn hóa phù hợp', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Hoàn thành công nghiệp hóa, hiện đại hóa và trở thành nước phát triển có thu nhập cao', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q7 := 'Cương lĩnh 2011 xác định từ nay đến giữa thế kỷ XXI, toàn Đảng, toàn dân ta phải phấn đấu xây dựng nước ta trở thành nước như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 44, @admin, @q7, @q7, 'vi', 'original', NULL, SHA2(LOWER(@q7),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục II.2 — mục tiêu đến giữa thế kỷ XXI', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q7),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q7),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Một nước nông nghiệp công nghệ cao', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Một nước dịch vụ - tài chính khu vực', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Một nước công nghiệp mới, hoàn thành thời kỳ quá độ', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Một nước công nghiệp hiện đại, theo định hướng xã hội chủ nghĩa', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q8 := 'Cương lĩnh 2011 nhận định về thời kỳ quá độ lên chủ nghĩa xã hội ở nước ta như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 44, @admin, @q8, @q8, 'vi', 'original', NULL, SHA2(LOWER(@q8),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục II.2 — tính chất của thời kỳ quá độ', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q8),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q8),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Nhất thiết phải trải qua một thời kỳ quá độ lâu dài với nhiều bước phát triển, nhiều hình thức tổ chức kinh tế, xã hội đan xen', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Có thể rút ngắn thành một giai đoạn ngắn nhờ khoa học công nghệ', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Là một bước chuyển tức thời sau khi giành được chính quyền', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Chỉ kéo dài đến khi hoàn thành cải cách ruộng đất', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q9 := 'Phương hướng cơ bản thứ nhất mà Cương lĩnh 2011 nêu ra là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 44, @admin, @q9, @q9, 'vi', 'original', NULL, SHA2(LOWER(@q9),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục II.2 — phương hướng cơ bản thứ nhất', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q9),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q9),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Xây dựng nền dân chủ xã hội chủ nghĩa', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Đẩy mạnh công nghiệp hóa, hiện đại hóa đất nước gắn với phát triển kinh tế tri thức, bảo vệ tài nguyên, môi trường', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Phát triển nền kinh tế thị trường định hướng xã hội chủ nghĩa', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Xây dựng Đảng trong sạch, vững mạnh', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q10 := 'Phương hướng cơ bản thứ hai trong Cương lĩnh 2011 là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 44, @admin, @q10, @q10, 'vi', 'original', NULL, SHA2(LOWER(@q10),256), 'single', 'easy', NOW(3), 'active', @src_cl2011, 'Mục II.2 — phương hướng cơ bản thứ hai', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q10),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q10),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Thực hiện đường lối đối ngoại độc lập, tự chủ', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Xây dựng nền văn hóa tiên tiến, đậm đà bản sắc dân tộc', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Phát triển nền kinh tế thị trường định hướng xã hội chủ nghĩa', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Bảo đảm vững chắc quốc phòng và an ninh quốc gia', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q11 := 'Phương hướng cơ bản thứ bảy trong Cương lĩnh 2011 nói về việc xây dựng cái gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 44, @admin, @q11, @q11, 'vi', 'original', NULL, SHA2(LOWER(@q11),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục II.2 — phương hướng cơ bản thứ bảy', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q11),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q11),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Xây dựng nền quốc phòng toàn dân', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Xây dựng nền kinh tế tri thức', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Xây dựng mặt trận dân tộc thống nhất', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Xây dựng Nhà nước pháp quyền xã hội chủ nghĩa của nhân dân, do nhân dân, vì nhân dân', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q12 := 'Phương hướng cơ bản cuối cùng (thứ tám) trong Cương lĩnh 2011 là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 44, @admin, @q12, @q12, 'vi', 'original', NULL, SHA2(LOWER(@q12),256), 'single', 'easy', NOW(3), 'active', @src_cl2011, 'Mục II.2 — phương hướng cơ bản thứ tám', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q12),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q12),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Xây dựng Đảng trong sạch, vững mạnh', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Hội nhập quốc tế toàn diện', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Phát triển giáo dục và đào tạo', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Bảo vệ tài nguyên và môi trường', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q13 := 'Cương lĩnh 2011 nêu bao nhiêu phương hướng cơ bản để thực hiện thành công các mục tiêu đã đề ra?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 44, @admin, @q13, @q13, 'vi', 'original', NULL, SHA2(LOWER(@q13),256), 'single', 'easy', NOW(3), 'active', @src_cl2011, 'Mục II.2 — số lượng phương hướng cơ bản', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q13),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q13),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Mười', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Sáu', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Bảy', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Tám', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q14 := 'Trong các mối quan hệ lớn mà Cương lĩnh 2011 yêu cầu nắm vững và giải quyết tốt, mối quan hệ được nêu đầu tiên là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 44, @admin, @q14, @q14, 'vi', 'original', NULL, SHA2(LOWER(@q14),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục II.2 — các mối quan hệ lớn', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q14),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q14),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Quan hệ giữa độc lập, tự chủ và hội nhập quốc tế', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Quan hệ giữa kinh tế thị trường và định hướng xã hội chủ nghĩa', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Quan hệ giữa đổi mới, ổn định và phát triển', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Quan hệ giữa Đảng lãnh đạo, Nhà nước quản lý, nhân dân làm chủ', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q15 := 'Khi giải quyết các mối quan hệ lớn, Cương lĩnh 2011 yêu cầu tránh điều gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 44, @admin, @q15, @q15, 'vi', 'original', NULL, SHA2(LOWER(@q15),256), 'single', 'hard', NOW(3), 'active', @src_cl2011, 'Mục II.2 — yêu cầu khi giải quyết các mối quan hệ lớn', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q15),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=44 AND content_hash=SHA2(LOWER(@q15),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Chậm trễ, thiếu quyết đoán', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Sao chép kinh nghiệm nước ngoài', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Phân cấp quá mức cho địa phương', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Phiến diện, cực đoan, duy ý chí', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

-- ===== Hoc phan #43: Kinh tế chính trị Mác - Lênin (15 cau) =====
SET @q16 := 'Theo Cương lĩnh 2011, nền kinh tế thị trường định hướng xã hội chủ nghĩa ở nước ta được phát triển với những yếu tố nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 43, @admin, @q16, @q16, 'vi', 'original', NULL, SHA2(LOWER(@q16),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục III.1 — đặc trưng của nền kinh tế thị trường định hướng XHCN', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q16),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q16),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Nhiều hình thức sở hữu, nhiều thành phần kinh tế, hình thức tổ chức kinh doanh và hình thức phân phối', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Một hình thức sở hữu toàn dân và một thành phần kinh tế nhà nước duy nhất', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Hai thành phần kinh tế là nhà nước và tập thể', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Chỉ gồm kinh tế tư nhân và kinh tế có vốn đầu tư nước ngoài', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q17 := 'Cương lĩnh 2011 xác định vị trí của các thành phần kinh tế hoạt động theo pháp luật như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 43, @admin, @q17, @q17, 'vi', 'original', NULL, SHA2(LOWER(@q17),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục III.1 — địa vị pháp lý của các thành phần kinh tế', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q17),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q17),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Các thành phần kinh tế được xếp hạng ưu tiên theo quy mô vốn', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Đều là bộ phận hợp thành quan trọng của nền kinh tế, bình đẳng trước pháp luật, cùng phát triển lâu dài, hợp tác và cạnh tranh lành mạnh', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Chỉ kinh tế nhà nước mới là bộ phận hợp thành của nền kinh tế quốc dân', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Các thành phần ngoài nhà nước chỉ được tồn tại tạm thời trong thời kỳ quá độ', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q18 := 'Thành phần kinh tế nào giữ vai trò chủ đạo theo Cương lĩnh 2011?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 43, @admin, @q18, @q18, 'vi', 'original', NULL, SHA2(LOWER(@q18),256), 'single', 'easy', NOW(3), 'active', @src_cl2011, 'Mục III.1 — vai trò chủ đạo', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q18),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q18),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Kinh tế tư nhân', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Kinh tế có vốn đầu tư nước ngoài', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Kinh tế nhà nước', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Kinh tế tập thể', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q19 := 'Theo Cương lĩnh 2011, kinh tế nhà nước cùng với thành phần nào ngày càng trở thành nền tảng vững chắc của nền kinh tế quốc dân?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 43, @admin, @q19, @q19, 'vi', 'original', NULL, SHA2(LOWER(@q19),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục III.1 — nền tảng của nền kinh tế quốc dân', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q19),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q19),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Kinh tế tư nhân', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Kinh tế có vốn đầu tư nước ngoài', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Kinh tế hộ gia đình', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Kinh tế tập thể', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q20 := 'Cương lĩnh 2011 xác định kinh tế tư nhân là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 43, @admin, @q20, @q20, 'vi', 'original', NULL, SHA2(LOWER(@q20),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục III.1 — vị trí của kinh tế tư nhân', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q20),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q20),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Một trong những động lực của nền kinh tế', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Thành phần giữ vai trò chủ đạo', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Thành phần cần thu hẹp dần trong thời kỳ quá độ', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Bộ phận phụ trợ cho kinh tế nhà nước', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q21 := 'Cương lĩnh 2011 xác định thái độ đối với kinh tế có vốn đầu tư nước ngoài như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 43, @admin, @q21, @q21, 'vi', 'original', NULL, SHA2(LOWER(@q21),256), 'single', 'easy', NOW(3), 'active', @src_cl2011, 'Mục III.1 — kinh tế có vốn đầu tư nước ngoài', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q21),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q21),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Chỉ được hoạt động dưới hình thức liên doanh với nhà nước', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Được khuyến khích phát triển', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Chỉ cho phép trong một số ngành đặc thù', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Hạn chế dần và tiến tới xóa bỏ', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q22 := 'Theo Cương lĩnh 2011, chế độ phân phối chủ yếu ở nước ta được thực hiện theo căn cứ nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 43, @admin, @q22, @q22, 'vi', 'original', NULL, SHA2(LOWER(@q22),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục III.1 — chế độ phân phối', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q22),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q22),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Bình quân theo đầu người', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Theo thâm niên công tác', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Theo kết quả lao động, hiệu quả kinh tế', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Theo nhu cầu của từng người', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q23 := 'Ngoài phân phối theo kết quả lao động và hiệu quả kinh tế, Cương lĩnh 2011 còn nêu những hình thức phân phối nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 43, @admin, @q23, @q23, 'vi', 'original', NULL, SHA2(LOWER(@q23),256), 'single', 'hard', NOW(3), 'active', @src_cl2011, 'Mục III.1 — các hình thức phân phối bổ sung', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q23),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q23),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Theo quy mô hộ gia đình và số nhân khẩu', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Theo vùng, miền và địa bàn cư trú', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Theo trình độ học vấn của người lao động', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Theo mức đóng góp vốn cùng các nguồn lực khác và phân phối thông qua hệ thống an sinh xã hội, phúc lợi xã hội', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q24 := 'Cương lĩnh 2011 yêu cầu phân định rõ những quyền nào trong lĩnh vực kinh tế?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 43, @admin, @q24, @q24, 'vi', 'original', NULL, SHA2(LOWER(@q24),256), 'single', 'hard', NOW(3), 'active', @src_cl2011, 'Mục III.1 — phân định quyền trong lĩnh vực kinh tế', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q24),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q24),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Quyền của người sở hữu, quyền của người sử dụng tư liệu sản xuất và quyền quản lý của Nhà nước', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Quyền của người lao động và quyền của người sử dụng lao động', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Quyền của trung ương và quyền của địa phương', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Quyền của doanh nghiệp trong nước và doanh nghiệp nước ngoài', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q25 := 'Nhà nước quản lý, định hướng, điều tiết và thúc đẩy phát triển kinh tế - xã hội bằng những công cụ nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 43, @admin, @q25, @q25, 'vi', 'original', NULL, SHA2(LOWER(@q25),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục III.1 — công cụ quản lý kinh tế của Nhà nước', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q25),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q25),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Chỉ bằng doanh nghiệp nhà nước', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Pháp luật, chiến lược, quy hoạch, kế hoạch, chính sách và lực lượng vật chất', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Mệnh lệnh hành chính và chỉ tiêu pháp lệnh', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Chỉ bằng chính sách thuế và lãi suất', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q26 := 'Cương lĩnh 2011 xác định nhiệm vụ trung tâm là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 43, @admin, @q26, @q26, 'vi', 'original', NULL, SHA2(LOWER(@q26),256), 'single', 'easy', NOW(3), 'active', @src_cl2011, 'Mục III.1 — nhiệm vụ trung tâm', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q26),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q26),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Bảo vệ Tổ quốc', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Phát triển văn hóa', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Phát triển kinh tế', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Xây dựng Đảng', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q27 := 'Theo Cương lĩnh 2011, công nghiệp hóa, hiện đại hóa đất nước phải gắn với những nội dung nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 43, @admin, @q27, @q27, 'vi', 'original', NULL, SHA2(LOWER(@q27),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục III.1 — công nghiệp hóa, hiện đại hóa', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q27),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q27),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Mở rộng xuất khẩu lao động', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tăng nhanh tỷ trọng nông nghiệp trong GDP', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tập trung phát triển công nghiệp nhẹ và tiểu thủ công nghiệp', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Phát triển kinh tế tri thức và bảo vệ tài nguyên, môi trường', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q28 := 'Cương lĩnh 2011 yêu cầu xây dựng cơ cấu kinh tế như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 43, @admin, @q28, @q28, 'vi', 'original', NULL, SHA2(LOWER(@q28),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục III.1 — cơ cấu kinh tế', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q28),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q28),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Hợp lý, hiện đại, có hiệu quả và bền vững, gắn kết chặt chẽ công nghiệp, nông nghiệp, dịch vụ', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Ưu tiên tuyệt đối cho công nghiệp nặng', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Lấy nông nghiệp làm ngành duy nhất then chốt', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Chuyển hẳn sang kinh tế dịch vụ', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q29 := 'Cương lĩnh 2011 nêu quan điểm nào về quan hệ giữa xây dựng nền kinh tế trong nước và hội nhập quốc tế?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 43, @admin, @q29, @q29, 'vi', 'original', NULL, SHA2(LOWER(@q29),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục III.1 — độc lập tự chủ và hội nhập', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q29),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q29),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Chỉ hội nhập trong khuôn khổ khu vực Đông Nam Á', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Xây dựng nền kinh tế độc lập, tự chủ, đồng thời chủ động, tích cực hội nhập kinh tế quốc tế', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Ưu tiên hội nhập trước, xây dựng nội lực sau', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Hạn chế hội nhập để bảo vệ sản xuất trong nước', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q30 := 'Cương lĩnh 2011 yêu cầu các yếu tố thị trường và các loại thị trường được xây dựng, phát triển theo nguyên tắc nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 43, @admin, @q30, @q30, 'vi', 'original', NULL, SHA2(LOWER(@q30),256), 'single', 'hard', NOW(3), 'active', @src_cl2011, 'Mục III.1 — các yếu tố thị trường', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q30),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=43 AND content_hash=SHA2(LOWER(@q30),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Do Nhà nước ấn định giá đối với mọi hàng hóa', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Chỉ phát triển thị trường hàng hóa, chưa phát triển thị trường các yếu tố sản xuất', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Vừa tuân theo quy luật của kinh tế thị trường, vừa bảo đảm tính định hướng xã hội chủ nghĩa', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Hoàn toàn tự phát theo cung cầu', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

-- ===== Hoc phan #45: Tư tưởng Hồ Chí Minh (15 cau) =====
SET @q31 := 'Trong Di chúc, Chủ tịch Hồ Chí Minh căn dặn các đồng chí từ Trung ương đến các chi bộ cần giữ gìn điều gì như giữ gìn con ngươi của mắt mình?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 45, @admin, @q31, @q31, 'vi', 'original', NULL, SHA2(LOWER(@q31),256), 'single', 'medium', NOW(3), 'active', @src_dichuc69, 'Di chúc 1969 — phần nói về Đảng', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dichuc69 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q31),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q31),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Tài sản của Nhà nước', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Bí mật quân sự', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Uy tín của cán bộ lãnh đạo', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Sự đoàn kết nhất trí của Đảng', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q32 := 'Theo Di chúc, cách tốt nhất để củng cố và phát triển sự đoàn kết, thống nhất của Đảng là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 45, @admin, @q32, @q32, 'vi', 'original', NULL, SHA2(LOWER(@q32),256), 'single', 'medium', NOW(3), 'active', @src_dichuc69, 'Di chúc 1969 — phần nói về Đảng', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dichuc69 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q32),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q32),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Trong Đảng thực hành dân chủ rộng rãi, thường xuyên và nghiêm chỉnh tự phê bình và phê bình', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tăng cường kỷ luật và xử lý nghiêm cán bộ vi phạm', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Mở rộng số lượng đảng viên', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Tập trung quyền quyết định vào cấp Trung ương', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q33 := 'Di chúc viết: "Đảng ta là một Đảng cầm quyền". Người yêu cầu mỗi đảng viên và cán bộ phải thực sự thấm nhuần điều gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 45, @admin, @q33, @q33, 'vi', 'original', NULL, SHA2(LOWER(@q33),256), 'single', 'medium', NOW(3), 'active', @src_dichuc69, 'Di chúc 1969 — đạo đức cách mạng', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dichuc69 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q33),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q33),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Ý thức giữ gìn bí mật của tổ chức', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Đạo đức cách mạng, thật sự cần kiệm liêm chính, chí công vô tư', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tinh thần phục tùng tuyệt đối cấp trên', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Kiến thức khoa học kỹ thuật hiện đại', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q34 := 'Trong Di chúc, Chủ tịch Hồ Chí Minh yêu cầu phải giữ gìn Đảng ta thật trong sạch, phải xứng đáng là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 45, @admin, @q34, @q34, 'vi', 'original', NULL, SHA2(LOWER(@q34),256), 'single', 'medium', NOW(3), 'active', @src_dichuc69, 'Di chúc 1969 — quan hệ giữa Đảng và nhân dân', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dichuc69 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q34),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q34),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Là đội quân tiên phong trong sản xuất', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Là tấm gương về học tập lý luận', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Là người lãnh đạo, là người đầy tớ thật trung thành của nhân dân', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Là lực lượng duy nhất nắm quyền lãnh đạo đất nước', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q35 := 'Về đoàn viên thanh niên, Di chúc yêu cầu Đảng phải chăm lo giáo dục đạo đức cách mạng, đào tạo họ thành những người như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 45, @admin, @q35, @q35, 'vi', 'original', NULL, SHA2(LOWER(@q35),256), 'single', 'medium', NOW(3), 'active', @src_dichuc69, 'Di chúc 1969 — đoàn viên thanh niên', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dichuc69 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q35),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q35),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Những người lao động giỏi trong sản xuất nông nghiệp', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Những cán bộ quản lý kinh tế có trình độ đại học', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Những chiến sĩ giỏi trong lực lượng vũ trang', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Những người thừa kế xây dựng chủ nghĩa xã hội vừa "hồng" vừa "chuyên"', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q36 := 'Di chúc khẳng định việc gì là "một việc rất quan trọng và rất cần thiết"?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 45, @admin, @q36, @q36, 'vi', 'original', NULL, SHA2(LOWER(@q36),256), 'single', 'easy', NOW(3), 'active', @src_dichuc69, 'Di chúc 1969 — thế hệ cách mạng cho đời sau', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dichuc69 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q36),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q36),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Bồi dưỡng thế hệ cách mạng cho đời sau', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Xây dựng lực lượng quốc phòng hùng mạnh', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Phát triển công nghiệp nặng', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Mở rộng quan hệ ngoại giao', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q37 := 'Đối với nhân dân lao động, Di chúc yêu cầu Đảng cần phải có kế hoạch thật tốt để làm gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 45, @admin, @q37, @q37, 'vi', 'original', NULL, SHA2(LOWER(@q37),256), 'single', 'medium', NOW(3), 'active', @src_dichuc69, 'Di chúc 1969 — nhân dân lao động', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dichuc69 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q37),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q37),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Phổ cập giáo dục đại học cho toàn dân', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Phát triển kinh tế và văn hóa, nhằm không ngừng nâng cao đời sống của nhân dân', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tổ chức lại toàn bộ hệ thống hợp tác xã', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Đưa nhân dân miền núi về đồng bằng sinh sống', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q38 := 'Trong Di chúc, Chủ tịch Hồ Chí Minh mong Đảng ta góp phần khôi phục khối đoàn kết giữa các đảng anh em trên nền tảng nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 45, @admin, @q38, @q38, 'vi', 'original', NULL, SHA2(LOWER(@q38),256), 'single', 'hard', NOW(3), 'active', @src_dichuc69, 'Di chúc 1969 — phong trào cộng sản thế giới', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dichuc69 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q38),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q38),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Sự thống nhất về mô hình tổ chức đảng', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Cam kết không can thiệp vào công việc nội bộ của nhau', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Chủ nghĩa Mác - Lênin và chủ nghĩa quốc tế vô sản, có lý, có tình', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Lợi ích kinh tế chung giữa các nước xã hội chủ nghĩa', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q39 := 'Về việc riêng, Di chúc căn dặn điều gì sau khi Người qua đời?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 45, @admin, @q39, @q39, 'vi', 'original', NULL, SHA2(LOWER(@q39),256), 'single', 'medium', NOW(3), 'active', @src_dichuc69, 'Di chúc 1969 — phần về việc riêng', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dichuc69 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q39),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q39),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Tổ chức quốc tang trong bảy ngày trên cả nước', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Xây dựng một công trình tưởng niệm tại quê nhà', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Dành toàn bộ tài sản cá nhân cho quỹ khuyến học', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Chớ nên tổ chức điếu phúng linh đình, để khỏi lãng phí thì giờ và tiền bạc của nhân dân', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q40 := 'Điều mong muốn cuối cùng của Chủ tịch Hồ Chí Minh trong Di chúc là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 45, @admin, @q40, @q40, 'vi', 'original', NULL, SHA2(LOWER(@q40),256), 'single', 'hard', NOW(3), 'active', @src_dichuc69, 'Di chúc 1969 — điều mong muốn cuối cùng', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dichuc69 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q40),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q40),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Toàn Đảng, toàn dân ta đoàn kết phấn đấu, xây dựng một nước Việt Nam hòa bình, thống nhất, độc lập, dân chủ và giàu mạnh, và góp phần xứng đáng vào sự nghiệp cách mạng thế giới', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Hoàn thành công cuộc công nghiệp hóa trong vòng hai mươi năm', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Xây dựng thành công chủ nghĩa cộng sản ở miền Bắc', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Giữ vững quan hệ hữu nghị với tất cả các nước láng giềng', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q41 := 'Bản Di chúc của Chủ tịch Hồ Chí Minh được công bố năm 1969 đề ngày tháng nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 45, @admin, @q41, @q41, 'vi', 'original', NULL, SHA2(LOWER(@q41),256), 'single', 'easy', NOW(3), 'active', @src_dichuc69, 'Di chúc 1969 — thời điểm viết', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dichuc69 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q41),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q41),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Ngày 3 tháng 9 năm 1969', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Ngày 10 tháng 5 năm 1969', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Ngày 2 tháng 9 năm 1969', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Ngày 19 tháng 5 năm 1969', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q42 := 'Di chúc khẳng định điều gì là "một truyền thống cực kỳ quý báu của Đảng và của dân ta"?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 45, @admin, @q42, @q42, 'vi', 'original', NULL, SHA2(LOWER(@q42),256), 'single', 'easy', NOW(3), 'active', @src_dichuc69, 'Di chúc 1969 — truyền thống của Đảng và của dân ta', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dichuc69 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q42),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q42),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Yêu nước', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Hiếu học', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Đoàn kết', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Cần cù lao động', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q43 := 'Theo Điều lệ Đảng, Đảng Cộng sản Việt Nam lấy gì làm nền tảng tư tưởng, kim chỉ nam cho hành động?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 45, @admin, @q43, @q43, 'vi', 'original', NULL, SHA2(LOWER(@q43),256), 'single', 'easy', NOW(3), 'active', @src_dieule11, 'Điều lệ Đảng XI — phần Đảng và những vấn đề cơ bản về xây dựng Đảng', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dieule11 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q43),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q43),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Chủ nghĩa Mác - Lênin', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tư tưởng Hồ Chí Minh và truyền thống dân tộc', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Cương lĩnh chính trị và Điều lệ Đảng', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Chủ nghĩa Mác - Lênin và tư tưởng Hồ Chí Minh', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q44 := 'Theo bài học kinh nghiệm thứ nhất trong Cương lĩnh 2011, quan hệ giữa độc lập dân tộc và chủ nghĩa xã hội được xác định như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 45, @admin, @q44, @q44, 'vi', 'original', NULL, SHA2(LOWER(@q44),256), 'single', 'hard', NOW(3), 'active', @src_cl2011, 'Mục I.2 — bài học thứ nhất', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q44),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q44),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Độc lập dân tộc là điều kiện tiên quyết để thực hiện chủ nghĩa xã hội và chủ nghĩa xã hội là cơ sở bảo đảm vững chắc cho độc lập dân tộc', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Chủ nghĩa xã hội phải được xây dựng xong trước rồi mới giành độc lập dân tộc', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Hai nhiệm vụ này độc lập với nhau, không có quan hệ trực tiếp', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Độc lập dân tộc là mục tiêu duy nhất, chủ nghĩa xã hội chỉ là phương tiện', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q45 := 'Cương lĩnh 2011 dẫn lại tổng kết của Chủ tịch Hồ Chí Minh về đoàn kết như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 45, @admin, @q45, @q45, 'vi', 'original', NULL, SHA2(LOWER(@q45),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục I.2 — bài học thứ ba, tổng kết của Hồ Chí Minh về đoàn kết', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q45),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=45 AND content_hash=SHA2(LOWER(@q45),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Không có gì quý hơn độc lập, tự do', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Đoàn kết, đoàn kết, đại đoàn kết - Thành công, thành công, đại thành công', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Đoàn kết là sức mạnh, đoàn kết là thắng lợi', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Đoàn kết toàn dân, phụng sự Tổ quốc', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

-- ===== Hoc phan #46: Lịch sử Đảng Cộng sản Việt Nam (15 cau) =====
SET @q46 := 'Điều lệ Đảng Cộng sản Việt Nam hiện hành được Đại hội đại biểu toàn quốc lần thứ XI thông qua vào ngày nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 46, @admin, @q46, @q46, 'vi', 'original', NULL, SHA2(LOWER(@q46),256), 'single', 'easy', NOW(3), 'active', @src_dieule11, 'Điều lệ Đảng XI — thời điểm thông qua', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dieule11 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q46),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q46),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Ngày 19 tháng 5 năm 2011', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Ngày 02 tháng 9 năm 2011', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Ngày 19 tháng 01 năm 2011', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Ngày 03 tháng 02 năm 2011', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q47 := 'Theo Điều lệ Đảng, Đảng Cộng sản Việt Nam là đội tiên phong của lực lượng nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 46, @admin, @q47, @q47, 'vi', 'original', NULL, SHA2(LOWER(@q47),256), 'single', 'medium', NOW(3), 'active', @src_dieule11, 'Điều lệ Đảng XI — bản chất của Đảng', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dieule11 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q47),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q47),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Chỉ của giai cấp công nhân', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Của giai cấp nông dân và giai cấp công nhân', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Của đội ngũ trí thức và giai cấp công nhân', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Của giai cấp công nhân, đồng thời là đội tiên phong của nhân dân lao động và của dân tộc Việt Nam', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q48 := 'Điều lệ Đảng xác định mục đích của Đảng là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 46, @admin, @q48, @q48, 'vi', 'original', NULL, SHA2(LOWER(@q48),256), 'single', 'hard', NOW(3), 'active', @src_dieule11, 'Điều lệ Đảng XI — mục đích của Đảng', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dieule11 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q48),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q48),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Xây dựng nước Việt Nam độc lập, dân chủ, giàu mạnh, xã hội công bằng, văn minh, không còn người bóc lột người, thực hiện thành công chủ nghĩa xã hội và cuối cùng là chủ nghĩa cộng sản', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Xây dựng nước Việt Nam trở thành nước công nghiệp hiện đại vào giữa thế kỷ XXI', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Giành và giữ vững chính quyền cách mạng trong cả nước', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Bảo vệ vững chắc độc lập, chủ quyền và toàn vẹn lãnh thổ', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q49 := 'Đảng Cộng sản Việt Nam lấy nguyên tắc nào làm nguyên tắc tổ chức cơ bản?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 46, @admin, @q49, @q49, 'vi', 'original', NULL, SHA2(LOWER(@q49),256), 'single', 'easy', NOW(3), 'active', @src_dieule11, 'Điều lệ Đảng XI — nguyên tắc tổ chức', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dieule11 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q49),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q49),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Đoàn kết thống nhất', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tập trung dân chủ', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tập thể lãnh đạo tuyệt đối', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Tự phê bình và phê bình', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q50 := 'Theo Điều 9 Điều lệ Đảng, cơ quan lãnh đạo cao nhất của Đảng là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 46, @admin, @q50, @q50, 'vi', 'original', NULL, SHA2(LOWER(@q50),256), 'single', 'medium', NOW(3), 'active', @src_dieule11, 'Điều lệ Đảng XI — Điều 9, cơ quan lãnh đạo cao nhất', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dieule11 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q50),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q50),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Bộ Chính trị', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Ban Bí thư', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Đại hội đại biểu toàn quốc', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Ban Chấp hành Trung ương', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q51 := 'Giữa hai kỳ đại hội, cơ quan lãnh đạo của Đảng là cơ quan nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 46, @admin, @q51, @q51, 'vi', 'original', NULL, SHA2(LOWER(@q51),256), 'single', 'medium', NOW(3), 'active', @src_dieule11, 'Điều lệ Đảng XI — Điều 9, giữa hai kỳ đại hội', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dieule11 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q51),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q51),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Bộ Chính trị', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Ban Bí thư', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Ủy ban Kiểm tra Trung ương', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Ban Chấp hành Trung ương', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q52 := 'Theo Điều lệ Đảng, nghị quyết của các cơ quan lãnh đạo của Đảng chỉ có giá trị thi hành khi nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 46, @admin, @q52, @q52, 'vi', 'original', NULL, SHA2(LOWER(@q52),256), 'single', 'hard', NOW(3), 'active', @src_dieule11, 'Điều lệ Đảng XI — Điều 9, hiệu lực của nghị quyết', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dieule11 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q52),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q52),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Khi có hơn một nửa số thành viên trong cơ quan đó tán thành', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Khi có hai phần ba số thành viên tán thành', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Khi được cấp ủy cấp trên phê duyệt', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Khi toàn thể thành viên nhất trí', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q53 := 'Theo Điều 1 Điều lệ Đảng, công dân Việt Nam từ bao nhiêu tuổi trở lên mới có thể được xét để kết nạp vào Đảng?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 46, @admin, @q53, @q53, 'vi', 'original', NULL, SHA2(LOWER(@q53),256), 'single', 'easy', NOW(3), 'active', @src_dieule11, 'Điều lệ Đảng XI — Điều 1, điều kiện xét kết nạp', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dieule11 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q53),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q53),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Hai mươi mốt tuổi', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Mười tám tuổi', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Hai mươi tuổi', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Mười sáu tuổi', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q54 := 'Đảng viên có ý kiến thuộc về thiểu số thì Điều lệ Đảng quy định thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 46, @admin, @q54, @q54, 'vi', 'original', NULL, SHA2(LOWER(@q54),256), 'single', 'hard', NOW(3), 'active', @src_dieule11, 'Điều lệ Đảng XI — Điều 9, ý kiến thuộc về thiểu số', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dieule11 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q54),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q54),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Được quyền không thi hành nghị quyết đó', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Được quyền công bố ý kiến của mình trên các phương tiện thông tin đại chúng', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Được quyền bảo lưu và báo cáo lên cấp ủy cấp trên cho đến Đại hội đại biểu toàn quốc, song phải chấp hành nghiêm chỉnh nghị quyết, không được truyền bá ý kiến trái với nghị quyết của Đảng', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Phải từ bỏ ý kiến của mình ngay sau khi biểu quyết', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q55 := 'Theo Cương lĩnh 2011, thắng lợi của Cách mạng Tháng Tám năm 1945 đã lập nên nhà nước nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 46, @admin, @q55, @q55, 'vi', 'original', NULL, SHA2(LOWER(@q55),256), 'single', 'easy', NOW(3), 'active', @src_cl2011, 'Mục I.1 — thắng lợi của Cách mạng Tháng Tám', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q55),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q55),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Nước Cộng hòa xã hội chủ nghĩa Việt Nam', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Chính phủ Cách mạng lâm thời Cộng hòa miền Nam Việt Nam', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Nhà nước Việt Nam Cộng hòa', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Nước Việt Nam Dân chủ Cộng hòa', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q56 := 'Cương lĩnh 2011 nêu đỉnh cao của thắng lợi trong các cuộc kháng chiến chống xâm lược là những sự kiện nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 46, @admin, @q56, @q56, 'vi', 'original', NULL, SHA2(LOWER(@q56),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục I.1 — đỉnh cao của các cuộc kháng chiến chống xâm lược', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q56),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q56),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Chiến thắng lịch sử Điện Biên Phủ năm 1954 và đại thắng mùa Xuân năm 1975', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Chiến thắng Bạch Đằng và chiến thắng Đống Đa', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Chiến thắng Điện Biên Phủ trên không năm 1972 và Hiệp định Paris 1973', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Cách mạng Tháng Tám 1945 và Chiến dịch Biên giới 1950', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q57 := 'Bài học kinh nghiệm thứ hai mà Cương lĩnh 2011 rút ra là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 46, @admin, @q57, @q57, 'vi', 'original', NULL, SHA2(LOWER(@q57),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục I.2 — bài học thứ hai', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q57),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q57),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Sự lãnh đạo đúng đắn của Đảng là nhân tố hàng đầu quyết định thắng lợi', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Sự nghiệp cách mạng là của nhân dân, do nhân dân và vì nhân dân', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Nắm vững ngọn cờ độc lập dân tộc và chủ nghĩa xã hội', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Không ngừng củng cố, tăng cường đoàn kết', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q58 := 'Bài học thứ ba trong Cương lĩnh 2011 nói về việc không ngừng củng cố, tăng cường những loại đoàn kết nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 46, @admin, @q58, @q58, 'vi', 'original', NULL, SHA2(LOWER(@q58),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục I.2 — bài học thứ ba', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q58),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q58),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Đoàn kết giữa các cấp ủy từ Trung ương đến cơ sở', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Đoàn kết giữa các nước xã hội chủ nghĩa', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Đoàn kết toàn Đảng, đoàn kết toàn dân, đoàn kết dân tộc, đoàn kết quốc tế', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Đoàn kết trong Đảng và đoàn kết trong lực lượng vũ trang', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q59 := 'Bài học thứ tư trong Cương lĩnh 2011 nêu yêu cầu kết hợp những sức mạnh nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 46, @admin, @q59, @q59, 'vi', 'original', NULL, SHA2(LOWER(@q59),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục I.2 — bài học thứ tư', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q59),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q59),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Sức mạnh quân sự với sức mạnh kinh tế', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Sức mạnh của Đảng với sức mạnh của Nhà nước', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Sức mạnh vật chất với sức mạnh tinh thần', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Sức mạnh dân tộc với sức mạnh thời đại, sức mạnh trong nước với sức mạnh quốc tế', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q60 := 'Bài học thứ năm trong Cương lĩnh 2011 khẳng định nhân tố hàng đầu quyết định thắng lợi của cách mạng Việt Nam là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 46, @admin, @q60, @q60, 'vi', 'original', NULL, SHA2(LOWER(@q60),256), 'single', 'medium', NOW(3), 'active', @src_cl2011, 'Mục I.2 — bài học thứ năm', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cl2011 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q60),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=46 AND content_hash=SHA2(LOWER(@q60),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Sự lãnh đạo đúng đắn của Đảng', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Sự ủng hộ của bạn bè quốc tế', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tinh thần yêu nước của nhân dân', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Sức mạnh của lực lượng vũ trang nhân dân', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

COMMIT;
