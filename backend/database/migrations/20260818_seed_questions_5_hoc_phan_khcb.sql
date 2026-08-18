-- Bo sung cau hoi cho 5 hoc phan nhom CNTT + Khoa hoc co ban.
--
-- Moi cau hoi deu bam sat noi dung tai lieu goc da doc that qua WebFetch,
-- khong viet theo tri nho. Cau hoi hien thi bang tieng Viet, giu nguyen thuat ngu
-- va ky hieu theo nguyen ban; ban tieng Anh luu vao content_original de doi chieu.
--
-- Nguon su dung (tai lieu tham chieu chinh thuc cua co quan chuan/nha phat hanh, truy cap cong khai):
--   Python 3 Documentation — Data Structures (Python Software Foundation) — https://docs.python.org/3/tutorial/datastructures.html
--   Python 3 Documentation — Sorting Techniques (Sorting HOW TO) (Python Software Foundation) — https://docs.python.org/3/howto/sorting.html
--   Java SE 21 API Specification — java.util.HashMap (Oracle Corporation) — https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/HashMap.html
--   Java SE 21 API Specification — java.util.TreeMap (Oracle Corporation) — https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/TreeMap.html
--   NIST/SEMATECH e-Handbook of Statistical Methods — 1.3.5.11 Measures of Skewness and Kurtosis (National Institute of Standards and Technology (NIST)) — https://www.itl.nist.gov/div898/handbook/eda/section3/eda35b.htm
--   NIST/SEMATECH e-Handbook of Statistical Methods — 7.1.3 Hypothesis Testing (National Institute of Standards and Technology (NIST)) — https://www.itl.nist.gov/div898/handbook/prc/section1/prc13.htm
--   NIST/SEMATECH e-Handbook of Statistical Methods — 1.3.6.6.1 Normal Distribution (National Institute of Standards and Technology (NIST)) — https://www.itl.nist.gov/div898/handbook/eda/section3/eda3661.htm
--   NIST/SEMATECH e-Handbook of Statistical Methods — 1.3.6.6.4 t Distribution (National Institute of Standards and Technology (NIST)) — https://www.itl.nist.gov/div898/handbook/eda/section3/eda3664.htm
--   NIST Digital Library of Mathematical Functions — §1.2 Elementary Algebra (National Institute of Standards and Technology (NIST)) — https://dlmf.nist.gov/1.2
--   NIST Digital Library of Mathematical Functions — §1.4 Calculus of One Variable (National Institute of Standards and Technology (NIST)) — https://dlmf.nist.gov/1.4
--   NIST Digital Library of Mathematical Functions — §1.5 Calculus of Two or More Variables (National Institute of Standards and Technology (NIST)) — https://dlmf.nist.gov/1.5
--   LAPACK Users' Guide (Third Edition) — Symmetric Eigenproblems (Netlib / SIAM) — https://www.netlib.org/lapack/lug/node30.html
--   NIST — SI Redefinition: Meet the Constants (National Institute of Standards and Technology (NIST)) — https://www.nist.gov/si-redefinition/meet-constants
--   NIST — Metric (SI) Prefixes (National Institute of Standards and Technology (NIST)) — https://www.nist.gov/pml/owm/metric-si-prefixes
--   BIPM — Measurement units (SI base units and defining constants) (Bureau International des Poids et Mesures (BIPM)) — https://www.bipm.org/en/measurement-units
--
-- Chay: mysql -u root quiz_db --default-character-set=utf8mb4 < 20260818_seed_questions_5_hoc_phan_khcb.sql
-- Chay lai nhieu lan van an toan: moi cau chan trung bang content_hash.

START TRANSACTION;

SET @admin := (SELECT id FROM users WHERE role='Admin' AND status='active' ORDER BY id LIMIT 1);

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'Python 3 Documentation — Data Structures', 'Python Software Foundation', 'https://docs.python.org/3/tutorial/datastructures.html', '', 'Tai lieu chinh thuc cua ngon ngu Python; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_py_ds := (SELECT id FROM sources WHERE url = 'https://docs.python.org/3/tutorial/datastructures.html');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'Python 3 Documentation — Sorting Techniques (Sorting HOW TO)', 'Python Software Foundation', 'https://docs.python.org/3/howto/sorting.html', '', 'Tai lieu chinh thuc cua ngon ngu Python; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_py_sort := (SELECT id FROM sources WHERE url = 'https://docs.python.org/3/howto/sorting.html');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'Java SE 21 API Specification — java.util.HashMap', 'Oracle Corporation', 'https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/HashMap.html', '', 'Dac ta API chinh thuc cua Java SE; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_java_hashmap := (SELECT id FROM sources WHERE url = 'https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/HashMap.html');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'Java SE 21 API Specification — java.util.TreeMap', 'Oracle Corporation', 'https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/TreeMap.html', '', 'Dac ta API chinh thuc cua Java SE; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_java_treemap := (SELECT id FROM sources WHERE url = 'https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/TreeMap.html');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'NIST/SEMATECH e-Handbook of Statistical Methods — 1.3.5.11 Measures of Skewness and Kurtosis', 'National Institute of Standards and Technology (NIST)', 'https://www.itl.nist.gov/div898/handbook/eda/section3/eda35b.htm', '', 'So tay thong ke chinh thuc cua NIST (Hoa Ky); cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_nist_skew := (SELECT id FROM sources WHERE url = 'https://www.itl.nist.gov/div898/handbook/eda/section3/eda35b.htm');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'NIST/SEMATECH e-Handbook of Statistical Methods — 7.1.3 Hypothesis Testing', 'National Institute of Standards and Technology (NIST)', 'https://www.itl.nist.gov/div898/handbook/prc/section1/prc13.htm', '', 'So tay thong ke chinh thuc cua NIST (Hoa Ky); cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_nist_hyp := (SELECT id FROM sources WHERE url = 'https://www.itl.nist.gov/div898/handbook/prc/section1/prc13.htm');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'NIST/SEMATECH e-Handbook of Statistical Methods — 1.3.6.6.1 Normal Distribution', 'National Institute of Standards and Technology (NIST)', 'https://www.itl.nist.gov/div898/handbook/eda/section3/eda3661.htm', '', 'So tay thong ke chinh thuc cua NIST (Hoa Ky); cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_nist_norm := (SELECT id FROM sources WHERE url = 'https://www.itl.nist.gov/div898/handbook/eda/section3/eda3661.htm');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'NIST/SEMATECH e-Handbook of Statistical Methods — 1.3.6.6.4 t Distribution', 'National Institute of Standards and Technology (NIST)', 'https://www.itl.nist.gov/div898/handbook/eda/section3/eda3664.htm', '', 'So tay thong ke chinh thuc cua NIST (Hoa Ky); cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_nist_t := (SELECT id FROM sources WHERE url = 'https://www.itl.nist.gov/div898/handbook/eda/section3/eda3664.htm');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'NIST Digital Library of Mathematical Functions — §1.2 Elementary Algebra', 'National Institute of Standards and Technology (NIST)', 'https://dlmf.nist.gov/1.2', '', 'Thu vien so ve ham toan hoc cua NIST, ke thua Abramowitz & Stegun; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_dlmf12 := (SELECT id FROM sources WHERE url = 'https://dlmf.nist.gov/1.2');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'NIST Digital Library of Mathematical Functions — §1.4 Calculus of One Variable', 'National Institute of Standards and Technology (NIST)', 'https://dlmf.nist.gov/1.4', '', 'Thu vien so ve ham toan hoc cua NIST, ke thua Abramowitz & Stegun; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_dlmf14 := (SELECT id FROM sources WHERE url = 'https://dlmf.nist.gov/1.4');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'NIST Digital Library of Mathematical Functions — §1.5 Calculus of Two or More Variables', 'National Institute of Standards and Technology (NIST)', 'https://dlmf.nist.gov/1.5', '', 'Thu vien so ve ham toan hoc cua NIST, ke thua Abramowitz & Stegun; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_dlmf15 := (SELECT id FROM sources WHERE url = 'https://dlmf.nist.gov/1.5');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'LAPACK Users'' Guide (Third Edition) — Symmetric Eigenproblems', 'Netlib / SIAM', 'https://www.netlib.org/lapack/lug/node30.html', '', 'Tai lieu chinh thuc cua thu vien dai so tuyen tinh LAPACK; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_lapack_sep := (SELECT id FROM sources WHERE url = 'https://www.netlib.org/lapack/lug/node30.html');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'NIST — SI Redefinition: Meet the Constants', 'National Institute of Standards and Technology (NIST)', 'https://www.nist.gov/si-redefinition/meet-constants', '', 'Trang chinh thuc cua NIST ve 7 hang so dinh nghia SI; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_nist_si := (SELECT id FROM sources WHERE url = 'https://www.nist.gov/si-redefinition/meet-constants');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'NIST — Metric (SI) Prefixes', 'National Institute of Standards and Technology (NIST)', 'https://www.nist.gov/pml/owm/metric-si-prefixes', '', 'Bang tien to SI chinh thuc do NIST cong bo; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_nist_prefix := (SELECT id FROM sources WHERE url = 'https://www.nist.gov/pml/owm/metric-si-prefixes');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'BIPM — Measurement units (SI base units and defining constants)', 'Bureau International des Poids et Mesures (BIPM)', 'https://www.bipm.org/en/measurement-units', '', 'Co quan can do quoc te giu chuan SI; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_bipm_units := (SELECT id FROM sources WHERE url = 'https://www.bipm.org/en/measurement-units');

