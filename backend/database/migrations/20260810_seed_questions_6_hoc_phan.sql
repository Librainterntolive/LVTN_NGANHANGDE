-- Bo sung cau hoi cho 6 hoc phan tu tai lieu chinh thong.
--
-- Moi cau hoi deu bam sat noi dung tai lieu goc da doc, khong viet theo tri nho.
-- Cau hoi bang tieng Viet, giu nguyen thuat ngu ky thuat tieng Anh theo quy uoc;
-- nguyen ban tieng Anh luu vao content_original de doi chieu khi bao ve de tai.
--
-- Nguon su dung (deu la tai lieu tham chieu chinh thuc, truy cap cong khai):
--   MySQL 8.4 Reference Manual — InnoDB Transaction Isolation Levels — https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-isolation-levels.html
--   MySQL 8.4 Reference Manual — How MySQL Uses Indexes — https://dev.mysql.com/doc/refman/8.4/en/mysql-indexes.html
--   Linux manual page — fork(2) — https://man7.org/linux/man-pages/man2/fork.2.html
--   Linux manual page — signal(7) — https://man7.org/linux/man-pages/man7/signal.7.html
--   Git Documentation — git-merge — https://git-scm.com/docs/git-merge
--   Git Documentation — git-rebase — https://git-scm.com/docs/git-rebase
--   RFC 9110 — HTTP Semantics — https://www.rfc-editor.org/rfc/rfc9110.html
--   RFC 9293 — Transmission Control Protocol (TCP) — https://www.rfc-editor.org/rfc/rfc9293.html
--   MDN Web Docs — let — https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let
--   MDN Web Docs — Promise — https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise
--   C++ Core Guidelines — Resource Management — https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-resource
--   C++ Core Guidelines — Constants and Immutability — https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-const

START TRANSACTION;

SET @admin := (SELECT id FROM users WHERE role='Admin' AND status='active' ORDER BY id LIMIT 1);

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'MySQL 8.4 Reference Manual — InnoDB Transaction Isolation Levels', 'Oracle Corporation', 'https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-isolation-levels.html', '', 'Tai lieu tham chieu chinh thuc cua MySQL; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_mysql_iso := (SELECT id FROM sources WHERE url = 'https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-isolation-levels.html');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'MySQL 8.4 Reference Manual — How MySQL Uses Indexes', 'Oracle Corporation', 'https://dev.mysql.com/doc/refman/8.4/en/mysql-indexes.html', '', 'Tai lieu tham chieu chinh thuc cua MySQL; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_mysql_idx := (SELECT id FROM sources WHERE url = 'https://dev.mysql.com/doc/refman/8.4/en/mysql-indexes.html');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'Linux manual page — fork(2)', 'Linux man-pages project', 'https://man7.org/linux/man-pages/man2/fork.2.html', '', 'Trang man chinh thuc cua Linux; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_man_fork := (SELECT id FROM sources WHERE url = 'https://man7.org/linux/man-pages/man2/fork.2.html');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'Linux manual page — signal(7)', 'Linux man-pages project', 'https://man7.org/linux/man-pages/man7/signal.7.html', '', 'Trang man chinh thuc cua Linux; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_man_signal := (SELECT id FROM sources WHERE url = 'https://man7.org/linux/man-pages/man7/signal.7.html');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'Git Documentation — git-merge', 'Software Freedom Conservancy', 'https://git-scm.com/docs/git-merge', '', 'Tai lieu chinh thuc cua Git; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_git_merge := (SELECT id FROM sources WHERE url = 'https://git-scm.com/docs/git-merge');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'Git Documentation — git-rebase', 'Software Freedom Conservancy', 'https://git-scm.com/docs/git-rebase', '', 'Tai lieu chinh thuc cua Git; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_git_rebase := (SELECT id FROM sources WHERE url = 'https://git-scm.com/docs/git-rebase');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'RFC 9110 — HTTP Semantics', 'Internet Engineering Task Force (IETF)', 'https://www.rfc-editor.org/rfc/rfc9110.html', '', 'Tieu chuan Internet chinh thuc; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_rfc9110 := (SELECT id FROM sources WHERE url = 'https://www.rfc-editor.org/rfc/rfc9110.html');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'RFC 9293 — Transmission Control Protocol (TCP)', 'Internet Engineering Task Force (IETF)', 'https://www.rfc-editor.org/rfc/rfc9293.html', '', 'Tieu chuan Internet chinh thuc; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_rfc9293 := (SELECT id FROM sources WHERE url = 'https://www.rfc-editor.org/rfc/rfc9293.html');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'MDN Web Docs — let', 'Mozilla Foundation', 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let', '', 'Tai lieu tham chieu web cua Mozilla, giay phep CC-BY-SA; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_mdn_let := (SELECT id FROM sources WHERE url = 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'MDN Web Docs — Promise', 'Mozilla Foundation', 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise', '', 'Tai lieu tham chieu web cua Mozilla, giay phep CC-BY-SA; cau hoi dien giai tu noi dung goc.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_mdn_promise := (SELECT id FROM sources WHERE url = 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'C++ Core Guidelines — Resource Management', 'Standard C++ Foundation', 'https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-resource', '', 'Huong dan chinh thuc do Bjarne Stroustrup va Herb Sutter bien tap.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_cpp_res := (SELECT id FROM sources WHERE url = 'https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-resource');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'C++ Core Guidelines — Constants and Immutability', 'Standard C++ Foundation', 'https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-const', '', 'Huong dan chinh thuc do Bjarne Stroustrup va Herb Sutter bien tap.', 'verified', @admin, NOW(3), @admin, NOW(3)
WHERE @admin IS NOT NULL
ON DUPLICATE KEY UPDATE verification_status='verified', reviewed_by=@admin, reviewed_at=NOW(3);
SET @src_cpp_const := (SELECT id FROM sources WHERE url = 'https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-const');

