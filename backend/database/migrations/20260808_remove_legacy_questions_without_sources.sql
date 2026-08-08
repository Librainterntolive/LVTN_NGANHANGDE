-- Legacy development questions without any source are not valid thesis data.
-- Keep all questions that have a declared source, including sources awaiting review.

DELETE sd
FROM submission_details sd
JOIN questions q ON q.id = sd.question_id
WHERE q.source_id IS NULL;

DELETE eq
FROM exam_questions eq
JOIN questions q ON q.id = eq.question_id
WHERE q.source_id IS NULL;

DELETE a
FROM answers a
JOIN questions q ON q.id = a.question_id
WHERE q.source_id IS NULL;

DELETE FROM questions
WHERE source_id IS NULL;

-- The legacy draft exams are empty after their non-traceable questions are removed.
DELETE sd
FROM submission_details sd
JOIN submissions s ON s.id = sd.submission_id
LEFT JOIN exam_questions eq ON eq.exam_id = s.exam_id
WHERE eq.exam_id IS NULL;

DELETE s
FROM submissions s
LEFT JOIN exam_questions eq ON eq.exam_id = s.exam_id
WHERE eq.exam_id IS NULL;

DELETE ec
FROM exam_classes ec
LEFT JOIN exam_questions eq ON eq.exam_id = ec.exam_id
WHERE eq.exam_id IS NULL;

DELETE fe
FROM folder_exams fe
LEFT JOIN exam_questions eq ON eq.exam_id = fe.exam_id
WHERE eq.exam_id IS NULL;

DELETE e
FROM exams e
LEFT JOIN exam_questions eq ON eq.exam_id = e.id
WHERE eq.exam_id IS NULL;