-- ===== Hoc phan #60: Cấu trúc dữ liệu và giải thuật (15 cau) =====
SET @q1 := 'Trong Python, lời gọi a.append(x) tương đương với phép gán lát cắt nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 60, @admin, @q1, 'In Python, list.append(x) is equivalent to which slice assignment?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://docs.python.org/3/tutorial/datastructures.html', SHA2(LOWER(@q1),256), 'single', 'easy', NOW(3), 'active', @src_py_ds, 'Data Structures — 5.1 More on Lists, list.append()', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_py_ds IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q1),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q1),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'a[len(a)-1:] = [x]', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'a[len(a):] = [x]', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'a[:0] = [x]', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'a[:] = [x]', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q2 := 'Khi gọi a.pop() mà không truyền chỉ số, Python làm gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 60, @admin, @q2, 'What does a.pop() do when no index is specified?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://docs.python.org/3/tutorial/datastructures.html', SHA2(LOWER(@q2),256), 'single', 'easy', NOW(3), 'active', @src_py_ds, 'Data Structures — 5.1 More on Lists, list.pop()', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_py_ds IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q2),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q2),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Xóa toàn bộ phần tử của danh sách', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Trả về phần tử cuối nhưng không xóa khỏi danh sách', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Xóa và trả về phần tử cuối cùng của danh sách', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Xóa và trả về phần tử đầu tiên của danh sách', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q3 := 'Gọi a.pop() trên một danh sách rỗng sẽ ném ra ngoại lệ nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 60, @admin, @q3, 'Which exception does a.pop() raise when the list is empty?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://docs.python.org/3/tutorial/datastructures.html', SHA2(LOWER(@q3),256), 'single', 'easy', NOW(3), 'active', @src_py_ds, 'Data Structures — 5.1 More on Lists, list.pop()', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_py_ds IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q3),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q3),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'KeyError', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'IndexError', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'TypeError', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'ValueError', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q4 := 'Theo tài liệu Python, vì sao dùng list làm queue lại không hiệu quả?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 60, @admin, @q4, 'According to the Python documentation, why are lists inefficient when used as queues?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://docs.python.org/3/tutorial/datastructures.html', SHA2(LOWER(@q4),256), 'single', 'medium', NOW(3), 'active', @src_py_ds, 'Data Structures — 5.1.2 Using Lists as Queues', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_py_ds IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q4),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q4),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Vì list không cho phép chèn phần tử vào đầu', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Vì chèn hoặc lấy phần tử ở đầu danh sách chậm, do mọi phần tử còn lại phải dịch đi một vị trí', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Vì list phải cấp phát lại bộ nhớ sau mỗi lần append', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Vì list không giữ được thứ tự phần tử theo thời gian thêm vào', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q5 := 'Tài liệu Python khuyến nghị dùng cấu trúc nào để cài đặt queue?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 60, @admin, @q5, 'Which data structure does the Python documentation recommend for implementing a queue?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://docs.python.org/3/tutorial/datastructures.html', SHA2(LOWER(@q5),256), 'single', 'easy', NOW(3), 'active', @src_py_ds, 'Data Structures — 5.1.2 Using Lists as Queues', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_py_ds IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q5),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q5),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'collections.OrderedDict', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'array.array', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'collections.deque', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'queue.PriorityQueue', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q6 := 'Khác biệt cơ bản giữa sorted() và list.sort() trong Python là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 60, @admin, @q6, 'What is the basic difference between sorted() and list.sort() in Python?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://docs.python.org/3/howto/sorting.html', SHA2(LOWER(@q6),256), 'single', 'medium', NOW(3), 'active', @src_py_sort, 'Sorting HOW TO — Sorting Basics', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_py_sort IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q6),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q6),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Cả hai đều trả về danh sách mới, chỉ khác tên gọi', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'list.sort() không hỗ trợ tham số key, còn sorted() thì có', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'list.sort() sắp xếp tại chỗ và chỉ dùng cho list, còn sorted() trả về danh sách mới và nhận mọi iterable', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'sorted() sắp xếp tại chỗ, còn list.sort() trả về danh sách mới', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q7 := 'Phương thức list.sort() trả về giá trị gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 60, @admin, @q7, 'What value does the list.sort() method return?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://docs.python.org/3/howto/sorting.html', SHA2(LOWER(@q7),256), 'single', 'easy', NOW(3), 'active', @src_py_sort, 'Sorting HOW TO — Sorting Basics', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_py_sort IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q7),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q7),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'None', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Số phần tử đã đổi chỗ', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Bản sao của danh sách gốc', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Danh sách đã sắp xếp', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q8 := 'Tham số key trong sorted() và list.sort() có tác dụng gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 60, @admin, @q8, 'What is the purpose of the key parameter in sorted() and list.sort()?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://docs.python.org/3/howto/sorting.html', SHA2(LOWER(@q8),256), 'single', 'easy', NOW(3), 'active', @src_py_sort, 'Sorting HOW TO — Key Functions', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_py_sort IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q8),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q8),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Chỉ định hàm được gọi trên mỗi phần tử trước khi đem so sánh', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Chỉ định khóa chính của bảng dữ liệu cần sắp xếp', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Chỉ định số phần tử tối đa được sắp xếp', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Chỉ định thuật toán sắp xếp sẽ được dùng', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q9 := 'Thuật toán sắp xếp của Python được bảo đảm là ổn định (stable). Điều đó nghĩa là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 60, @admin, @q9, 'Python''s sorts are guaranteed to be stable. What does that mean?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://docs.python.org/3/howto/sorting.html', SHA2(LOWER(@q9),256), 'single', 'medium', NOW(3), 'active', @src_py_sort, 'Sorting HOW TO — Sort Stability and Complex Sorts', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_py_sort IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q9),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q9),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Bộ nhớ sử dụng không tăng theo kích thước danh sách', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Thời gian chạy luôn ổn định bất kể dữ liệu đầu vào', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Kết quả sắp xếp không phụ thuộc vào tham số reverse', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Khi nhiều bản ghi có cùng khóa sắp xếp, thứ tự gốc giữa chúng được giữ nguyên', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q10 := 'Để sắp xếp theo grade giảm dần rồi đến age tăng dần, tài liệu Python tận dụng tính chất nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 60, @admin, @q10, 'To sort by grade descending then age ascending, which property does the Python documentation exploit?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://docs.python.org/3/howto/sorting.html', SHA2(LOWER(@q10),256), 'single', 'hard', NOW(3), 'active', @src_py_sort, 'Sorting HOW TO — Sort Stability and Complex Sorts', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_py_sort IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q10),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q10),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Hàm sorted() tự động sắp xếp theo nhiều khóa khi truyền tuple', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Phải tự cài đặt hàm so sánh cmp cho từng cặp phần tử', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tính ổn định: sắp theo khóa phụ trước, rồi sắp lại theo khóa chính', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Tham số reverse có thể nhận danh sách giá trị cho từng khóa', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q11 := 'Tài liệu Java SE khẳng định HashMap đạt hiệu năng nào cho get và put?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 60, @admin, @q11, 'What performance does the Java SE documentation state HashMap provides for get and put?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/HashMap.html', SHA2(LOWER(@q11),256), 'single', 'medium', NOW(3), 'active', @src_java_hashmap, 'java.util.HashMap — mô tả lớp', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_java_hashmap IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q11),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q11),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Thời gian log(n) trong mọi trường hợp', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Thời gian tuyến tính theo số phần tử', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Thời gian hằng số được bảo đảm tuyệt đối, không kèm điều kiện nào', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Thời gian hằng số (constant-time), với giả thiết hàm băm phân tán đều các phần tử vào các bucket', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q12 := 'Giá trị load factor mặc định của HashMap trong Java là bao nhiêu?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 60, @admin, @q12, 'What is the default load factor of Java''s HashMap?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/HashMap.html', SHA2(LOWER(@q12),256), 'single', 'easy', NOW(3), 'active', @src_java_hashmap, 'java.util.HashMap — load factor', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_java_hashmap IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q12),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q12),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', '0.5', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', '0.75', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', '0.9', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', '1.0', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q13 := 'Iterator của HashMap là fail-fast: nếu map bị sửa đổi cấu trúc sau khi tạo iterator (trừ qua remove của chính iterator) thì điều gì xảy ra?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 60, @admin, @q13, 'HashMap iterators are fail-fast: what happens if the map is structurally modified after the iterator is created, except through the iterator''s own remove method?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/HashMap.html', SHA2(LOWER(@q13),256), 'single', 'medium', NOW(3), 'active', @src_java_hashmap, 'java.util.HashMap — iterator fail-fast', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_java_hashmap IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q13),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q13),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Iterator trả về null cho phần tử kế tiếp', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Iterator bỏ qua phần tử vừa thay đổi và chạy tiếp', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Iterator ném ConcurrentModificationException', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Iterator tự khởi động lại từ đầu', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q14 := 'TreeMap trong Java được cài đặt dựa trên cấu trúc dữ liệu nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 60, @admin, @q14, 'Which data structure is Java''s TreeMap based on?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/TreeMap.html', SHA2(LOWER(@q14),256), 'single', 'easy', NOW(3), 'active', @src_java_treemap, 'java.util.TreeMap — mô tả lớp', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_java_treemap IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q14),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q14),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Cây B+', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Danh sách bỏ qua (skip list)', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Bảng băm (hash table)', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Cây đỏ-đen (Red-Black tree)', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q15 := 'TreeMap bảo đảm chi phí thời gian log(n) cho những thao tác nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 60, @admin, @q15, 'For which operations does TreeMap guarantee log(n) time cost?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/TreeMap.html', SHA2(LOWER(@q15),256), 'single', 'medium', NOW(3), 'active', @src_java_treemap, 'java.util.TreeMap — chi phí thao tác', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_java_treemap IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q15),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=60 AND content_hash=SHA2(LOWER(@q15),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Chỉ get và put', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Chỉ các thao tác duyệt (iteration)', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Mọi thao tác, kể cả sao chép toàn bộ map', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'containsKey, get, put và remove', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

