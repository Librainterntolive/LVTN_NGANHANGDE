-- A published exam must contain at least one active, approved question
-- and every question must have a verified source.
UPDATE exams
SET status = 'draft', access_type = 'private'
WHERE status = 'published'
  AND (
    NOT EXISTS (
      SELECT 1
      FROM exam_questions
      WHERE exam_questions.exam_id = exams.id
    )
    OR EXISTS (
      SELECT 1
      FROM exam_questions
      LEFT JOIN questions ON questions.id = exam_questions.question_id
      LEFT JOIN sources ON sources.id = questions.source_id
      WHERE exam_questions.exam_id = exams.id
        AND (
          questions.id IS NULL
          OR questions.status <> 'active'
          OR questions.review_status <> 'approved'
          OR sources.id IS NULL
          OR sources.verification_status <> 'verified'
        )
    )
  );
