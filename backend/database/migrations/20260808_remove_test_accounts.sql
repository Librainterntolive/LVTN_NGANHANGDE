START TRANSACTION;

DELETE submission_details
FROM submission_details
JOIN submissions ON submissions.id = submission_details.submission_id
JOIN users ON users.id = submissions.user_id
WHERE users.email LIKE '%@test.local';

DELETE submissions
FROM submissions
JOIN users ON users.id = submissions.user_id
WHERE users.email LIKE '%@test.local';

DELETE assignment_submissions
FROM assignment_submissions
JOIN users ON users.id = assignment_submissions.student_id
WHERE users.email LIKE '%@test.local';

DELETE FROM upload_sessions
WHERE student_id IN (SELECT id FROM users WHERE email LIKE '%@test.local');

DELETE folder_exams
FROM folder_exams
JOIN folders ON folders.id = folder_exams.folder_id
JOIN users ON users.id = folders.user_id
WHERE users.email LIKE '%@test.local';

DELETE FROM folders
WHERE user_id IN (SELECT id FROM users WHERE email LIKE '%@test.local');

DELETE FROM class_students
WHERE student_id IN (SELECT id FROM users WHERE email LIKE '%@test.local');

DELETE FROM email_otps
WHERE user_id IN (SELECT id FROM users WHERE email LIKE '%@test.local');

DELETE FROM password_reset_requests
WHERE user_id IN (SELECT id FROM users WHERE email LIKE '%@test.local');

DELETE FROM audit_logs
WHERE actor_user_id IN (SELECT id FROM users WHERE email LIKE '%@test.local');

DELETE FROM users
WHERE email LIKE '%@test.local';

COMMIT;