-- ===== Hoc phan #61: Cơ sở dữ liệu nâng cao (15 cau) =====
SET @q1 := 'InnoDB hỗ trợ bao nhiêu mức cô lập giao dịch theo chuẩn SQL:1992?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 61, @admin, @q1, 'How many SQL:1992 standard transaction isolation levels does InnoDB support?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-isolation-levels.html', SHA2(LOWER(@q1),256), 'single', 'easy', NOW(3), 'active', @src_mysql_iso, 'InnoDB Transaction Isolation Levels — phần mở đầu', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mysql_iso IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q1),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q1),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Bốn', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Hai', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Ba', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Năm', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q2 := 'Mức cô lập giao dịch mặc định của InnoDB là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 61, @admin, @q2, 'Which is the default transaction isolation level for InnoDB?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-isolation-levels.html', SHA2(LOWER(@q2),256), 'single', 'easy', NOW(3), 'active', @src_mysql_iso, 'InnoDB Transaction Isolation Levels — REPEATABLE READ', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mysql_iso IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q2),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q2),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'REPEATABLE READ', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'READ COMMITTED', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'SERIALIZABLE', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'READ UNCOMMITTED', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q3 := 'Ở mức REPEATABLE READ, các lần đọc nhất quán trong cùng một giao dịch đọc từ đâu?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 61, @admin, @q3, 'At REPEATABLE READ, consistent reads within the same transaction read from what?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-isolation-levels.html', SHA2(LOWER(@q3),256), 'single', 'medium', NOW(3), 'active', @src_mysql_iso, 'InnoDB Transaction Isolation Levels — REPEATABLE READ', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mysql_iso IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q3),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q3),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Snapshot được thiết lập bởi lần đọc đầu tiên', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Snapshot mới ở mỗi lần đọc', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Dữ liệu mới nhất trên đĩa', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Bản ghi trong redo log', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q4 := 'Ở mức READ COMMITTED, mỗi lần đọc nhất quán sẽ làm gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 61, @admin, @q4, 'At READ COMMITTED, what does each consistent read do?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-isolation-levels.html', SHA2(LOWER(@q4),256), 'single', 'medium', NOW(3), 'active', @src_mysql_iso, 'InnoDB Transaction Isolation Levels — READ COMMITTED', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mysql_iso IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q4),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q4),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Thiết lập và đọc snapshot mới của riêng nó', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Dùng lại snapshot của lần đọc đầu tiên', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Khóa toàn bộ bảng', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Bỏ qua mọi khóa', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q5 := 'Hiện tượng đọc dữ liệu chưa commit của giao dịch khác gọi là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 61, @admin, @q5, 'What is it called when a read may use an earlier, uncommitted version of a row?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-isolation-levels.html', SHA2(LOWER(@q5),256), 'single', 'easy', NOW(3), 'active', @src_mysql_iso, 'InnoDB Transaction Isolation Levels — READ UNCOMMITTED', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mysql_iso IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q5),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q5),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Dirty read', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Phantom read', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Non-repeatable read', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Lost update', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q6 := 'Mức cô lập nào cho phép dirty read?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 61, @admin, @q6, 'Which isolation level permits dirty reads?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-isolation-levels.html', SHA2(LOWER(@q6),256), 'single', 'easy', NOW(3), 'active', @src_mysql_iso, 'InnoDB Transaction Isolation Levels — READ UNCOMMITTED', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mysql_iso IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q6),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q6),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'READ UNCOMMITTED', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'READ COMMITTED', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'REPEATABLE READ', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'SERIALIZABLE', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q7 := 'Ở mức SERIALIZABLE khi autocommit bị tắt, InnoDB ngầm chuyển các câu SELECT thường thành gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 61, @admin, @q7, 'At SERIALIZABLE with autocommit disabled, InnoDB implicitly converts plain SELECT statements to what?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-isolation-levels.html', SHA2(LOWER(@q7),256), 'single', 'hard', NOW(3), 'active', @src_mysql_iso, 'InnoDB Transaction Isolation Levels — SERIALIZABLE', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mysql_iso IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q7),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q7),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'SELECT ... FOR SHARE', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'SELECT ... FOR UPDATE', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'SELECT ... LOCK IN EXCLUSIVE MODE', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'SELECT ... NOWAIT', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q8 := 'Mức cô lập nào KHÔNG ngăn được hiện tượng phantom row?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 61, @admin, @q8, 'Which isolation level does NOT prevent phantom rows?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-isolation-levels.html', SHA2(LOWER(@q8),256), 'single', 'hard', NOW(3), 'active', @src_mysql_iso, 'InnoDB Transaction Isolation Levels — READ COMMITTED', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mysql_iso IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q8),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q8),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'READ COMMITTED', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'REPEATABLE READ', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'SERIALIZABLE', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Cả ba đều ngăn được', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q9 := 'Nếu không có index, MySQL phải làm gì để tìm các dòng phù hợp?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 61, @admin, @q9, 'Without an index, what must MySQL do to find the relevant rows?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dev.mysql.com/doc/refman/8.4/en/mysql-indexes.html', SHA2(LOWER(@q9),256), 'single', 'easy', NOW(3), 'active', @src_mysql_idx, 'How MySQL Uses Indexes — mục đích của index', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mysql_idx IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q9),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q9),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Bắt đầu từ dòng đầu tiên và đọc hết toàn bộ bảng', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Đọc ngược từ dòng cuối cùng', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Chỉ đọc phần header của bảng', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Trả về lỗi', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q10 := 'Với index nhiều cột trên (col1, col2, col3), bộ tối ưu có thể dùng những tổ hợp nào để tra cứu?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 61, @admin, @q10, 'With a three-column index on (col1, col2, col3), which lookups can the optimizer use?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dev.mysql.com/doc/refman/8.4/en/mysql-indexes.html', SHA2(LOWER(@q10),256), 'single', 'medium', NOW(3), 'active', @src_mysql_idx, 'How MySQL Uses Indexes — leftmost prefix', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mysql_idx IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q10),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q10),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', '(col1), (col1, col2) và (col1, col2, col3)', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Chỉ (col1, col2, col3)', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', '(col2), (col3) và (col2, col3)', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Mọi tổ hợp bất kỳ của ba cột', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q11 := 'Khi có nhiều index để lựa chọn, MySQL thường chọn index nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 61, @admin, @q11, 'When there is a choice between multiple indexes, which one does MySQL normally use?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dev.mysql.com/doc/refman/8.4/en/mysql-indexes.html', SHA2(LOWER(@q11),256), 'single', 'medium', NOW(3), 'active', @src_mysql_idx, 'How MySQL Uses Indexes — row elimination', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mysql_idx IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q11),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q11),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Index tìm được ít dòng nhất, tức index chọn lọc nhất', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Index được tạo sớm nhất', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Index có nhiều cột nhất', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Index có tên đứng đầu theo bảng chữ cái', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q12 := 'So sánh một cột chuỗi utf8mb4 với một cột latin1 gây ra điều gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 61, @admin, @q12, 'What is the effect of comparing a utf8mb4 column with a latin1 column?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dev.mysql.com/doc/refman/8.4/en/mysql-indexes.html', SHA2(LOWER(@q12),256), 'single', 'hard', NOW(3), 'active', @src_mysql_idx, 'How MySQL Uses Indexes — character set differences', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mysql_idx IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q12),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q12),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Ngăn việc sử dụng index', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tự động chuyển đổi mà vẫn dùng được index', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Gây lỗi cú pháp', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Không ảnh hưởng gì tới hiệu năng', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q13 := 'Khi truy vấn cần đọc phần lớn số dòng của bảng, điều gì đúng?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 61, @admin, @q13, 'When a query needs to access most of the rows, what is true?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dev.mysql.com/doc/refman/8.4/en/mysql-indexes.html', SHA2(LOWER(@q13),256), 'single', 'hard', NOW(3), 'active', @src_mysql_idx, 'How MySQL Uses Indexes — small or large table scans', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mysql_idx IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q13),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q13),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Đọc tuần tự nhanh hơn đi qua index', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Dùng index luôn nhanh hơn', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'MySQL sẽ tự tạo thêm index mới', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Truy vấn sẽ bị từ chối', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q14 := 'Index có thể dùng để sắp xếp hoặc nhóm bảng trong điều kiện nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 61, @admin, @q14, 'Under what condition can an index be used to sort or group a table?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dev.mysql.com/doc/refman/8.4/en/mysql-indexes.html', SHA2(LOWER(@q14),256), 'single', 'medium', NOW(3), 'active', @src_mysql_idx, 'How MySQL Uses Indexes — sorting and grouping', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mysql_idx IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q14),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q14),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Khi việc sắp xếp hoặc nhóm thực hiện trên leftmost prefix của một index khả dụng', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Khi bảng có ít hơn 1000 dòng', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Khi index là UNIQUE', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Khi truy vấn không có mệnh đề WHERE', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q15 := 'Truy vấn lấy được kết quả mà không cần đọc tới các dòng dữ liệu gọi là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 61, @admin, @q15, 'What is it called when a query is optimized to retrieve values without consulting the data rows?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://dev.mysql.com/doc/refman/8.4/en/mysql-indexes.html', SHA2(LOWER(@q15),256), 'single', 'hard', NOW(3), 'active', @src_mysql_idx, 'How MySQL Uses Indexes — covering index', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mysql_idx IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q15),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=61 AND content_hash=SHA2(LOWER(@q15),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Covering index', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Clustered index', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Partial index', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Bitmap index', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

