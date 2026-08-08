START TRANSACTION;

DELETE submission_details
FROM submission_details
JOIN submissions ON submissions.id = submission_details.submission_id
JOIN exams ON exams.id = submissions.exam_id
WHERE exams.title = 'De thi thu cho khach (Demo)' OR exams.title = 'sdad' OR exams.title LIKE 'sdad (% sao)' OR exams.title = 'test' OR exams.title LIKE 'test (% sao)';

DELETE submissions
FROM submissions
JOIN exams ON exams.id = submissions.exam_id
WHERE exams.title = 'De thi thu cho khach (Demo)' OR exams.title = 'sdad' OR exams.title LIKE 'sdad (% sao)' OR exams.title = 'test' OR exams.title LIKE 'test (% sao)';

DELETE exam_questions
FROM exam_questions
JOIN exams ON exams.id = exam_questions.exam_id
WHERE exams.title = 'De thi thu cho khach (Demo)' OR exams.title = 'sdad' OR exams.title LIKE 'sdad (% sao)' OR exams.title = 'test' OR exams.title LIKE 'test (% sao)';

DELETE exam_classes
FROM exam_classes
JOIN exams ON exams.id = exam_classes.exam_id
WHERE exams.title = 'De thi thu cho khach (Demo)' OR exams.title = 'sdad' OR exams.title LIKE 'sdad (% sao)' OR exams.title = 'test' OR exams.title LIKE 'test (% sao)';

DELETE folder_exams
FROM folder_exams
JOIN exams ON exams.id = folder_exams.exam_id
WHERE exams.title = 'De thi thu cho khach (Demo)' OR exams.title = 'sdad' OR exams.title LIKE 'sdad (% sao)' OR exams.title = 'test' OR exams.title LIKE 'test (% sao)';

DELETE FROM exams
WHERE title = 'De thi thu cho khach (Demo)' OR title = 'sdad' OR title LIKE 'sdad (% sao)' OR title = 'test' OR title LIKE 'test (% sao)';

COMMIT;
