-- Optional verified data seed for subject 50 (Tin hoc dai cuong).
-- Every question is a paraphrase of the official sources below, not generated sample data.
-- Sources: https://go.dev/doc/tutorial/getting-started and https://go.dev/ref/spec

START TRANSACTION;

SET @admin_id := (SELECT id FROM users WHERE role = 'Admin' AND status = 'active' ORDER BY id LIMIT 1);

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'Tutorial: Get started with Go', 'The Go Programming Language', 'https://go.dev/doc/tutorial/getting-started', '', 'Official documentation; factual questions are paraphrased.', 'verified', @admin_id, NOW(3), @admin_id, NOW(3)
WHERE @admin_id IS NOT NULL
ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id), verification_status = 'verified', reviewed_by = @admin_id, reviewed_at = NOW(3);
SET @tutorial_source_id := (SELECT id FROM sources WHERE url = 'https://go.dev/doc/tutorial/getting-started');

INSERT INTO sources (title, publisher, url, published_year, license_note, verification_status, created_by, created_at, reviewed_by, reviewed_at)
SELECT 'The Go Programming Language Specification', 'The Go Programming Language', 'https://go.dev/ref/spec', '', 'Official language specification; factual questions are paraphrased.', 'verified', @admin_id, NOW(3), @admin_id, NOW(3)
WHERE @admin_id IS NOT NULL
ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id), verification_status = 'verified', reviewed_by = @admin_id, reviewed_at = NOW(3);
SET @spec_source_id := (SELECT id FROM sources WHERE url = 'https://go.dev/ref/spec');

SET @q1 := 'Which command initializes a new Go module named example/hello?';
SET @q2 := 'Which standard-library package is imported in the official Hello World example to format and print text?';
SET @q3 := 'When the main package is run, which function is executed by default?';
SET @q4 := 'Which command runs the current module in the official getting-started tutorial?';
SET @q5 := 'Which command lists available Go commands?';
SET @q6 := 'Which Go statement specifies repeated execution of a block?';
SET @q7 := 'What value does a variable have before it has been assigned a value?';
SET @q8 := 'When ranging over a map with two variables, what is assigned first?';
SET @q9 := 'What is for { } equivalent to according to the Go specification?';
SET @q10 := 'For a slice range with two variables, what does the first variable receive?';

INSERT INTO questions (subject_id, created_by, content, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 50, @admin_id, @q1, SHA2(LOWER(@q1), 256), 'single', 'easy', NOW(3), 'active', @tutorial_source_id, 'Tutorial: Create a module - go mod init example/hello', 'approved', @admin_id, NOW(3)
WHERE @admin_id IS NOT NULL AND @tutorial_source_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q1), 256));
INSERT INTO questions (subject_id, created_by, content, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 50, @admin_id, @q2, SHA2(LOWER(@q2), 256), 'single', 'easy', NOW(3), 'active', @tutorial_source_id, 'Tutorial: Write the code - import fmt', 'approved', @admin_id, NOW(3)
WHERE @admin_id IS NOT NULL AND @tutorial_source_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q2), 256));
INSERT INTO questions (subject_id, created_by, content, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 50, @admin_id, @q3, SHA2(LOWER(@q3), 256), 'single', 'easy', NOW(3), 'active', @tutorial_source_id, 'Tutorial: Write the code - main function', 'approved', @admin_id, NOW(3)
WHERE @admin_id IS NOT NULL AND @tutorial_source_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q3), 256));
INSERT INTO questions (subject_id, created_by, content, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 50, @admin_id, @q4, SHA2(LOWER(@q4), 256), 'single', 'easy', NOW(3), 'active', @tutorial_source_id, 'Tutorial: Run the code - go run .', 'approved', @admin_id, NOW(3)
WHERE @admin_id IS NOT NULL AND @tutorial_source_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q4), 256));
INSERT INTO questions (subject_id, created_by, content, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 50, @admin_id, @q5, SHA2(LOWER(@q5), 256), 'single', 'easy', NOW(3), 'active', @tutorial_source_id, 'Tutorial: Run the code - go help', 'approved', @admin_id, NOW(3)
WHERE @admin_id IS NOT NULL AND @tutorial_source_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q5), 256));
INSERT INTO questions (subject_id, created_by, content, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 50, @admin_id, @q6, SHA2(LOWER(@q6), 256), 'single', 'easy', NOW(3), 'active', @spec_source_id, 'Specification: For statements', 'approved', @admin_id, NOW(3)
WHERE @admin_id IS NOT NULL AND @spec_source_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q6), 256));
INSERT INTO questions (subject_id, created_by, content, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 50, @admin_id, @q7, SHA2(LOWER(@q7), 256), 'single', 'medium', NOW(3), 'active', @spec_source_id, 'Specification: Variables - zero value', 'approved', @admin_id, NOW(3)
WHERE @admin_id IS NOT NULL AND @spec_source_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q7), 256));
INSERT INTO questions (subject_id, created_by, content, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 50, @admin_id, @q8, SHA2(LOWER(@q8), 256), 'single', 'medium', NOW(3), 'active', @spec_source_id, 'Specification: For statements with range clause - iteration values', 'approved', @admin_id, NOW(3)
WHERE @admin_id IS NOT NULL AND @spec_source_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q8), 256));
INSERT INTO questions (subject_id, created_by, content, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 50, @admin_id, @q9, SHA2(LOWER(@q9), 256), 'single', 'medium', NOW(3), 'active', @spec_source_id, 'Specification: For statements with single condition', 'approved', @admin_id, NOW(3)
WHERE @admin_id IS NOT NULL AND @spec_source_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q9), 256));
INSERT INTO questions (subject_id, created_by, content, content_hash, question_type, difficulty, created_at, status, source_id, source_ref, review_status, reviewed_by, reviewed_at)
SELECT 50, @admin_id, @q10, SHA2(LOWER(@q10), 256), 'single', 'medium', NOW(3), 'active', @spec_source_id, 'Specification: For statements with range clause - array or slice', 'approved', @admin_id, NOW(3)
WHERE @admin_id IS NOT NULL AND @spec_source_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q10), 256));