-- ===== Hoc phan #54: Xác suất thống kê (15 cau) =====
SET @q16 := 'Trong thống kê mô tả, hệ số bất đối xứng (skewness) đo lường điều gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 54, @admin, @q16, 'In descriptive statistics, what does skewness measure?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.itl.nist.gov/div898/handbook/eda/section3/eda35b.htm', SHA2(LOWER(@q16),256), 'single', 'easy', NOW(3), 'active', @src_nist_skew, '1.3.5.11 — định nghĩa skewness', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_skew IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q16),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q16),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Tính đối xứng, chính xác hơn là mức độ thiếu đối xứng của phân phối', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Mức độ phân tán của dữ liệu quanh giá trị trung bình', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Xác suất xuất hiện giá trị ngoại lai', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Sai số chuẩn của giá trị trung bình mẫu', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q17 := 'Một tập dữ liệu có skewness mang giá trị âm thì phân phối của nó lệch về phía nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 54, @admin, @q17, 'If a data set has negative skewness, in which direction is the distribution skewed?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.itl.nist.gov/div898/handbook/eda/section3/eda35b.htm', SHA2(LOWER(@q17),256), 'single', 'medium', NOW(3), 'active', @src_nist_skew, '1.3.5.11 — dấu của skewness', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_skew IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q17),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q17),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Không kết luận được từ dấu của skewness', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Lệch phải', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Lệch trái', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Không lệch, luôn đối xứng', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q18 := 'Hệ số nhọn (kurtosis) cho biết điều gì về dữ liệu?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 54, @admin, @q18, 'What does kurtosis tell us about the data?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.itl.nist.gov/div898/handbook/eda/section3/eda35b.htm', SHA2(LOWER(@q18),256), 'single', 'easy', NOW(3), 'active', @src_nist_skew, '1.3.5.11 — định nghĩa kurtosis', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_skew IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q18),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q18),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Trung bình mẫu lệch bao nhiêu so với trung vị', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Phương sai mẫu lớn hay nhỏ hơn phương sai tổng thể', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Dữ liệu có đuôi nặng hay đuôi nhẹ so với phân phối chuẩn', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Dữ liệu có bao nhiêu giá trị trùng nhau', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q19 := 'Vì sao định nghĩa excess kurtosis lại trừ đi 3?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 54, @admin, @q19, 'Why does the definition of excess kurtosis subtract 3?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.itl.nist.gov/div898/handbook/eda/section3/eda35b.htm', SHA2(LOWER(@q19),256), 'single', 'medium', NOW(3), 'active', @src_nist_skew, '1.3.5.11 — excess kurtosis', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_skew IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q19),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q19),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Để giá trị luôn không âm', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Để chuẩn hóa theo cỡ mẫu', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Để bù cho ba tham số đã ước lượng trước đó', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Để giá trị của phân phối chuẩn bằng 0', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q20 := 'Trong kiểm định giả thuyết, giả thuyết không (null hypothesis) là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 54, @admin, @q20, 'In hypothesis testing, what is the null hypothesis?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.itl.nist.gov/div898/handbook/prc/section1/prc13.htm', SHA2(LOWER(@q20),256), 'single', 'easy', NOW(3), 'active', @src_nist_hyp, '7.1.3 — null hypothesis', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_hyp IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q20),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q20),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Phát biểu về niềm tin cần được đem ra kiểm định, ví dụ trung bình bằng 500 micromet', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Phát biểu luôn bị bác bỏ sau khi kiểm định', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Phát biểu chỉ dùng khi cỡ mẫu nhỏ hơn 30', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Phát biểu về phương sai của tổng thể', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q21 := 'Rủi ro bác bỏ giả thuyết không trong khi nó thực sự đúng được gọi là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 54, @admin, @q21, 'What is the risk of rejecting the null hypothesis when it is in fact true called?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.itl.nist.gov/div898/handbook/prc/section1/prc13.htm', SHA2(LOWER(@q21),256), 'single', 'medium', NOW(3), 'active', @src_nist_hyp, '7.1.3 — Type I error', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_hyp IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q21),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q21),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Độ mạnh của kiểm định', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Lỗi loại II', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Lỗi loại I', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Sai số chuẩn', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q22 := 'Trong kiểm định giả thuyết, rủi ro α thường được gọi bằng tên nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 54, @admin, @q22, 'In hypothesis testing, what is the risk α usually referred to as?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.itl.nist.gov/div898/handbook/prc/section1/prc13.htm', SHA2(LOWER(@q22),256), 'single', 'medium', NOW(3), 'active', @src_nist_hyp, '7.1.3 — significance level', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_hyp IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q22),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q22),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Bậc tự do của kiểm định', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Sai số loại hai', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Mức ý nghĩa của kiểm định (significance level)', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Độ tin cậy của kiểm định', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q23 := 'Rủi ro không bác bỏ giả thuyết không trong khi nó thực sự sai được ký hiệu và gọi là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 54, @admin, @q23, 'What is the risk of failing to reject the null hypothesis when it is in fact false called?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.itl.nist.gov/div898/handbook/prc/section1/prc13.htm', SHA2(LOWER(@q23),256), 'single', 'medium', NOW(3), 'active', @src_nist_hyp, '7.1.3 — Type II error', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_hyp IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q23),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q23),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'β, lỗi loại hai', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'p, giá trị p', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'σ, độ lệch chuẩn', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'α, lỗi loại một', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q24 := 'Trong công thức hàm mật độ của phân phối chuẩn, tham số μ được gọi là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 54, @admin, @q24, 'In the normal distribution probability density function, what is the parameter μ called?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.itl.nist.gov/div898/handbook/eda/section3/eda3661.htm', SHA2(LOWER(@q24),256), 'single', 'easy', NOW(3), 'active', @src_nist_norm, '1.3.6.6.1 — location parameter', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_norm IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q24),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q24),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Tham số vị trí (location parameter)', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tham số tỷ lệ (scale parameter)', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tham số hình dạng (shape parameter)', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Tham số ngưỡng (threshold parameter)', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q25 := 'Trong hàm mật độ của phân phối chuẩn, tham số σ đóng vai trò gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 54, @admin, @q25, 'In the normal distribution probability density function, what role does σ play?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.itl.nist.gov/div898/handbook/eda/section3/eda3661.htm', SHA2(LOWER(@q25),256), 'single', 'easy', NOW(3), 'active', @src_nist_norm, '1.3.6.6.1 — scale parameter', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_norm IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q25),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q25),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Hệ số chuẩn hóa', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tham số vị trí', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tham số tỷ lệ (scale parameter)', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Tham số hình dạng', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q26 := 'Phân phối chuẩn tắc (standard normal distribution) ứng với cặp tham số nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 54, @admin, @q26, 'Which parameter values correspond to the standard normal distribution?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.itl.nist.gov/div898/handbook/eda/section3/eda3661.htm', SHA2(LOWER(@q26),256), 'single', 'easy', NOW(3), 'active', @src_nist_norm, '1.3.6.6.1 — standard normal distribution', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_norm IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q26),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q26),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'μ = 0 và σ = 0', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'μ = 1 và σ = 1', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'μ = 1 và σ = 0', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'μ = 0 và σ = 1', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q27 := 'Hàm mật độ xác suất của phân phối chuẩn tắc có dạng nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 54, @admin, @q27, 'What is the probability density function of the standard normal distribution?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.itl.nist.gov/div898/handbook/eda/section3/eda3661.htm', SHA2(LOWER(@q27),256), 'single', 'medium', NOW(3), 'active', @src_nist_norm, '1.3.6.6.1 — công thức dạng chuẩn tắc', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_norm IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q27),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q27),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'f(x) = e^(−x) / √(2π)', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'f(x) = e^(−x²) / (2π)', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'f(x) = x·e^(−x²/2) / √(2π)', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'f(x) = e^(−x²/2) / √(2π)', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q28 := 'Trong phân phối t, bậc tự do ν là loại tham số gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 54, @admin, @q28, 'In the t distribution, what kind of parameter is the degrees of freedom ν?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.itl.nist.gov/div898/handbook/eda/section3/eda3664.htm', SHA2(LOWER(@q28),256), 'single', 'medium', NOW(3), 'active', @src_nist_t, '1.3.6.6.4 — tham số ν', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_t IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q28),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q28),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Tham số hình dạng, nhận giá trị nguyên dương', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tham số vị trí, nhận giá trị thực bất kỳ', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tham số tỷ lệ, luôn lớn hơn 1', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Hằng số chuẩn hóa, không phải tham số', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q29 := 'Phân phối t có tính đối xứng hay không?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 54, @admin, @q29, 'Is the t distribution symmetric?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.itl.nist.gov/div898/handbook/eda/section3/eda3664.htm', SHA2(LOWER(@q29),256), 'single', 'easy', NOW(3), 'active', @src_nist_t, '1.3.6.6.4 — tính đối xứng', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_t IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q29),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q29),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Chỉ đối xứng khi bậc tự do lớn hơn 30', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Có, phân phối t đối xứng trong mọi trường hợp', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Không, phân phối t luôn lệch phải', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Không, phân phối t luôn lệch trái', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q30 := 'Khi bậc tự do ν tăng lên rất lớn, phân phối t tiến tới phân phối nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 54, @admin, @q30, 'As the degrees of freedom ν becomes large, which distribution does the t distribution approach?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.itl.nist.gov/div898/handbook/eda/section3/eda3664.htm', SHA2(LOWER(@q30),256), 'single', 'medium', NOW(3), 'active', @src_nist_t, '1.3.6.6.4 — quan hệ với phân phối chuẩn', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_t IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q30),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=54 AND content_hash=SHA2(LOWER(@q30),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Phân phối mũ', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Phân phối chi bình phương', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Phân phối đều', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Phân phối chuẩn', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

