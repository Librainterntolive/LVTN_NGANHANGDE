-- =====================================================================
-- Tạo 2 đề thi cho mỗi môn Đại học từ ngân hàng câu hỏi đã nạp:
--   Đề 1 - Giữa kỳ : 20 câu, 45 phút, đạt từ 5.0
--   Đề 2 - Cuối kỳ : 30 câu, 60 phút, đạt từ 5.0
-- Câu hỏi được bốc ngẫu nhiên trong ngân hàng của chính môn đó.
--
-- Chạy: mysql -u root quiz_db < tao-de-thi.sql
-- Chạy lại nhiều lần sẽ tạo thêm đề mới, muốn làm lại thì xóa đề cũ trước:
--   DELETE FROM exams WHERE title LIKE '%- Đề %kỳ%';
-- =====================================================================
SET NAMES utf8mb4;

DROP PROCEDURE IF EXISTS tao_de_thi;
DELIMITER $$

CREATE PROCEDURE tao_de_thi()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_sid INT;
    DECLARE v_ten VARCHAR(150);
    DECLARE v_so_cau INT;
    DECLARE cur CURSOR FOR
        SELECT id, name FROM subjects WHERE level = 'Đại học' AND hidden = 0 ORDER BY id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    doi_mon: LOOP
        FETCH cur INTO v_sid, v_ten;
        IF done = 1 THEN LEAVE doi_mon; END IF;

        SELECT COUNT(*) INTO v_so_cau FROM questions
        WHERE subject_id = v_sid AND status = 'active';

        -- Bỏ qua môn chưa đủ câu hỏi
        IF v_so_cau >= 30 THEN

            -- ===== Đề giữa kỳ: 20 câu, 45 phút =====
            INSERT INTO exams (subject_id, created_by, title, description, start_time, end_time,
                               duration, pass_score, shuffle, shuffle_answers, shuffle_mode,
                               access_type, max_attempts, status, created_at)
            VALUES (v_sid, 1, CONCAT(v_ten, ' - Đề giữa kỳ'),
                    CONCAT('Đề kiểm tra giữa kỳ môn ', v_ten, ' - 20 câu trắc nghiệm'),
                    '0000-00-00 00:00:00', '0000-00-00 00:00:00',
                    45, 5.0, 1, 1, 'per_student', 'public', 0, 'published', NOW());
            SET @eid = LAST_INSERT_ID();
            SET @i = 0;
            INSERT INTO exam_questions (exam_id, question_id, order_index, points)
            SELECT @eid, id, (@i := @i + 1) - 1, 1 FROM (
                SELECT id FROM questions
                WHERE subject_id = v_sid AND status = 'active'
                ORDER BY RAND() LIMIT 20
            ) t;

            -- ===== Đề cuối kỳ: 30 câu, 60 phút =====
            INSERT INTO exams (subject_id, created_by, title, description, start_time, end_time,
                               duration, pass_score, shuffle, shuffle_answers, shuffle_mode,
                               access_type, max_attempts, status, created_at)
            VALUES (v_sid, 1, CONCAT(v_ten, ' - Đề cuối kỳ'),
                    CONCAT('Đề thi kết thúc học phần môn ', v_ten, ' - 30 câu trắc nghiệm'),
                    '0000-00-00 00:00:00', '0000-00-00 00:00:00',
                    60, 5.0, 1, 1, 'per_student', 'public', 0, 'published', NOW());
            SET @eid = LAST_INSERT_ID();
            SET @i = 0;
            INSERT INTO exam_questions (exam_id, question_id, order_index, points)
            SELECT @eid, id, (@i := @i + 1) - 1, 1 FROM (
                SELECT id FROM questions
                WHERE subject_id = v_sid AND status = 'active'
                ORDER BY RAND() LIMIT 30
            ) t;

        END IF;
    END LOOP;
    CLOSE cur;
END$$

DELIMITER ;

CALL tao_de_thi();
DROP PROCEDURE tao_de_thi;

-- Kết quả
SELECT s.name AS mon, COUNT(e.id) AS so_de
FROM subjects s LEFT JOIN exams e ON e.subject_id = s.id
WHERE s.level = 'Đại học' AND s.hidden = 0
GROUP BY s.id ORDER BY s.id;