SET @q1_id := (SELECT id FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q1), 256) LIMIT 1);
SET @q2_id := (SELECT id FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q2), 256) LIMIT 1);
SET @q3_id := (SELECT id FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q3), 256) LIMIT 1);
SET @q4_id := (SELECT id FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q4), 256) LIMIT 1);
SET @q5_id := (SELECT id FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q5), 256) LIMIT 1);
SET @q6_id := (SELECT id FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q6), 256) LIMIT 1);
SET @q7_id := (SELECT id FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q7), 256) LIMIT 1);
SET @q8_id := (SELECT id FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q8), 256) LIMIT 1);
SET @q9_id := (SELECT id FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q9), 256) LIMIT 1);
SET @q10_id := (SELECT id FROM questions WHERE subject_id = 50 AND content_hash = SHA2(LOWER(@q10), 256) LIMIT 1);

INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @q1_id, choices.label, choices.content, choices.is_correct, choices.order_index FROM (SELECT 'A' label, 'go mod init example/hello' content, 1 is_correct, 0 order_index UNION ALL SELECT 'B', 'go init example/hello', 0, 1 UNION ALL SELECT 'C', 'go create module example/hello', 0, 2 UNION ALL SELECT 'D', 'go module new example/hello', 0, 3) choices WHERE @q1_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM answers WHERE question_id = @q1_id);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @q2_id, choices.label, choices.content, choices.is_correct, choices.order_index FROM (SELECT 'A' label, 'fmt' content, 1 is_correct, 0 order_index UNION ALL SELECT 'B', 'io', 0, 1 UNION ALL SELECT 'C', 'os', 0, 2 UNION ALL SELECT 'D', 'math', 0, 3) choices WHERE @q2_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM answers WHERE question_id = @q2_id);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @q3_id, choices.label, choices.content, choices.is_correct, choices.order_index FROM (SELECT 'A' label, 'main' AS content, 1 is_correct, 0 order_index UNION ALL SELECT 'B', 'start', 0, 1 UNION ALL SELECT 'C', 'run', 0, 2 UNION ALL SELECT 'D', 'init', 0, 3) choices WHERE @q3_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM answers WHERE question_id = @q3_id);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @q4_id, choices.label, choices.content, choices.is_correct, choices.order_index FROM (SELECT 'A' label, 'go run .' AS content, 1 is_correct, 0 order_index UNION ALL SELECT 'B', 'go build .', 0, 1 UNION ALL SELECT 'C', 'go execute .', 0, 2 UNION ALL SELECT 'D', 'go start .', 0, 3) choices WHERE @q4_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM answers WHERE question_id = @q4_id);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @q5_id, choices.label, choices.content, choices.is_correct, choices.order_index FROM (SELECT 'A' label, 'go help' AS content, 1 is_correct, 0 order_index UNION ALL SELECT 'B', 'go list', 0, 1 UNION ALL SELECT 'C', 'go commands', 0, 2 UNION ALL SELECT 'D', 'go info', 0, 3) choices WHERE @q5_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM answers WHERE question_id = @q5_id);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @q6_id, choices.label, choices.content, choices.is_correct, choices.order_index FROM (SELECT 'A' label, 'for' AS content, 1 is_correct, 0 order_index UNION ALL SELECT 'B', 'repeat', 0, 1 UNION ALL SELECT 'C', 'loop', 0, 2 UNION ALL SELECT 'D', 'while', 0, 3) choices WHERE @q6_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM answers WHERE question_id = @q6_id);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @q7_id, choices.label, choices.content, choices.is_correct, choices.order_index FROM (SELECT 'A' label, 'The zero value for its type' AS content, 1 is_correct, 0 order_index UNION ALL SELECT 'B', 'Always null', 0, 1 UNION ALL SELECT 'C', 'Always undefined', 0, 2 UNION ALL SELECT 'D', 'The value of the previous variable', 0, 3) choices WHERE @q7_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM answers WHERE question_id = @q7_id);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @q8_id, choices.label, choices.content, choices.is_correct, choices.order_index FROM (SELECT 'A' label, 'The key' AS content, 1 is_correct, 0 order_index UNION ALL SELECT 'B', 'The value', 0, 1 UNION ALL SELECT 'C', 'The map length', 0, 2 UNION ALL SELECT 'D', 'The address of the map', 0, 3) choices WHERE @q8_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM answers WHERE question_id = @q8_id);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @q9_id, choices.label, choices.content, choices.is_correct, choices.order_index FROM (SELECT 'A' label, 'for true { }' AS content, 1 is_correct, 0 order_index UNION ALL SELECT 'B', 'for false { }', 0, 1 UNION ALL SELECT 'C', 'while true { }', 0, 2 UNION ALL SELECT 'D', 'repeat { }', 0, 3) choices WHERE @q9_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM answers WHERE question_id = @q9_id);
INSERT INTO answers (question_id, label, content, is_correct, order_index)
SELECT @q10_id, choices.label, choices.content, choices.is_correct, choices.order_index FROM (SELECT 'A' label, 'The index' AS content, 1 is_correct, 0 order_index UNION ALL SELECT 'B', 'The element value only', 0, 1 UNION ALL SELECT 'C', 'The slice capacity', 0, 2 UNION ALL SELECT 'D', 'The memory address', 0, 3) choices WHERE @q10_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM answers WHERE question_id = @q10_id);