-- ===== Hoc phan #52: Đại số tuyến tính (15 cau) =====
SET @q31 := 'Định thức của ma trận vuông cấp n được định nghĩa bằng tổng nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 52, @admin, @q31, 'How is the determinant of an n×n matrix defined?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.2', SHA2(LOWER(@q31),256), 'single', 'medium', NOW(3), 'active', @src_dlmf12, '§1.2(iv) Matrices — định nghĩa định thức', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf12 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q31),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q31),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Tổng các phần tử trên đường chéo chính', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tích các phần tử trên đường chéo chính trừ tích đường chéo phụ, áp dụng cho mọi cấp n', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tổng bình phương mọi phần tử của ma trận', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Tổng theo mọi hoán vị σ của tích các phần tử, mỗi số hạng mang dấu của hoán vị đó (công thức Leibniz)', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q32 := 'Một ma trận vuông được gọi là kỳ dị (singular) khi nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 52, @admin, @q32, 'When is a square matrix called singular?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.2', SHA2(LOWER(@q32),256), 'single', 'easy', NOW(3), 'active', @src_dlmf12, '§1.2(iv) Matrices — ma trận kỳ dị', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf12 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q32),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q32),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Khi định thức của nó bằng 0', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Khi định thức của nó khác 0', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Khi nó không phải ma trận vuông', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Khi mọi phần tử của nó đều bằng 0', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q33 := 'Khi định thức khác 0, ma trận A có nghịch đảo duy nhất A⁻¹ thỏa mãn hệ thức nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 52, @admin, @q33, 'When the determinant is nonzero, the unique inverse A⁻¹ satisfies which identity?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.2', SHA2(LOWER(@q33),256), 'single', 'medium', NOW(3), 'active', @src_dlmf12, '§1.2(iv) Matrices — ma trận nghịch đảo', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf12 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q33),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q33),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'A·A⁻¹ = A', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'A·A⁻¹ = A⁻¹·A = I', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'A·A⁻¹ = 0', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'A + A⁻¹ = I', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q34 := 'Hệ phương trình tuyến tính Ab = c cấp n có nghiệm duy nhất b = A⁻¹c khi nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 52, @admin, @q34, 'The linear system Ab = c of order n has the unique solution b = A⁻¹c under which condition?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.2', SHA2(LOWER(@q34),256), 'single', 'medium', NOW(3), 'active', @src_dlmf12, '§1.2(iv) Matrices — hệ phương trình tuyến tính', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf12 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q34),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q34),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Khi c là vectơ không', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Khi A là ma trận đối xứng', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Khi det(A) ≠ 0', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Khi det(A) = 0', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q35 := 'Ma trận A được gọi là Hermitian khi các phần tử của nó thỏa điều kiện nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 52, @admin, @q35, 'A matrix A is Hermitian when its entries satisfy which condition?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.2', SHA2(LOWER(@q35),256), 'single', 'medium', NOW(3), 'active', @src_dlmf12, '§1.2(iv) Matrices — ma trận Hermitian', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf12 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q35),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q35),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'aⱼᵢ = −aᵢⱼ', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'aⱼᵢ = aᵢⱼ với mọi phần tử đều là số phức thuần ảo', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Mọi phần tử ngoài đường chéo đều bằng 0', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'aⱼᵢ bằng liên hợp phức của aᵢⱼ', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q36 := 'Ma trận thực A là đối xứng khi nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 52, @admin, @q36, 'When is a real matrix A symmetric?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.2', SHA2(LOWER(@q36),256), 'single', 'easy', NOW(3), 'active', @src_dlmf12, '§1.2(iv) Matrices — ma trận đối xứng thực', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf12 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q36),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q36),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Khi aⱼᵢ = aᵢⱼ với mọi i, j', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Khi aⱼᵢ = −aᵢⱼ với mọi i, j', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Khi det(A) = 1', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Khi A bằng nghịch đảo của chính nó', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q37 := 'Vết (trace) của ma trận vuông A được tính như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 52, @admin, @q37, 'How is the trace of a square matrix A computed?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.2', SHA2(LOWER(@q37),256), 'single', 'easy', NOW(3), 'active', @src_dlmf12, '§1.2(iv) Matrices — vết của ma trận', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf12 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q37),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q37),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Tổng các trị riêng lấy giá trị tuyệt đối', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tổng các phần tử trên đường chéo chính', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tích các phần tử trên đường chéo chính', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Tổng mọi phần tử của ma trận', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q38 := 'Bất đẳng thức Cauchy–Schwarz phát biểu quan hệ nào giữa tích vô hướng và chuẩn của hai vectơ?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 52, @admin, @q38, 'What relation does the Cauchy–Schwarz inequality state between an inner product and vector norms?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.2', SHA2(LOWER(@q38),256), 'single', 'medium', NOW(3), 'active', @src_dlmf12, '§1.2(v) — bất đẳng thức Cauchy–Schwarz', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf12 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q38),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q38),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', '⟨u, v⟩ = ‖u‖ + ‖v‖', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', '‖u‖ · ‖v‖ ≤ ‖u + v‖', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', '|⟨u, v⟩| ≤ ‖u‖ · ‖v‖', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', '|⟨u, v⟩| ≥ ‖u‖ · ‖v‖', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q39 := 'Bất đẳng thức tam giác cho chuẩn vectơ được phát biểu như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 52, @admin, @q39, 'How is the triangle inequality for vector norms stated?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.2', SHA2(LOWER(@q39),256), 'single', 'easy', NOW(3), 'active', @src_dlmf12, '§1.2(v) — bất đẳng thức tam giác', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf12 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q39),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q39),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', '‖u + v‖ ≥ ‖u‖ + ‖v‖', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', '‖u + v‖ = ‖u‖ + ‖v‖', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', '‖u − v‖ ≤ ‖u‖ · ‖v‖', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', '‖u + v‖ ≤ ‖u‖ + ‖v‖', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q40 := 'Chuẩn Euclid của vectơ là trường hợp riêng của chuẩn Lₚ ứng với giá trị p nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 52, @admin, @q40, 'The Euclidean norm is the special case of the Lₚ norm for which value of p?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.2', SHA2(LOWER(@q40),256), 'single', 'medium', NOW(3), 'active', @src_dlmf12, '§1.2(v) — chuẩn Lₚ', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf12 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q40),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q40),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'p = 1', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'p = 2', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'p = ∞', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'p = 0', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q41 := 'Bài toán trị riêng đối xứng (symmetric eigenproblem) với A thực được phát biểu như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 52, @admin, @q41, 'How is the symmetric eigenproblem for a real matrix A stated?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.netlib.org/lapack/lug/node30.html', SHA2(LOWER(@q41),256), 'single', 'medium', NOW(3), 'active', @src_lapack_sep, 'Symmetric Eigenproblems — phát biểu bài toán', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_lapack_sep IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q41),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q41),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Ax = b, với A đối xứng', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Az = λz, với A = Aᵀ', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Az = λz, với A bất kỳ', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'A = LU, với L tam giác dưới', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q42 := 'Với ma trận phức, bài toán trị riêng Hermitian được viết ra sao?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 52, @admin, @q42, 'For complex matrices, how is the Hermitian eigenvalue problem written?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.netlib.org/lapack/lug/node30.html', SHA2(LOWER(@q42),256), 'single', 'medium', NOW(3), 'active', @src_lapack_sep, 'Symmetric Eigenproblems — bài toán Hermitian', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_lapack_sep IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q42),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q42),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Az = λz, với A là ma trận đơn vị', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Az = λz, với A tam giác trên', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Az = λz, với A = Aᴴ (bằng chuyển vị liên hợp của chính nó)', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Az = λz, với A = −Aᴴ', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q43 := 'Với bài toán trị riêng đối xứng thực hoặc Hermitian, các trị riêng λ có tính chất gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 52, @admin, @q43, 'For the real symmetric or Hermitian eigenproblem, what property do the eigenvalues λ have?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.netlib.org/lapack/lug/node30.html', SHA2(LOWER(@q43),256), 'single', 'medium', NOW(3), 'active', @src_lapack_sep, 'Symmetric Eigenproblems — tính chất trị riêng', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_lapack_sep IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q43),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q43),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Luôn là số thuần ảo', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Luôn dương', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Luôn nằm trong đoạn [−1, 1]', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Luôn là số thực', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q44 := 'Trong phân tích phổ A = ZΛZᵀ của ma trận đối xứng thực, ma trận Z và Λ có vai trò gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 52, @admin, @q44, 'In the spectral factorization A = ZΛZᵀ of a real symmetric matrix, what are Z and Λ?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.netlib.org/lapack/lug/node30.html', SHA2(LOWER(@q44),256), 'single', 'hard', NOW(3), 'active', @src_lapack_sep, 'Symmetric Eigenproblems — phân tích phổ', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_lapack_sep IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q44),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q44),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Z là ma trận trực giao chứa các vectơ riêng, Λ là ma trận đường chéo chứa các trị riêng', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Z là ma trận đường chéo chứa trị riêng, Λ là ma trận trực giao chứa vectơ riêng', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Z là ma trận tam giác dưới, Λ là ma trận tam giác trên', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Z và Λ đều là ma trận đường chéo', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q45 := 'Trong phương trình Az = λz, vectơ riêng z phải thỏa điều kiện nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 52, @admin, @q45, 'In the equation Az = λz, what condition must the eigenvector z satisfy?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.netlib.org/lapack/lug/node30.html', SHA2(LOWER(@q45),256), 'single', 'easy', NOW(3), 'active', @src_lapack_sep, 'Symmetric Eigenproblems — vectơ riêng', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_lapack_sep IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q45),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=52 AND content_hash=SHA2(LOWER(@q45),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'z phải trực giao với mọi cột của A', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'z phải là vectơ khác không', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'z phải là vectơ không', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'z phải có chuẩn bằng λ', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