-- ===== Hoc phan #63: Hệ điều hành (15 cau) =====
SET @q16 := 'Khi gọi fork() thành công, giá trị trả về trong tiến trình cha là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 63, @admin, @q16, 'On success, what does fork() return in the parent process?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://man7.org/linux/man-pages/man2/fork.2.html', SHA2(LOWER(@q16),256), 'single', 'easy', NOW(3), 'active', @src_man_fork, 'fork(2) — RETURN VALUE', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_man_fork IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q16),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q16),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'PID của tiến trình con', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', '0', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', '-1', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'PID của chính tiến trình cha', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q17 := 'Khi gọi fork() thành công, giá trị trả về trong tiến trình con là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 63, @admin, @q17, 'On success, what does fork() return in the child process?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://man7.org/linux/man-pages/man2/fork.2.html', SHA2(LOWER(@q17),256), 'single', 'easy', NOW(3), 'active', @src_man_fork, 'fork(2) — RETURN VALUE', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_man_fork IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q17),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q17),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', '0', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'PID của tiến trình cha', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'PID của chính nó', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', '-1', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q18 := 'Khi fork() thất bại, điều gì xảy ra?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 63, @admin, @q18, 'On failure of fork(), what happens?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://man7.org/linux/man-pages/man2/fork.2.html', SHA2(LOWER(@q18),256), 'single', 'medium', NOW(3), 'active', @src_man_fork, 'fork(2) — RETURN VALUE', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_man_fork IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q18),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q18),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Trả về -1 trong tiến trình cha và không tiến trình con nào được tạo', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Trả về 0 trong cả hai tiến trình', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tiến trình con vẫn được tạo nhưng bị treo', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Tiến trình cha bị kết thúc', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q19 := 'Ngay sau khi fork(), quan hệ giữa vùng nhớ của cha và con là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 63, @admin, @q19, 'Immediately after fork(), what is the relationship between the parent''s and child''s memory?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://man7.org/linux/man-pages/man2/fork.2.html', SHA2(LOWER(@q19),256), 'single', 'medium', NOW(3), 'active', @src_man_fork, 'fork(2) — DESCRIPTION, memory spaces', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_man_fork IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q19),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q19),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Hai vùng nhớ có nội dung giống nhau nhưng ghi ở tiến trình này không ảnh hưởng tiến trình kia', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Hai tiến trình dùng chung một vùng nhớ, ghi ở đâu cũng thấy', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tiến trình con không có vùng nhớ riêng', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Vùng nhớ của cha bị xóa sạch', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q20 := 'Linux cài đặt việc sao chép vùng nhớ khi fork() bằng kỹ thuật nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 63, @admin, @q20, 'Which technique does Linux use to implement fork() memory duplication efficiently?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://man7.org/linux/man-pages/man2/fork.2.html', SHA2(LOWER(@q20),256), 'single', 'medium', NOW(3), 'active', @src_man_fork, 'fork(2) — copy-on-write pages', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_man_fork IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q20),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q20),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Copy-on-write', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Sao chép toàn bộ ngay lập tức', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Nén vùng nhớ', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Hoán đổi ra đĩa', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q21 := 'File descriptor mà tiến trình con nhận được có đặc điểm gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 63, @admin, @q21, 'What is true about the file descriptors the child receives?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://man7.org/linux/man-pages/man2/fork.2.html', SHA2(LOWER(@q21),256), 'single', 'hard', NOW(3), 'active', @src_man_fork, 'fork(2) — file descriptors', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_man_fork IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q21),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q21),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Là bản sao trỏ tới cùng open file description, dùng chung file offset', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Là các file descriptor hoàn toàn độc lập với offset riêng', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Bị đóng hết trong tiến trình con', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Chỉ đọc được, không ghi được', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q22 := 'Tập tín hiệu đang chờ xử lý của tiến trình con sau fork() như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 63, @admin, @q22, 'What is the child''s set of pending signals after fork()?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://man7.org/linux/man-pages/man2/fork.2.html', SHA2(LOWER(@q22),256), 'single', 'hard', NOW(3), 'active', @src_man_fork, 'fork(2) — pending signals not inherited', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_man_fork IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q22),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q22),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Rỗng', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Giống hệt tiến trình cha', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Chỉ giữ lại SIGKILL', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Không xác định', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q23 := 'Bộ đếm tài nguyên đã sử dụng của tiến trình con sau fork() có giá trị gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 63, @admin, @q23, 'What are the child''s resource utilization counters set to after fork()?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://man7.org/linux/man-pages/man2/fork.2.html', SHA2(LOWER(@q23),256), 'single', 'medium', NOW(3), 'active', @src_man_fork, 'fork(2) — resource utilizations reset', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_man_fork IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q23),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q23),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Bằng 0', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Bằng của tiến trình cha', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Bằng một nửa của cha', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Không thay đổi', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q24 := 'Hai tín hiệu nào KHÔNG thể bị bắt, chặn hay bỏ qua?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 63, @admin, @q24, 'Which two signals cannot be caught, blocked, or ignored?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://man7.org/linux/man-pages/man7/signal.7.html', SHA2(LOWER(@q24),256), 'single', 'easy', NOW(3), 'active', @src_man_signal, 'signal(7) — SIGKILL và SIGSTOP', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_man_signal IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q24),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q24),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'SIGKILL và SIGSTOP', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'SIGTERM và SIGINT', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'SIGSEGV và SIGABRT', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'SIGHUP và SIGQUIT', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q25 := 'Hành động mặc định của tín hiệu SIGSTOP là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 63, @admin, @q25, 'What is the default action of SIGSTOP?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://man7.org/linux/man-pages/man7/signal.7.html', SHA2(LOWER(@q25),256), 'single', 'medium', NOW(3), 'active', @src_man_signal, 'signal(7) — bảng tín hiệu, SIGSTOP', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_man_signal IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q25),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q25),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Dừng tiến trình', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Kết thúc tiến trình', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Kết thúc và tạo core dump', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Bỏ qua', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q26 := 'Hành động mặc định của tín hiệu SIGSEGV là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 63, @admin, @q26, 'What is the default action of SIGSEGV?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://man7.org/linux/man-pages/man7/signal.7.html', SHA2(LOWER(@q26),256), 'single', 'medium', NOW(3), 'active', @src_man_signal, 'signal(7) — bảng tín hiệu, SIGSEGV', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_man_signal IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q26),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q26),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Kết thúc tiến trình và tạo core dump', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Chỉ kết thúc tiến trình', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Dừng tiến trình', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Bỏ qua', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q27 := 'Tín hiệu SIGINT tương ứng với sự kiện nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 63, @admin, @q27, 'What event does SIGINT correspond to?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://man7.org/linux/man-pages/man7/signal.7.html', SHA2(LOWER(@q27),256), 'single', 'easy', NOW(3), 'active', @src_man_signal, 'signal(7) — SIGINT', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_man_signal IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q27),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q27),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Ngắt từ bàn phím', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Lỗi truy cập bộ nhớ', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Hết thời gian bộ đếm', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Đóng thiết bị đầu cuối', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q28 := 'Hành động mặc định của SIGTERM là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 63, @admin, @q28, 'What is the default action of SIGTERM?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://man7.org/linux/man-pages/man7/signal.7.html', SHA2(LOWER(@q28),256), 'single', 'easy', NOW(3), 'active', @src_man_signal, 'signal(7) — SIGTERM', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_man_signal IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q28),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q28),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Kết thúc tiến trình', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Dừng tiến trình', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Bỏ qua', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Tạo core dump rồi tiếp tục chạy', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q29 := 'Khác biệt cơ bản giữa SIGTERM và SIGKILL là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 63, @admin, @q29, 'What is the fundamental difference between SIGTERM and SIGKILL?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://man7.org/linux/man-pages/man7/signal.7.html', SHA2(LOWER(@q29),256), 'single', 'hard', NOW(3), 'active', @src_man_signal, 'signal(7) — SIGKILL không thể bị bắt, SIGTERM có thể', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_man_signal IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q29),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q29),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'SIGTERM có thể bị bắt hoặc bỏ qua, còn SIGKILL thì không', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'SIGKILL có thể bị bắt, còn SIGTERM thì không', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Cả hai đều không thể bị bắt', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Cả hai đều có thể bị bắt', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q30 := 'Khóa vùng nhớ (memory lock) của tiến trình cha có được kế thừa sang con không?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 63, @admin, @q30, 'Are the parent''s memory locks inherited by the child?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://man7.org/linux/man-pages/man2/fork.2.html', SHA2(LOWER(@q30),256), 'single', 'hard', NOW(3), 'active', @src_man_fork, 'fork(2) — memory locks not inherited', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_man_fork IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q30),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=63 AND content_hash=SHA2(LOWER(@q30),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Không', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Có, kế thừa toàn bộ', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Chỉ kế thừa khóa đọc', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Tùy theo kiến trúc CPU', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

