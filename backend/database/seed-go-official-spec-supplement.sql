-- Supplemental verified seed for subject 50 (Tin hoc dai cuong).
-- Run database/seed-go-official-basics.sql first.
-- Every question below is a factual paraphrase of https://go.dev/ref/spec.

START TRANSACTION;

SET @admin_id := (SELECT id FROM users WHERE role = 'Admin' AND status = 'active' ORDER BY id LIMIT 1);
SET @spec_source_id := (SELECT id FROM sources WHERE url = 'https://go.dev/ref/spec' AND verification_status = 'verified' LIMIT 1);
SET @exam_id := (SELECT id FROM exams WHERE title = 'Tin hoc dai cuong - Go basics (official documentation)' ORDER BY id DESC LIMIT 1);

SET @q11 := 'Which token is used for a Go short variable declaration?';
SET @q12 := 'Where may Go short variable declarations appear?';
SET @q13 := 'When is a function call scheduled with defer invoked?';
SET @q14 := 'In what order are multiple deferred function calls invoked?';
SET @q15 := 'What is true about the contents of a Go string after it is created?';
SET @q16 := 'Which character encoding is required for Go source text?';
SET @q17 := 'Which prefix denotes a binary integer literal in Go?';
SET @q18 := 'What default type does the untyped integer constant have in i := 0?';
SET @q19 := 'In a range over a string with two iteration variables, what does the second variable receive?';
SET @q20 := 'How many iterations does a range loop perform over a nil slice?';

INSERT INTO questions (subject_id, created_by, content, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 50, @admin_id, seed.content, SHA2(LOWER(seed.content), 256), 'single', seed.difficulty, NOW(3), 'active', @spec_source_id, seed.source_ref, 'approved', @admin_id, NOW(3)
FROM (
  SELECT @q11 AS content, 'easy' AS difficulty, 'Specification: Short variable declarations' AS source_ref
  UNION ALL SELECT @q12, 'medium', 'Specification: Short variable declarations'
  UNION ALL SELECT @q13, 'medium', 'Specification: Defer statements'
  UNION ALL SELECT @q14, 'medium', 'Specification: Defer statements'
  UNION ALL SELECT @q15, 'easy', 'Specification: String types'
  UNION ALL SELECT @q16, 'easy', 'Specification: Source code representation'
  UNION ALL SELECT @q17, 'medium', 'Specification: Integer literals'
  UNION ALL SELECT @q18, 'medium', 'Specification: Constants - default types'
  UNION ALL SELECT @q19, 'medium', 'Specification: For statements with range clause - iteration values'
  UNION ALL SELECT @q20, 'medium', 'Specification: For statements with range clause - array or slice'
) AS seed
WHERE @admin_id IS NOT NULL
  AND @spec_source_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM questions
    WHERE subject_id = 50 AND content_hash = SHA2(LOWER(seed.content), 256)
  );

INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT questions.id, choices.label, choices.content, choices.is_correct, choices.order_index
FROM (
  SELECT @q11 AS question, 'A' AS label, ':=' AS content, 1 AS is_correct, 0 AS order_index UNION ALL
  SELECT @q11, 'B', '=', 0, 1 UNION ALL SELECT @q11, 'C', '::=', 0, 2 UNION ALL SELECT @q11, 'D', '=>', 0, 3 UNION ALL
  SELECT @q12, 'A', 'Only inside functions', 1, 0 UNION ALL SELECT @q12, 'B', 'Only at package level', 0, 1 UNION ALL SELECT @q12, 'C', 'Only inside struct declarations', 0, 2 UNION ALL SELECT @q12, 'D', 'Anywhere a variable name appears', 0, 3 UNION ALL
  SELECT @q13, 'A', 'Immediately before the surrounding function returns', 1, 0 UNION ALL SELECT @q13, 'B', 'At the start of the surrounding function', 0, 1 UNION ALL SELECT @q13, 'C', 'At the next garbage collection cycle', 0, 2 UNION ALL SELECT @q13, 'D', 'Only after program termination', 0, 3 UNION ALL
  SELECT @q14, 'A', 'Reverse order of defer statements', 1, 0 UNION ALL SELECT @q14, 'B', 'Source-file order', 0, 1 UNION ALL SELECT @q14, 'C', 'Alphabetical function-name order', 0, 2 UNION ALL SELECT @q14, 'D', 'Random order', 0, 3 UNION ALL
  SELECT @q15, 'A', 'They cannot be changed', 1, 0 UNION ALL SELECT @q15, 'B', 'They can be changed one byte at a time', 0, 1 UNION ALL SELECT @q15, 'C', 'They always contain Unicode runes only', 0, 2 UNION ALL SELECT @q15, 'D', 'They always end with a null byte', 0, 3 UNION ALL
  SELECT @q16, 'A', 'UTF-8', 1, 0 UNION ALL SELECT @q16, 'B', 'UTF-16', 0, 1 UNION ALL SELECT @q16, 'C', 'ASCII only', 0, 2 UNION ALL SELECT @q16, 'D', 'ISO-8859-1', 0, 3 UNION ALL
  SELECT @q17, 'A', '0b or 0B', 1, 0 UNION ALL SELECT @q17, 'B', '0d or 0D', 0, 1 UNION ALL SELECT @q17, 'C', '0n or 0N', 0, 2 UNION ALL SELECT @q17, 'D', 'b0', 0, 3 UNION ALL
  SELECT @q18, 'A', 'int', 1, 0 UNION ALL SELECT @q18, 'B', 'int64', 0, 1 UNION ALL SELECT @q18, 'C', 'float64', 0, 2 UNION ALL SELECT @q18, 'D', 'byte', 0, 3 UNION ALL
  SELECT @q19, 'A', 'A rune', 1, 0 UNION ALL SELECT @q19, 'B', 'A byte offset only', 0, 1 UNION ALL SELECT @q19, 'C', 'A string slice', 0, 2 UNION ALL SELECT @q19, 'D', 'The string capacity', 0, 3 UNION ALL
  SELECT @q20, 'A', 'Zero', 1, 0 UNION ALL SELECT @q20, 'B', 'One', 0, 1 UNION ALL SELECT @q20, 'C', 'The slice capacity', 0, 2 UNION ALL SELECT @q20, 'D', 'It panics before iterating', 0, 3
) AS choices
JOIN questions ON questions.subject_id = 50 AND questions.content_hash = SHA2(LOWER(choices.question), 256)
WHERE NOT EXISTS (SELECT 1 FROM answers WHERE question_id = questions.id);

INSERT INTO exam_questions (exam_id, question_id, order_index, points)
SELECT @exam_id, questions.id, ordering.order_index, 1
FROM (
  SELECT @q11 AS content, 10 AS order_index UNION ALL SELECT @q12, 11 UNION ALL
  SELECT @q13, 12 UNION ALL SELECT @q14, 13 UNION ALL SELECT @q15, 14 UNION ALL
  SELECT @q16, 15 UNION ALL SELECT @q17, 16 UNION ALL SELECT @q18, 17 UNION ALL
  SELECT @q19, 18 UNION ALL SELECT @q20, 19
) AS ordering
JOIN questions ON questions.subject_id = 50 AND questions.content_hash = SHA2(LOWER(ordering.content), 256)
WHERE @exam_id IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM exam_questions WHERE exam_id = @exam_id AND question_id = questions.id);

COMMIT;