-- ===== Hoc phan #53: Giải tích (15 cau) =====
SET @q46 := 'Đạo hàm f′(x) được định nghĩa bằng giới hạn nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 53, @admin, @q46, 'By which limit is the derivative f′(x) defined?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.4', SHA2(LOWER(@q46),256), 'single', 'easy', NOW(3), 'active', @src_dlmf14, '§1.4(iii) Derivatives — định nghĩa đạo hàm', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf14 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q46),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q46),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'lim(x→0) f(x) / x', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'lim(h→∞) [f(x + h) − f(x)] / h', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'lim(h→0) [f(x + h) − f(x)] / h', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'lim(h→0) [f(x + h) + f(x)] / h', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q47 := 'Với hàm hợp h(x) = f(g(x)), quy tắc chuỗi cho kết quả nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 53, @admin, @q47, 'For the composite function h(x) = f(g(x)), what does the chain rule give?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.4', SHA2(LOWER(@q47),256), 'single', 'easy', NOW(3), 'active', @src_dlmf14, '§1.4(iii) — quy tắc chuỗi', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf14 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q47),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q47),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'h′(x) = f′(x) · g′(x)', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'h′(x) = f′(g′(x))', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'h′(x) = f(g′(x))', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'h′(x) = f′(g(x)) · g′(x)', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q48 := 'Định lý giá trị trung bình khẳng định điều gì khi f liên tục trên [a, b] và khả vi trên (a, b)?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 53, @admin, @q48, 'What does the mean value theorem assert when f is continuous on [a, b] and differentiable on (a, b)?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.4', SHA2(LOWER(@q48),256), 'single', 'medium', NOW(3), 'active', @src_dlmf14, '§1.4(iii) — định lý giá trị trung bình', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf14 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q48),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q48),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Tồn tại c thuộc (a, b) sao cho f(b) − f(a) = (b − a)·f′(c)', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tồn tại c thuộc (a, b) sao cho f′(c) = 0', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Với mọi c thuộc (a, b) đều có f(b) − f(a) = (b − a)·f′(c)', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'f đạt giá trị lớn nhất tại một điểm trong (a, b)', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q49 := 'Định lý cơ bản của giải tích cho phép tính tích phân xác định bằng cách nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 53, @admin, @q49, 'How does the fundamental theorem of calculus let us evaluate a definite integral?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.4', SHA2(LOWER(@q49),256), 'single', 'medium', NOW(3), 'active', @src_dlmf14, '§1.4(v) Integrals — định lý cơ bản', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf14 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q49),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q49),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Bằng giới hạn của dãy đạo hàm cấp cao', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Bằng F(b) − F(a), với F là nguyên hàm của f', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Bằng f(b) − f(a)', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Bằng (b − a)·f′(c) với c nào đó', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q50 := 'Quy tắc L''Hôpital áp dụng cho giới hạn dạng vô định nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 53, @admin, @q50, 'To which indeterminate limits does L''Hôpital''s rule apply?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.4', SHA2(LOWER(@q50),256), 'single', 'medium', NOW(3), 'active', @src_dlmf14, '§1.4(iii) — quy tắc L''Hôpital', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf14 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q50),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q50),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Với mọi giới hạn của thương hai hàm khả vi', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Chỉ khi f và g là đa thức', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Khi cả f và g cùng tiến tới 0, hoặc cùng tiến tới vô cùng, tại điểm đang xét', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Chỉ khi f tiến tới 0 còn g tiến tới vô cùng', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q51 := 'Định lý Taylor cho hàm biến thực đòi hỏi điều kiện nào về f trên đoạn [a, b]?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 53, @admin, @q51, 'What condition on f over [a, b] does Taylor''s theorem for real variables require?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.4', SHA2(LOWER(@q51),256), 'single', 'hard', NOW(3), 'active', @src_dlmf14, '§1.4(vi) Taylor''s Theorem', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf14 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q51),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q51),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'f chỉ cần liên tục trên [a, b]', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'f chỉ cần khả vi cấp một trên (a, b)', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'f phải là đa thức bậc không quá n', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'f thuộc lớp Cⁿ⁺¹[a, b], tức khả vi liên tục đến cấp n+1', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q52 := 'Hàm f được gọi là lồi trên (a, b) khi nó thỏa bất đẳng thức nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 53, @admin, @q52, 'A function f is convex on (a, b) when it satisfies which inequality?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.4', SHA2(LOWER(@q52),256), 'single', 'hard', NOW(3), 'active', @src_dlmf14, '§1.4(viii) Convex Functions', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf14 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q52),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q52),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'f((1 − t)c + td) ≤ (1 − t)f(c) + t·f(d)', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'f((1 − t)c + td) ≥ (1 − t)f(c) + t·f(d)', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'f(c + d) ≤ f(c) + f(d)', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'f′(x) ≤ 0 với mọi x thuộc (a, b)', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q53 := 'Tích phân Riemann của f trên [a, b] là giới hạn của đại lượng nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 53, @admin, @q53, 'The Riemann integral of f over [a, b] is the limit of what quantity?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.4', SHA2(LOWER(@q53),256), 'single', 'medium', NOW(3), 'active', @src_dlmf14, '§1.4(v) — tích phân Riemann', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf14 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q53),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q53),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Trung bình cộng của f(a) và f(b) nhân với (b − a)', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tổng các tích f(ξⱼ)·(xⱼ₊₁ − xⱼ) theo phân hoạch của đoạn [a, b]', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tổng các giá trị f(xⱼ) theo phân hoạch', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Tích các giá trị f(ξⱼ) theo phân hoạch', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q54 := 'Tích phân suy rộng từ a đến vô cùng được xem là hội tụ khi nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 53, @admin, @q54, 'When is the improper integral from a to infinity said to converge?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.4', SHA2(LOWER(@q54),256), 'single', 'medium', NOW(3), 'active', @src_dlmf14, '§1.4(v) — tích phân suy rộng', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf14 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q54),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q54),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Khi hàm dưới dấu tích phân tiến tới 0 tại vô cùng', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Khi hàm dưới dấu tích phân liên tục trên toàn bộ nửa trục', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Khi giới hạn của tích phân từ a đến b, cho b tiến tới vô cùng, tồn tại', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Khi hàm dưới dấu tích phân bị chặn', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q55 := 'Đạo hàm riêng theo x của hàm hai biến f(x, y) được định nghĩa bằng giới hạn nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 53, @admin, @q55, 'How is the partial derivative with respect to x of f(x, y) defined?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.5', SHA2(LOWER(@q55),256), 'single', 'easy', NOW(3), 'active', @src_dlmf15, '§1.5(i) — đạo hàm riêng', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf15 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q55),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q55),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'lim(h→0) [f(x, y + h) − f(x, y)] / h', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'lim(h→0) [f(x + h, y + h) − f(x, y)] / h', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'lim(h→0) [f(x + h, y) − f(x, y + h)] / h', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'lim(h→0) [f(x + h, y) − f(x, y)] / h', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q56 := 'Hàm f(x, y) liên tục tại điểm (a, b) khi nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 53, @admin, @q56, 'When is f(x, y) continuous at the point (a, b)?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.5', SHA2(LOWER(@q56),256), 'single', 'easy', NOW(3), 'active', @src_dlmf15, '§1.5(i) — tính liên tục', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf15 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q56),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q56),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Khi giới hạn của f(x, y) lúc (x, y) tiến tới (a, b) bằng đúng f(a, b)', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Khi f có đạo hàm riêng tại (a, b)', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Khi f bị chặn trong lân cận của (a, b)', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Khi f(a, b) xác định', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q57 := 'Với hàm khả vi liên tục đến cấp hai, hai đạo hàm riêng hỗn hợp có quan hệ gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 53, @admin, @q57, 'For twice continuously differentiable functions, how are the mixed partial derivatives related?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.5', SHA2(LOWER(@q57),256), 'single', 'medium', NOW(3), 'active', @src_dlmf15, '§1.5(i) — định lý Clairaut–Schwarz', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf15 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q57),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q57),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Chúng không có quan hệ tổng quát nào', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Chúng bằng nhau: đạo hàm theo x rồi y bằng đạo hàm theo y rồi x', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Chúng đối nhau về dấu', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Chúng chỉ bằng nhau khi hàm là đa thức', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q58 := 'Điều kiện cần bậc nhất để hàm hai biến đạt cực trị địa phương tại (a, b) là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 53, @admin, @q58, 'What is the first-order necessary condition for a local extremum of a function of two variables at (a, b)?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.5', SHA2(LOWER(@q58),256), 'single', 'medium', NOW(3), 'active', @src_dlmf15, '§1.5(iii) — điểm dừng', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf15 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q58),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q58),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Định thức Jacobi tại (a, b) bằng 0', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Hàm liên tục tại (a, b)', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Cả hai đạo hàm riêng bậc nhất tại (a, b) đều bằng 0', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Cả hai đạo hàm riêng bậc hai tại (a, b) đều bằng 0', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q59 := 'Phép đổi sang tọa độ cầu biểu diễn z theo công thức nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 53, @admin, @q59, 'In the spherical coordinate transformation, how is z expressed?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.5', SHA2(LOWER(@q59),256), 'single', 'medium', NOW(3), 'active', @src_dlmf15, '§1.5(ii) — tọa độ cầu', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf15 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q59),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q59),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'z = ρ·sin θ·cos φ', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'z = ρ·sin θ·sin φ', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'z = ρ·tan θ', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'z = ρ·cos θ', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q60 := 'Định thức Jacobi của phép đổi biến sang tọa độ cầu bằng bao nhiêu?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 53, @admin, @q60, 'What is the Jacobian determinant of the transformation to spherical coordinates?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dlmf.nist.gov/1.5', SHA2(LOWER(@q60),256), 'single', 'hard', NOW(3), 'active', @src_dlmf15, '§1.5(v) — định thức Jacobi của tọa độ cầu', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_dlmf15 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q60),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=53 AND content_hash=SHA2(LOWER(@q60),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'ρ²·sin θ', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'ρ·sin θ', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'ρ²', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'sin θ·cos φ', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

-- ===== Hoc phan #55: Vật lý đại cương (15 cau) =====
SET @q61 := 'Hệ đơn vị quốc tế SI hiện có bao nhiêu đơn vị cơ bản?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 55, @admin, @q61, 'How many base units does the International System of Units (SI) currently have?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.bipm.org/en/measurement-units', SHA2(LOWER(@q61),256), 'single', 'easy', NOW(3), 'active', @src_bipm_units, 'SI base units — số lượng đơn vị cơ bản', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_bipm_units IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q61),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q61),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Chín', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Năm', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Sáu', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Bảy', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q62 := 'Đơn vị cơ bản SI của lượng chất là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 55, @admin, @q62, 'What is the SI base unit of amount of substance?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.nist.gov/si-redefinition/meet-constants', SHA2(LOWER(@q62),256), 'single', 'easy', NOW(3), 'active', @src_nist_si, 'SI base units — lượng chất', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_si IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q62),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q62),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'candela', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'kelvin', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'mol', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'kilôgam', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q63 := 'Đơn vị cơ bản SI của cường độ sáng là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 55, @admin, @q63, 'What is the SI base unit of luminous intensity?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.nist.gov/si-redefinition/meet-constants', SHA2(LOWER(@q63),256), 'single', 'easy', NOW(3), 'active', @src_nist_si, 'SI base units — cường độ sáng', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_si IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q63),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q63),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'lux (lx)', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'candela (cd)', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'watt (W)', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'lumen (lm)', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q64 := 'Đơn vị cơ bản SI của cường độ dòng điện là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 55, @admin, @q64, 'What is the SI base unit of electric current?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.nist.gov/si-redefinition/meet-constants', SHA2(LOWER(@q64),256), 'single', 'easy', NOW(3), 'active', @src_nist_si, 'SI base units — cường độ dòng điện', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_si IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q64),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q64),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'vôn (V)', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'ampe (A)', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'culông (C)', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'ôm (Ω)', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q65 := 'Hệ SI hiện nay được xây dựng trên nền tảng bao nhiêu hằng số định nghĩa?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 55, @admin, @q65, 'How many defining constants does the present SI rest on?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.nist.gov/si-redefinition/meet-constants', SHA2(LOWER(@q65),256), 'single', 'medium', NOW(3), 'active', @src_nist_si, 'Meet the Constants — số hằng số định nghĩa', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_si IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q65),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q65),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Mười', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Ba', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Năm', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Bảy', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q66 := 'Tần số chuyển mức siêu tinh tế trạng thái cơ bản của nguyên tử caesium-133 được ấn định bằng giá trị nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 55, @admin, @q66, 'What is the fixed value of the caesium-133 ground state hyperfine transition frequency?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.nist.gov/si-redefinition/meet-constants', SHA2(LOWER(@q66),256), 'single', 'medium', NOW(3), 'active', @src_nist_si, 'Meet the Constants — ΔνCs', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_si IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q66),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q66),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', '299 792 458 Hz', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', '6 626 070 15 Hz', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', '9 192 631 770 Hz', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', '1 420 405 751 Hz', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q67 := 'Tốc độ ánh sáng trong chân không c được ấn định chính xác bằng bao nhiêu?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 55, @admin, @q67, 'What is the exact fixed value of the speed of light in vacuum c?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.nist.gov/si-redefinition/meet-constants', SHA2(LOWER(@q67),256), 'single', 'easy', NOW(3), 'active', @src_nist_si, 'Meet the Constants — tốc độ ánh sáng', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_si IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q67),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q67),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', '300 000 000 m/s', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', '299 458 792 m/s', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', '3 × 10⁶ m/s', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', '299 792 458 m/s', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q68 := 'Hằng số Planck h được ấn định chính xác bằng giá trị nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 55, @admin, @q68, 'What is the exact fixed value of the Planck constant h?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.nist.gov/si-redefinition/meet-constants', SHA2(LOWER(@q68),256), 'single', 'medium', NOW(3), 'active', @src_nist_si, 'Meet the Constants — hằng số Planck', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_si IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q68),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q68),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', '6,626 070 15 × 10⁻³⁴ J·s', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', '6,022 140 76 × 10⁻³⁴ J·s', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', '1,380 649 × 10⁻³⁴ J·s', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', '6,626 070 15 × 10⁻¹⁹ J·s', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q69 := 'Điện tích nguyên tố e được ấn định chính xác bằng bao nhiêu?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 55, @admin, @q69, 'What is the exact fixed value of the elementary charge e?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.nist.gov/si-redefinition/meet-constants', SHA2(LOWER(@q69),256), 'single', 'medium', NOW(3), 'active', @src_nist_si, 'Meet the Constants — điện tích nguyên tố', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_si IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q69),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q69),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', '1,380 649 × 10⁻¹⁹ C', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', '1,602 176 634 × 10⁻¹⁹ C', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', '1,602 176 634 × 10⁻²³ C', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', '9,109 383 7 × 10⁻³¹ C', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q70 := 'Hằng số Boltzmann k được ấn định chính xác bằng bao nhiêu?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 55, @admin, @q70, 'What is the exact fixed value of the Boltzmann constant k?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.nist.gov/si-redefinition/meet-constants', SHA2(LOWER(@q70),256), 'single', 'medium', NOW(3), 'active', @src_nist_si, 'Meet the Constants — hằng số Boltzmann', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_si IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q70),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q70),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', '8,314 462 618 × 10⁻²³ J/K', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', '6,022 140 76 × 10⁻²³ J/K', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', '1,380 649 × 10⁻²³ J/K', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', '1,380 649 × 10⁻³⁴ J/K', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q71 := 'Hằng số Avogadro N_A được ấn định chính xác bằng bao nhiêu?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 55, @admin, @q71, 'What is the exact fixed value of the Avogadro constant N_A?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.nist.gov/si-redefinition/meet-constants', SHA2(LOWER(@q71),256), 'single', 'medium', NOW(3), 'active', @src_nist_si, 'Meet the Constants — hằng số Avogadro', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_si IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q71),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q71),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', '6,626 070 15 × 10²³ hạt trên mol', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', '6,022 140 76 × 10²² hạt trên mol', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', '1,602 176 634 × 10²³ hạt trên mol', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', '6,022 140 76 × 10²³ hạt trên mol', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q72 := 'Hiệu suất phát sáng K_cd của bức xạ đơn sắc tần số 540 × 10¹² Hz được ấn định bằng bao nhiêu?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 55, @admin, @q72, 'What is the fixed luminous efficacy K_cd of monochromatic radiation of frequency 540 × 10¹² Hz?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.nist.gov/si-redefinition/meet-constants', SHA2(LOWER(@q72),256), 'single', 'hard', NOW(3), 'active', @src_nist_si, 'Meet the Constants — hiệu suất phát sáng K_cd', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_si IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q72),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q72),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', '683 lumen trên watt', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', '540 lumen trên watt', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', '1 lumen trên watt', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', '683 watt trên lumen', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q73 := 'Từ năm 2019, kilôgam được định nghĩa thông qua hằng số nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 55, @admin, @q73, 'Since 2019, the kilogram is defined in terms of which constant?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.bipm.org/en/measurement-units', SHA2(LOWER(@q73),256), 'single', 'medium', NOW(3), 'active', @src_bipm_units, 'SI — định nghĩa kilôgam', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_bipm_units IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q73),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q73),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Nguyên mẫu kilôgam quốc tế bằng bạch kim–iridi', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Hằng số Planck h', 1, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Hằng số Avogadro N_A', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Khối lượng nguyên tử carbon-12', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q74 := 'Mét được định nghĩa thông qua hằng số nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 55, @admin, @q74, 'The metre is defined in terms of which constant?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.bipm.org/en/measurement-units', SHA2(LOWER(@q74),256), 'single', 'medium', NOW(3), 'active', @src_bipm_units, 'SI — định nghĩa mét', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_bipm_units IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q74),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q74),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Tần số siêu tinh tế của caesium-133', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Hằng số Boltzmann k', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tốc độ ánh sáng trong chân không c', 1, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Hằng số Planck h', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q75 := 'Bốn tiền tố SI được bổ sung năm 2022 là những tiền tố nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 55, @admin, @q75, 'Which four SI prefixes were added in 2022?', 'en', 'translated', 'Giữ nguyên thuật ngữ, ký hiệu và giá trị số theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.nist.gov/pml/owm/metric-si-prefixes', SHA2(LOWER(@q75),256), 'single', 'medium', NOW(3), 'active', @src_nist_prefix, 'Metric (SI) Prefixes — tiền tố bổ sung năm 2022', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_nist_prefix IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q75),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=55 AND content_hash=SHA2(LOWER(@q75),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'yotta, zetta, zepto, yocto', 0, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'exa, peta, femto, atto', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'deka, hecto, deci, centi', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'ronna, quetta, ronto, quecto', 1, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

COMMIT;

-- Kiem tra sau khi chay:
--   SELECT s.id, s.name, COUNT(q.id) FROM subjects s LEFT JOIN questions q ON q.subject_id=s.id AND q.status='active' WHERE s.hidden=0 GROUP BY s.id, s.name;
