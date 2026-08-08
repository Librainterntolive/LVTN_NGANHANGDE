-- Tối ưu phát hiện câu hỏi trùng khi tạo/import dữ liệu lớn.
-- content_hash là SHA-256 của nội dung đã chuẩn hóa (bỏ khoảng trắng thừa, không phân biệt hoa thường).

DROP PROCEDURE IF EXISTS ensure_question_content_hash;

DELIMITER //
CREATE PROCEDURE ensure_question_content_hash()
BEGIN
    DECLARE column_exists INT DEFAULT 0;
    DECLARE index_exists INT DEFAULT 0;

    SELECT COUNT(*) INTO column_exists
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'questions'
      AND column_name = 'content_hash';

    IF column_exists = 0 THEN
        ALTER TABLE questions ADD COLUMN content_hash CHAR(64) NULL AFTER content;
    END IF;

    UPDATE questions
    SET content_hash = SHA2(
        LOWER(REGEXP_REPLACE(TRIM(content), '[[:space:]]+', ' ')),
        256
    )
    WHERE content_hash IS NULL OR content_hash = '';

    SELECT COUNT(*) INTO index_exists
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'questions'
      AND index_name = 'idx_questions_subject_content_hash';

    IF index_exists = 0 THEN
        CREATE INDEX idx_questions_subject_content_hash
            ON questions (subject_id, content_hash);
    END IF;
END //
DELIMITER ;

CALL ensure_question_content_hash();
DROP PROCEDURE ensure_question_content_hash;