-- ===== Hoc phan #65: Công nghệ phần mềm (15 cau) =====
SET @q31 := 'Khi nào Git thực hiện được fast-forward merge?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 65, @admin, @q31, 'When can Git perform a fast-forward merge?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://git-scm.com/docs/git-merge', SHA2(LOWER(@q31),256), 'single', 'medium', NOW(3), 'active', @src_git_merge, 'git-merge — FAST-FORWARD MERGE', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_git_merge IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q31),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q31),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Khi HEAD hiện tại là tổ tiên của commit được gộp vào', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Khi hai nhánh có cùng số commit', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Khi không có xung đột nội dung', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Khi nhánh đích đã được đẩy lên remote', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q32 := 'Trong fast-forward merge, Git làm gì với HEAD?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 65, @admin, @q32, 'In a fast-forward merge, what does Git do with HEAD?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://git-scm.com/docs/git-merge', SHA2(LOWER(@q32),256), 'single', 'medium', NOW(3), 'active', @src_git_merge, 'git-merge — fast-forward, không tạo merge commit', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_git_merge IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q32),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q32),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Cập nhật HEAD trỏ tới commit đó mà không tạo thêm merge commit', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tạo một merge commit có hai cha', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tạo một commit rỗng đánh dấu mốc gộp', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Đặt lại HEAD về commit gốc của nhánh', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q33 := 'Tùy chọn --no-ff của git merge có tác dụng gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 65, @admin, @q33, 'What does the --no-ff option of git merge do?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://git-scm.com/docs/git-merge', SHA2(LOWER(@q33),256), 'single', 'medium', NOW(3), 'active', @src_git_merge, 'git-merge — --no-ff', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_git_merge IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q33),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q33),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Luôn tạo merge commit, kể cả khi có thể fast-forward', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Ngăn không cho gộp nếu có xung đột', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Gộp mà không giữ lại lịch sử nhánh nguồn', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Bỏ qua bước kiểm tra fast-forward rồi vẫn fast-forward', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q34 := 'Tùy chọn --squash của git merge tạo ra kết quả gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 65, @admin, @q34, 'What does the --squash option of git merge produce?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://git-scm.com/docs/git-merge', SHA2(LOWER(@q34),256), 'single', 'hard', NOW(3), 'active', @src_git_merge, 'git-merge — --squash', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_git_merge IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q34),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q34),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Tạo trạng thái working tree và index như đã gộp thật, nhưng không tạo commit và không dịch chuyển HEAD', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tạo một merge commit duy nhất có hai cha', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Gộp rồi tự động đẩy lên remote', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Xóa các commit của nhánh nguồn', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q35 := 'Khi dùng --squash, tùy chọn --commit sẽ ra sao?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 65, @admin, @q35, 'With --squash, what happens to the --commit option?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://git-scm.com/docs/git-merge', SHA2(LOWER(@q35),256), 'single', 'hard', NOW(3), 'active', @src_git_merge, 'git-merge — --squash không cho phép --commit', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_git_merge IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q35),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q35),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Không được phép và lệnh sẽ thất bại', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Được dùng bình thường', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Bị bỏ qua trong im lặng', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Chỉ có tác dụng khi không có xung đột', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q36 := 'Merge commit trong Git có đặc điểm gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 65, @admin, @q36, 'What characterizes a merge commit in Git?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://git-scm.com/docs/git-merge', SHA2(LOWER(@q36),256), 'single', 'medium', NOW(3), 'active', @src_git_merge, 'git-merge — merge commit có hai cha', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_git_merge IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q36),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q36),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Có hai commit cha, buộc hai nhánh lại với nhau', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Không có commit cha nào', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Chỉ có một commit cha như commit thường', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Có ba commit cha trở lên trong mọi trường hợp', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q37 := 'Khi gộp một annotated tag, Git xử lý thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 65, @admin, @q37, 'When merging an annotated tag, how does Git behave?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://git-scm.com/docs/git-merge', SHA2(LOWER(@q37),256), 'single', 'hard', NOW(3), 'active', @src_git_merge, 'git-merge — merging tags', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_git_merge IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q37),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q37),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Luôn tạo merge commit kể cả khi có thể fast-forward', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Luôn fast-forward nếu có thể', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Từ chối gộp', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Tự động chuyển sang chế độ --squash', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q38 := 'Về bản chất, git rebase làm gì với các commit?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 65, @admin, @q38, 'Essentially, what does git rebase do with the commits?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://git-scm.com/docs/git-rebase', SHA2(LOWER(@q38),256), 'single', 'medium', NOW(3), 'active', @src_git_rebase, 'git-rebase — replay the commits, one by one', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_git_rebase IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q38),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q38),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Phát lại từng commit, lần lượt theo thứ tự, lên một điểm gốc khác', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Gộp tất cả commit thành một commit duy nhất', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Đảo ngược thứ tự các commit', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Xóa các commit trùng nội dung', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q39 := 'Sau khi rebase, các commit A, B, C của nhánh trở thành gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 65, @admin, @q39, 'After a rebase, what happens to the branch''s commits A, B, C?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://git-scm.com/docs/git-rebase', SHA2(LOWER(@q39),256), 'single', 'medium', NOW(3), 'active', @src_git_rebase, 'git-rebase — sơ đồ A''--B''--C''', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_git_rebase IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q39),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q39),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Trở thành các commit mới A'', B'', C'' với mã băm khác', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Giữ nguyên mã băm cũ', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Bị xóa khỏi lịch sử', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Được đánh dấu là đã gộp nhưng giữ nguyên vị trí', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q40 := 'Vì sao không nên rebase một nhánh mà người khác đã dựa vào để làm việc?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 65, @admin, @q40, 'Why is rebasing a branch others have based work on a bad idea?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://git-scm.com/docs/git-rebase', SHA2(LOWER(@q40),256), 'single', 'hard', NOW(3), 'active', @src_git_rebase, 'git-rebase — RECOVERING FROM UPSTREAM REBASE', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_git_rebase IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q40),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q40),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Mọi người phía sau bị buộc phải sửa lịch sử của họ bằng tay', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Git sẽ từ chối thực hiện lệnh', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Nhánh remote bị xóa tự động', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Các commit bị mất vĩnh viễn không khôi phục được', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q41 := 'Khác biệt cốt lõi giữa merge và rebase về mặt lịch sử là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 65, @admin, @q41, 'What is the core difference between merge and rebase in terms of history?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://git-scm.com/docs/git-rebase', SHA2(LOWER(@q41),256), 'single', 'medium', NOW(3), 'active', @src_git_rebase, 'git-rebase — so sánh với merge', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_git_rebase IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q41),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q41),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Merge giữ nguyên lịch sử và tạo merge commit; rebase viết lại commit để có lịch sử tuyến tính', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Merge viết lại lịch sử; rebase giữ nguyên', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Cả hai đều tạo merge commit', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Cả hai đều cho lịch sử tuyến tính', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q42 := 'Bước đầu tiên của git rebase là làm gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 65, @admin, @q42, 'What is the first step git rebase performs?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://git-scm.com/docs/git-rebase', SHA2(LOWER(@q42),256), 'single', 'hard', NOW(3), 'active', @src_git_rebase, 'git-rebase — liệt kê commit chưa có ở upstream', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_git_rebase IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q42),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q42),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Liệt kê các commit trên nhánh hiện tại chưa có commit tương đương ở upstream', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tạo ngay một merge commit', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Xóa nhánh upstream', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Đẩy nhánh hiện tại lên remote', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q43 := 'Việc phát lại từng commit trong rebase tương đương với lệnh nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 65, @admin, @q43, 'Replaying each commit during rebase is similar to running which command?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://git-scm.com/docs/git-rebase', SHA2(LOWER(@q43),256), 'single', 'hard', NOW(3), 'active', @src_git_rebase, 'git-rebase — tương tự git cherry-pick', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_git_rebase IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q43),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q43),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'git cherry-pick cho từng commit', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'git revert cho từng commit', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'git reset --hard cho từng commit', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'git stash cho từng commit', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q44 := 'Rebase nên được dùng trên loại nhánh nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 65, @admin, @q44, 'On which kind of branch should rebase be used?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://git-scm.com/docs/git-rebase', SHA2(LOWER(@q44),256), 'single', 'medium', NOW(3), 'active', @src_git_rebase, 'git-rebase — chỉ nên dùng trên nhánh chưa công bố', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_git_rebase IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q44),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q44),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Nhánh cục bộ, chưa công bố cho người khác', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Nhánh chính đã được nhiều người dùng', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Nhánh đã được gắn tag phát hành', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Bất kỳ nhánh nào, không có hạn chế', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q45 := 'Sau khi rebase xong, Git cập nhật nhánh như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 65, @admin, @q45, 'After rebasing, how does Git update the branch?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://git-scm.com/docs/git-rebase', SHA2(LOWER(@q45),256), 'single', 'medium', NOW(3), 'active', @src_git_rebase, 'git-rebase — cập nhật nhánh trỏ tới commit cuối', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_git_rebase IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q45),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=65 AND content_hash=SHA2(LOWER(@q45),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Cho nhánh trỏ tới commit cuối cùng vừa được phát lại', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Giữ nhánh ở vị trí cũ', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Xóa nhánh rồi tạo lại từ đầu', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Chuyển nhánh sang trạng thái detached vĩnh viễn', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