SET @exam_title := 'Tin hoc dai cuong - Go basics (official documentation)';
INSERT INTO exams (subject_id, created_by, title, description, duration, pass_score, shuffle, shuffle_answers, shuffle_mode, access_type, max_attempts, status, created_at)
SELECT 50, @admin_id, @exam_title, 'Ten factual questions paraphrased from official go.dev documentation.', 20, 5, 1, 1, 'per_student', 'public', 0, 'published', NOW(3)
WHERE @admin_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM exams WHERE title = @exam_title);
SET @exam_id := (SELECT id FROM exams WHERE title = @exam_title ORDER BY id DESC LIMIT 1);

INSERT INTO exam_questions (exam_id, question_id, order_index, points)
SELECT @exam_id, questions.id, order_list.order_index, 1
FROM questions
JOIN (SELECT SHA2(LOWER(@q1), 256) content_hash, 0 order_index UNION ALL SELECT SHA2(LOWER(@q2), 256), 1 UNION ALL SELECT SHA2(LOWER(@q3), 256), 2 UNION ALL SELECT SHA2(LOWER(@q4), 256), 3 UNION ALL SELECT SHA2(LOWER(@q5), 256), 4 UNION ALL SELECT SHA2(LOWER(@q6), 256), 5 UNION ALL SELECT SHA2(LOWER(@q7), 256), 6 UNION ALL SELECT SHA2(LOWER(@q8), 256), 7 UNION ALL SELECT SHA2(LOWER(@q9), 256), 8 UNION ALL SELECT SHA2(LOWER(@q10), 256), 9) order_list ON order_list.content_hash = questions.content_hash
WHERE @exam_id IS NOT NULL AND questions.subject_id = 50 AND NOT EXISTS (SELECT 1 FROM exam_questions WHERE exam_id = @exam_id AND question_id = questions.id);

COMMIT;
