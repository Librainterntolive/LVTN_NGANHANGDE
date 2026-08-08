-- Tối ưu danh sách cuộn vô hạn: chỉ mục kết hợp điều kiện lọc và thứ tự id DESC.
-- Chạy lại an toàn trên MySQL/WampServer.

DROP PROCEDURE IF EXISTS ensure_recent_listing_index;

DELIMITER //
CREATE PROCEDURE ensure_recent_listing_index(
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

CALL ensure_recent_listing_index('idx_questions_subject_review_recent', 'questions', '(subject_id, review_status, id)');
CALL ensure_recent_listing_index('idx_exams_public_recent', 'exams', '(status, access_type, id)');

DROP PROCEDURE ensure_recent_listing_index;