-- ===== Hoc phan #62: Mạng máy tính (15 cau) =====
SET @q46 := 'Theo RFC 9110, mã trạng thái HTTP được chia thành mấy lớp?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 62, @admin, @q46, 'According to RFC 9110, how many classes are HTTP status codes organized into?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.rfc-editor.org/rfc/rfc9110.html', SHA2(LOWER(@q46),256), 'single', 'easy', NOW(3), 'active', @src_rfc9110, 'RFC 9110 — Status Codes, phân lớp', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_rfc9110 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q46),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q46),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Năm', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Ba', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Bốn', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Sáu', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q47 := 'Lớp mã trạng thái 2xx mang ý nghĩa gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 62, @admin, @q47, 'What does the 2xx class of status codes mean?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.rfc-editor.org/rfc/rfc9110.html', SHA2(LOWER(@q47),256), 'single', 'easy', NOW(3), 'active', @src_rfc9110, 'RFC 9110 — Successful 2xx', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_rfc9110 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q47),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q47),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Yêu cầu đã được nhận và xử lý thành công', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Yêu cầu bị lỗi phía máy khách', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Máy chủ gặp sự cố', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Cần chuyển hướng thêm', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q48 := 'Lớp mã trạng thái 4xx mang ý nghĩa gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 62, @admin, @q48, 'What does the 4xx class of status codes mean?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.rfc-editor.org/rfc/rfc9110.html', SHA2(LOWER(@q48),256), 'single', 'easy', NOW(3), 'active', @src_rfc9110, 'RFC 9110 — Client Error 4xx', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_rfc9110 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q48),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q48),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Yêu cầu từ máy khách sai cú pháp hoặc không thể đáp ứng', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Máy chủ không hoàn thành được yêu cầu hợp lệ', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Yêu cầu thành công', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Thông tin sơ bộ trong quá trình xử lý', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q49 := 'Lớp mã trạng thái 5xx mang ý nghĩa gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 62, @admin, @q49, 'What does the 5xx class of status codes mean?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.rfc-editor.org/rfc/rfc9110.html', SHA2(LOWER(@q49),256), 'single', 'easy', NOW(3), 'active', @src_rfc9110, 'RFC 9110 — Server Error 5xx', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_rfc9110 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q49),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q49),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Máy chủ không hoàn thành được một yêu cầu hợp lệ', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Máy khách gửi yêu cầu sai', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tài nguyên đã chuyển vị trí', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Yêu cầu cần xác thực', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q50 := 'Mã 301 có ý nghĩa gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 62, @admin, @q50, 'What does status code 301 mean?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.rfc-editor.org/rfc/rfc9110.html', SHA2(LOWER(@q50),256), 'single', 'medium', NOW(3), 'active', @src_rfc9110, 'RFC 9110 — 301 Moved Permanently', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_rfc9110 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q50),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q50),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Tài nguyên đã chuyển vĩnh viễn sang URI mới', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tài nguyên tạm thời ở URI khác', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Không tìm thấy tài nguyên', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Máy chủ từ chối cấp quyền', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q51 := 'Mã 302 có ý nghĩa gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 62, @admin, @q51, 'What does status code 302 mean?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.rfc-editor.org/rfc/rfc9110.html', SHA2(LOWER(@q51),256), 'single', 'medium', NOW(3), 'active', @src_rfc9110, 'RFC 9110 — 302 Found', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_rfc9110 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q51),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q51),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Tài nguyên tạm thời nằm ở một URI khác', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tài nguyên đã chuyển vĩnh viễn', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Yêu cầu sai cú pháp', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Dịch vụ tạm thời không khả dụng', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q52 := 'Khác biệt giữa mã 401 và 403 là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 62, @admin, @q52, 'What is the difference between 401 and 403?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.rfc-editor.org/rfc/rfc9110.html', SHA2(LOWER(@q52),256), 'single', 'hard', NOW(3), 'active', @src_rfc9110, 'RFC 9110 — 401 Unauthorized và 403 Forbidden', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_rfc9110 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q52),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q52),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', '401 là thiếu hoặc sai thông tin xác thực; 403 là máy chủ hiểu yêu cầu nhưng từ chối cấp quyền', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', '401 là máy chủ lỗi; 403 là máy khách lỗi', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', '401 dùng cho HTTPS; 403 dùng cho HTTP', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Hai mã hoàn toàn tương đương', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q53 := 'Mã 400 Bad Request được dùng khi nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 62, @admin, @q53, 'When is 400 Bad Request used?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.rfc-editor.org/rfc/rfc9110.html', SHA2(LOWER(@q53),256), 'single', 'medium', NOW(3), 'active', @src_rfc9110, 'RFC 9110 — 400 Bad Request', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_rfc9110 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q53),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q53),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Khi yêu cầu chứa cú pháp không hợp lệ', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Khi máy chủ gặp lỗi ngoài dự kiến', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Khi tài nguyên không tồn tại', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Khi cần đăng nhập', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q54 := 'Mã 503 Service Unavailable phản ánh tình trạng gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 62, @admin, @q54, 'What condition does 503 Service Unavailable reflect?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.rfc-editor.org/rfc/rfc9110.html', SHA2(LOWER(@q54),256), 'single', 'medium', NOW(3), 'active', @src_rfc9110, 'RFC 9110 — 503 Service Unavailable', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_rfc9110 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q54),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q54),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Máy chủ tạm thời không xử lý được yêu cầu', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tài nguyên đã bị xóa vĩnh viễn', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Yêu cầu vượt quá kích thước cho phép', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Máy khách gửi sai phương thức', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q55 := 'Bắt tay ba bước của TCP gồm những segment nào theo thứ tự?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 62, @admin, @q55, 'Which segments make up the TCP three-way handshake, in order?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.rfc-editor.org/rfc/rfc9293.html', SHA2(LOWER(@q55),256), 'single', 'medium', NOW(3), 'active', @src_rfc9293, 'RFC 9293 — three-way handshake', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_rfc9293 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q55),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q55),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'SYN, rồi SYN kèm ACK, rồi ACK', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'ACK, rồi SYN, rồi FIN', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'SYN, rồi ACK, rồi FIN', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'SYN, rồi RST, rồi ACK', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q56 := 'Trạng thái LISTEN của TCP nghĩa là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 62, @admin, @q56, 'What does the TCP LISTEN state represent?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.rfc-editor.org/rfc/rfc9293.html', SHA2(LOWER(@q56),256), 'single', 'easy', NOW(3), 'active', @src_rfc9293, 'RFC 9293 — LISTEN', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_rfc9293 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q56),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q56),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Đang chờ yêu cầu kết nối từ bất kỳ TCP peer và cổng nào', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Đã gửi yêu cầu kết nối và đang chờ phản hồi', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Kết nối đã mở và truyền được dữ liệu', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Không có kết nối nào', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q57 := 'Trạng thái SYN-SENT nghĩa là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 62, @admin, @q57, 'What does the SYN-SENT state represent?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.rfc-editor.org/rfc/rfc9293.html', SHA2(LOWER(@q57),256), 'single', 'medium', NOW(3), 'active', @src_rfc9293, 'RFC 9293 — SYN-SENT', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_rfc9293 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q57),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q57),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Đã gửi yêu cầu kết nối và đang chờ yêu cầu kết nối tương ứng', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Đang chờ yêu cầu kết nối đến', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Kết nối đã được thiết lập', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Đang chờ đủ thời gian trước khi đóng hẳn', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q58 := 'Trạng thái ESTABLISHED nghĩa là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 62, @admin, @q58, 'What does the ESTABLISHED state represent?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.rfc-editor.org/rfc/rfc9293.html', SHA2(LOWER(@q58),256), 'single', 'easy', NOW(3), 'active', @src_rfc9293, 'RFC 9293 — ESTABLISHED', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_rfc9293 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q58),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q58),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Kết nối đã mở, dữ liệu nhận được có thể chuyển tới người dùng', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Đang chờ kết nối đến', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Đang đóng kết nối', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Không có kết nối nào', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q59 := 'Trạng thái TIME-WAIT tồn tại để làm gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 62, @admin, @q59, 'What is the purpose of the TIME-WAIT state?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.rfc-editor.org/rfc/rfc9293.html', SHA2(LOWER(@q59),256), 'single', 'hard', NOW(3), 'active', @src_rfc9293, 'RFC 9293 — TIME-WAIT', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_rfc9293 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q59),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q59),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Chờ đủ thời gian để chắc chắn TCP peer bên kia đã nhận được ACK', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Chờ dữ liệu còn tồn đọng trong bộ đệm gửi', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Chờ hệ điều hành cấp lại cổng', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Chờ xác thực lại danh tính máy chủ', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q60 := 'Trạng thái CLOSED của TCP nghĩa là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 62, @admin, @q60, 'What does the TCP CLOSED state represent?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://www.rfc-editor.org/rfc/rfc9293.html', SHA2(LOWER(@q60),256), 'single', 'easy', NOW(3), 'active', @src_rfc9293, 'RFC 9293 — CLOSED', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_rfc9293 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q60),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=62 AND content_hash=SHA2(LOWER(@q60),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Hoàn toàn không có trạng thái kết nối nào', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Kết nối đang chờ đóng nốt phía bên kia', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Kết nối đang mở nhưng không truyền dữ liệu', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Kết nối bị lỗi và cần thiết lập lại', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

