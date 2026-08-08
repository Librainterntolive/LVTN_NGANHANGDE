-- Chỉ mục phục vụ phân trang và lọc dữ liệu khi ngân hàng đề có quy mô lớn.
-- Chạy an toàn nhiều lần trên MySQL/WampServer: chỉ tạo chỉ mục khi chưa tồn tại.

DROP PROCEDURE IF EXISTS ensure_quiz_index;

DELIMITER //
CREATE PROCEDURE ensure_quiz_index(
    IN input_index_name VARCHAR(64),
    IN input_table_name VARCHAR(64),
    IN input_columns VARCHAR(255)
)
BEGIN
    DECLARE existing_indexes INT DEFAULT 0;

    SELECT COUNT(*) INTO existing_indexes
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = input_table_name
      AND index_name = input_index_name;

    IF existing_indexes = 0 THEN
        SET @index_sql = CONCAT(
            'CREATE INDEX `', input_index_name, '` ON `', input_table_name, '` ', input_columns
        );
        PREPARE index_statement FROM @index_sql;
        EXECUTE index_statement;
        DEALLOCATE PREPARE index_statement;
    END IF;
END //
DELIMITER ;

CALL ensure_quiz_index('idx_questions_subject_filters', 'questions', '(subject_id, status, review_status, difficulty, chapter_id)');
CALL ensure_quiz_index('idx_questions_subject_creator', 'questions', '(subject_id, created_by, id)');
CALL ensure_quiz_index('idx_exams_owner_subject', 'exams', '(created_by, subject_id, id)');
CALL ensure_quiz_index('idx_exams_public_listing', 'exams', '(status, access_type, subject_id, id)');
CALL ensure_quiz_index('idx_submissions_exam_user_status', 'submissions', '(exam_id, user_id, status, id)');
CALL ensure_quiz_index('idx_submissions_user_recent', 'submissions', '(user_id, id)');

DROP PROCEDURE ensure_quiz_index;
