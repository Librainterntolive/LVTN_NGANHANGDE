DROP PROCEDURE IF EXISTS ensure_class_query_index;

DELIMITER //
CREATE PROCEDURE ensure_class_query_index(
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

CALL ensure_class_query_index('idx_classes_creator_id', 'classes', '(created_by, id)');
CALL ensure_class_query_index('idx_class_students_student_class', 'class_students', '(student_id, class_id)');
CALL ensure_class_query_index('idx_exam_classes_class_exam', 'exam_classes', '(class_id, exam_id)');

DROP PROCEDURE ensure_class_query_index;