-- ===== Hoc phan #64: Lập trình Web nâng cao (15 cau) =====
SET @q61 := 'Khai báo bằng let có phạm vi như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 64, @admin, @q61, 'What is the scope of a let declaration?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let', SHA2(LOWER(@q61),256), 'single', 'easy', NOW(3), 'active', @src_mdn_let, 'MDN let — Scope', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mdn_let IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q61),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q61),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Phạm vi block, đồng thời cũng theo hàm', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Chỉ phạm vi hàm', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Phạm vi toàn cục', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Phạm vi tệp', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q62 := 'Khai báo bằng var có phạm vi như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 64, @admin, @q62, 'What is the scope of a var declaration?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let', SHA2(LOWER(@q62),256), 'single', 'easy', NOW(3), 'active', @src_mdn_let, 'MDN let — so sánh với var', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mdn_let IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q62),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q62),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Phạm vi hàm', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Phạm vi block', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Phạm vi câu lệnh', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Phạm vi module', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q63 := 'Trong hàm dùng var, khai báo lại cùng tên bên trong block sẽ ra sao?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 64, @admin, @q63, 'Inside a function using var, what happens when the same name is declared again inside a block?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let', SHA2(LOWER(@q63),256), 'single', 'medium', NOW(3), 'active', @src_mdn_let, 'MDN let — ví dụ varTest', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mdn_let IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q63),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q63),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Vẫn là cùng một biến, giá trị bị ghi đè', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tạo biến mới độc lập', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Gây lỗi SyntaxError', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Biến ngoài bị xóa', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q64 := 'Temporal dead zone của một biến let kéo dài từ đâu đến đâu?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 64, @admin, @q64, 'How far does the temporal dead zone of a let variable extend?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let', SHA2(LOWER(@q64),256), 'single', 'hard', NOW(3), 'active', @src_mdn_let, 'MDN let — Temporal dead zone', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mdn_let IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q64),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q64),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Từ đầu block cho tới khi thực thi chạm tới nơi biến được khai báo và khởi tạo', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Từ đầu tệp cho tới cuối tệp', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Chỉ trong dòng khai báo', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Từ nơi khai báo cho tới cuối block', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q65 := 'Truy cập một biến let khi còn trong temporal dead zone gây ra lỗi gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 64, @admin, @q65, 'What error is thrown when accessing a let variable inside the temporal dead zone?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let', SHA2(LOWER(@q65),256), 'single', 'medium', NOW(3), 'active', @src_mdn_let, 'MDN let — TDZ, ReferenceError', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mdn_let IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q65),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q65),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'ReferenceError', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'TypeError', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'SyntaxError', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Không lỗi, trả về undefined', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q66 := 'Truy cập một biến var trước dòng khai báo cho kết quả gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 64, @admin, @q66, 'What is the result of accessing a var variable before its declaration line?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let', SHA2(LOWER(@q66),256), 'single', 'medium', NOW(3), 'active', @src_mdn_let, 'MDN let — ví dụ so sánh var và let', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mdn_let IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q66),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q66),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'undefined', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'ReferenceError', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'null', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'SyntaxError', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q67 := 'Khai báo lại một biến let trong cùng phạm vi gây ra điều gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 64, @admin, @q67, 'What happens when a let variable is redeclared in the same scope?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let', SHA2(LOWER(@q67),256), 'single', 'medium', NOW(3), 'active', @src_mdn_let, 'MDN let — Redeclaration', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mdn_let IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q67),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q67),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'SyntaxError vì tên đã được khai báo', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Biến bị ghi đè giá trị', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Tạo biến mới che biến cũ', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Không có gì xảy ra', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q68 := 'Khai báo let ở cấp cao nhất của một script có tạo thuộc tính trên globalThis không?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 64, @admin, @q68, 'Do top-level let declarations create properties on globalThis?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let', SHA2(LOWER(@q68),256), 'single', 'hard', NOW(3), 'active', @src_mdn_let, 'MDN let — globalThis', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mdn_let IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q68),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q68),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Không', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Có', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Chỉ khi ở chế độ strict', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Chỉ trong module', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q69 := 'Một Promise có thể ở những trạng thái nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 64, @admin, @q69, 'What are the possible states of a Promise?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise', SHA2(LOWER(@q69),256), 'single', 'easy', NOW(3), 'active', @src_mdn_promise, 'MDN Promise — ba trạng thái', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mdn_promise IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q69),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q69),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'pending, fulfilled, rejected', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'waiting, done, failed', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'open, closed, error', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'start, running, finished', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q70 := 'Trạng thái pending của Promise nghĩa là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 64, @admin, @q70, 'What does the pending state of a Promise mean?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise', SHA2(LOWER(@q70),256), 'single', 'easy', NOW(3), 'active', @src_mdn_promise, 'MDN Promise — pending', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mdn_promise IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q70),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q70),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Trạng thái ban đầu, chưa fulfilled cũng chưa rejected', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Thao tác đã hoàn thành thành công', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Thao tác đã thất bại', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Promise đã bị hủy', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q71 := 'Promise.all() hoàn thành khi nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 64, @admin, @q71, 'When does Promise.all() fulfill?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise', SHA2(LOWER(@q71),256), 'single', 'medium', NOW(3), 'active', @src_mdn_promise, 'MDN Promise — Promise.all', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mdn_promise IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q71),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q71),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Khi tất cả promise đầu vào đều fulfilled', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Khi promise đầu tiên settled', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Khi tất cả promise đều settled dù thành công hay thất bại', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Khi có ít nhất một promise fulfilled', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q72 := 'Promise.all() bị rejected khi nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 64, @admin, @q72, 'When does Promise.all() reject?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise', SHA2(LOWER(@q72),256), 'single', 'medium', NOW(3), 'active', @src_mdn_promise, 'MDN Promise — Promise.all rejects', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mdn_promise IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q72),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q72),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Khi bất kỳ promise nào bị rejected, với lý do của lần rejected đầu tiên', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Khi tất cả promise đều bị rejected', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Khi quá thời gian chờ', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Promise.all không bao giờ bị rejected', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q73 := 'Promise.allSettled() hoàn thành khi nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 64, @admin, @q73, 'When does Promise.allSettled() fulfill?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise', SHA2(LOWER(@q73),256), 'single', 'medium', NOW(3), 'active', @src_mdn_promise, 'MDN Promise — Promise.allSettled', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mdn_promise IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q73),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q73),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Khi tất cả promise đều đã settled, trả về mảng mô tả kết quả từng promise', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Khi tất cả promise đều fulfilled', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Khi promise đầu tiên settled', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Khi có ít nhất một promise bị rejected', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q74 := 'Promise.race() settled khi nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 64, @admin, @q74, 'When does Promise.race() settle?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise', SHA2(LOWER(@q74),256), 'single', 'medium', NOW(3), 'active', @src_mdn_promise, 'MDN Promise — Promise.race', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mdn_promise IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q74),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q74),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Khi promise đầu tiên settled, mang đúng trạng thái của promise đó', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Khi tất cả promise đều settled', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Khi promise đầu tiên fulfilled, bỏ qua các promise bị rejected', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Khi tất cả promise đều fulfilled', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q75 := 'Khác biệt cốt lõi giữa Promise.all() và Promise.allSettled() là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 64, @admin, @q75, 'What is the core difference between Promise.all() and Promise.allSettled()?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise', SHA2(LOWER(@q75),256), 'single', 'hard', NOW(3), 'active', @src_mdn_promise, 'MDN Promise — so sánh all và allSettled', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_mdn_promise IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q75),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=64 AND content_hash=SHA2(LOWER(@q75),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Promise.all thất bại ngay khi có một promise bị rejected; Promise.allSettled luôn chờ hết và luôn fulfilled', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Hai hàm hoàn toàn giống nhau', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Promise.allSettled chỉ nhận tối đa hai promise', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Promise.all không nhận mảng rỗng', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

-- ===== Hoc phan #59: Lập trình C/C++ (15 cau) =====
SET @q76 := 'RAII là viết tắt của cụm từ nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 59, @admin, @q76, 'What does RAII stand for?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-resource', SHA2(LOWER(@q76),256), 'single', 'easy', NOW(3), 'active', @src_cpp_res, 'C++ Core Guidelines — Resource Management, RAII', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cpp_res IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q76),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q76),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Resource Acquisition Is Initialization', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Runtime Allocation In Initialization', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Resource Allocation In Inheritance', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Reference And Instance Initialization', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q77 := 'Quy tắc P.8 của C++ Core Guidelines phát biểu điều gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 59, @admin, @q77, 'What does rule P.8 of the C++ Core Guidelines state?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-resource', SHA2(LOWER(@q77),256), 'single', 'medium', NOW(3), 'active', @src_cpp_res, 'C++ Core Guidelines — P.8', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cpp_res IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q77),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q77),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Đừng để rò rỉ bất kỳ tài nguyên nào', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Luôn dùng con trỏ thô', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Luôn khai báo biến là const', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Tránh dùng thư viện chuẩn', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q78 := 'Quy tắc I.11 khuyến cáo điều gì về việc chuyển giao quyền sở hữu?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 59, @admin, @q78, 'What does rule I.11 advise about transferring ownership?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-resource', SHA2(LOWER(@q78),256), 'single', 'medium', NOW(3), 'active', @src_cpp_res, 'C++ Core Guidelines — I.11', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cpp_res IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q78),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q78),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Không bao giờ chuyển giao quyền sở hữu bằng con trỏ thô T* hoặc tham chiếu T&', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Luôn chuyển giao quyền sở hữu bằng con trỏ thô', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Chỉ chuyển giao quyền sở hữu qua biến toàn cục', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Quyền sở hữu không cần quan tâm trong C++ hiện đại', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q79 := 'Theo quy tắc F.26, nên dùng kiểu con trỏ thông minh nào khi cần quyền sở hữu độc quyền?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 59, @admin, @q79, 'Per rule F.26, which smart pointer should be used for exclusive ownership?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-resource', SHA2(LOWER(@q79),256), 'single', 'medium', NOW(3), 'active', @src_cpp_res, 'C++ Core Guidelines — F.26', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cpp_res IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q79),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q79),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'unique_ptr', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'shared_ptr', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'weak_ptr', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'auto_ptr', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q80 := 'Theo quy tắc F.27, nên dùng kiểu nào khi nhiều thực thể cùng cần quyền sở hữu?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 59, @admin, @q80, 'Per rule F.27, which type should be used when ownership is shared?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-resource', SHA2(LOWER(@q80),256), 'single', 'medium', NOW(3), 'active', @src_cpp_res, 'C++ Core Guidelines — F.27', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cpp_res IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q80),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q80),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'shared_ptr', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'unique_ptr', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'con trỏ thô', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'tham chiếu', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q81 := 'Quy tắc F.7 khuyến cáo dùng gì cho tham số hàm khi chỉ cần truy cập, không sở hữu?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 59, @admin, @q81, 'Per rule F.7, what should function parameters use for non-owning access?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-resource', SHA2(LOWER(@q81),256), 'single', 'hard', NOW(3), 'active', @src_cpp_res, 'C++ Core Guidelines — F.7', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cpp_res IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q81),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q81),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'T* hoặc T& thay vì con trỏ thông minh', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Luôn dùng shared_ptr', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Luôn dùng unique_ptr', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Luôn truyền theo giá trị', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q82 := 'Khi không thể dùng con trỏ thông minh, C++ Core Guidelines gợi ý chú thích con trỏ sở hữu bằng gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 59, @admin, @q82, 'When smart pointers cannot be used, what annotation do the Guidelines suggest for owning raw pointers?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-resource', SHA2(LOWER(@q82),256), 'single', 'hard', NOW(3), 'active', @src_cpp_res, 'C++ Core Guidelines — owner<T*>', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cpp_res IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q82),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q82),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'owner<T*>', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'holder<T*>', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'managed<T*>', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'unique<T*>', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q83 := 'Quy tắc P.11 khuyến cáo điều gì về các thao tác bộ nhớ mức thấp?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 59, @admin, @q83, 'What does rule P.11 advise about low-level memory operations?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-resource', SHA2(LOWER(@q83),256), 'single', 'hard', NOW(3), 'active', @src_cpp_res, 'C++ Core Guidelines — P.11', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cpp_res IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q83),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q83),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Đóng gói chúng lại thay vì rải rác khắp mã nguồn', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Viết trực tiếp ở mọi nơi cần thiết', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Chỉ dùng trong hàm main', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Luôn thay bằng assembly', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q84 := 'Hai lỗi phổ biến nhất trong C++ mà các quy tắc quản lý tài nguyên nhắm tới là gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 59, @admin, @q84, 'Which two common C++ bugs do the resource management rules aim to eliminate?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-resource', SHA2(LOWER(@q84),256), 'single', 'medium', NOW(3), 'active', @src_cpp_res, 'C++ Core Guidelines — Why this matters', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cpp_res IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q84),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q84),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Rò rỉ tài nguyên và lỗi dùng sau khi giải phóng', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tràn số nguyên và chia cho 0', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Sai chính tả tên biến và thiếu dấu chấm phẩy', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Vòng lặp vô hạn và đệ quy quá sâu', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q85 := 'Quy tắc Con.1 phát biểu điều gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 59, @admin, @q85, 'What does rule Con.1 state?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-const', SHA2(LOWER(@q85),256), 'single', 'medium', NOW(3), 'active', @src_cpp_const, 'C++ Core Guidelines — Con.1', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cpp_const IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q85),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q85),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Mặc định nên làm cho đối tượng bất biến', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Mặc định nên làm cho đối tượng thay đổi được', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Mặc định nên dùng con trỏ thô', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Mặc định nên dùng biến toàn cục', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q86 := 'Quy tắc Con.2 phát biểu điều gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 59, @admin, @q86, 'What does rule Con.2 state?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-const', SHA2(LOWER(@q86),256), 'single', 'medium', NOW(3), 'active', @src_cpp_const, 'C++ Core Guidelines — Con.2', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cpp_const IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q86),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q86),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Mặc định nên khai báo hàm thành viên là const', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Mặc định nên khai báo hàm thành viên là static', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Mặc định nên khai báo hàm thành viên là virtual', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Mặc định nên khai báo hàm thành viên là inline', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q87 := 'Quy tắc Con.3 khuyến cáo truyền đối tượng vào hàm theo cách nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 59, @admin, @q87, 'Per rule Con.3, how should objects be passed to functions by default?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-const', SHA2(LOWER(@q87),256), 'single', 'medium', NOW(3), 'active', @src_cpp_const, 'C++ Core Guidelines — Con.3', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cpp_const IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q87),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q87),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Theo tham chiếu hằng (const reference)', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Theo giá trị', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Theo con trỏ thô', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Theo tham chiếu không hằng', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q88 := 'Quy tắc P.10 giải thích lợi ích của tính bất biến như thế nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 59, @admin, @q88, 'How does rule P.10 justify immutability?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-const', SHA2(LOWER(@q88),256), 'single', 'hard', NOW(3), 'active', @src_cpp_const, 'C++ Core Guidelines — P.10', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cpp_const IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q88),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q88),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Suy luận về hằng dễ hơn suy luận về biến', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Hằng luôn chạy nhanh hơn biến trong mọi trường hợp', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Hằng chiếm ít bộ nhớ hơn biến', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Hằng dễ gỡ lỗi hơn vì có tên rõ ràng', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q89 := 'Ngoài việc dễ suy luận, tính bất biến còn ngăn được vấn đề gì?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 59, @admin, @q89, 'Besides easier reasoning, what problem does immutability prevent entirely?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-const', SHA2(LOWER(@q89),256), 'single', 'hard', NOW(3), 'active', @src_cpp_const, 'C++ Core Guidelines — lợi ích của immutability', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cpp_const IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q89),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q89),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Data race', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Tràn bộ đệm', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Rò rỉ bộ nhớ', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Đệ quy vô hạn', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

SET @q90 := 'Quy tắc F.4 nói về việc dùng constexpr khi nào?';
INSERT INTO questions (subject_id, created_by, content, content_original, original_language, translation_status, translation_refs, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 59, @admin, @q90, 'What does rule F.4 say about using constexpr?', 'en', 'translated', 'Giữ nguyên thuật ngữ và mã định danh theo nguyên bản tiếng Anh, chỉ dịch phần diễn đạt.
Nguyên bản: https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-const', SHA2(LOWER(@q90),256), 'single', 'hard', NOW(3), 'active', @src_cpp_const, 'C++ Core Guidelines — F.4', 'approved', @admin, NOW(3)
WHERE @admin IS NOT NULL AND @src_cpp_const IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS tmp WHERE EXISTS (SELECT 1 FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q90),256)));
SET @qid := (SELECT id FROM questions WHERE subject_id=59 AND content_hash=SHA2(LOWER(@q90),256) LIMIT 1);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'A', 'Dùng cho hàm có thể tính được tại thời điểm biên dịch', 1, 0 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='A'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'B', 'Dùng cho mọi hàm không phân biệt', 0, 1 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='B'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'C', 'Chỉ dùng cho hàm thành viên', 0, 2 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='C'));
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @qid, 'D', 'Chỉ dùng trong thư viện chuẩn', 0, 3 WHERE @qid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM (SELECT 1) AS t2 WHERE EXISTS (SELECT 1 FROM answers WHERE question_id=@qid AND label='D'));

COMMIT;
