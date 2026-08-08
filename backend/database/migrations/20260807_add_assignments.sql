CREATE TABLE assignments (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  class_id BIGINT UNSIGNED NOT NULL,
  created_by BIGINT UNSIGNED NOT NULL,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  due_at DATETIME NOT NULL,
  late_until DATETIME NULL,
  max_score DOUBLE NOT NULL DEFAULT 10,
  status VARCHAR(20) NOT NULL DEFAULT 'published',
  created_at DATETIME(3) NULL,
  updated_at DATETIME(3) NULL,
  INDEX idx_assignments_class_due (class_id, due_at)
);

CREATE TABLE assignment_submissions (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  assignment_id BIGINT UNSIGNED NOT NULL,
  student_id BIGINT UNSIGNED NOT NULL,
  stored_name VARCHAR(100) NOT NULL,
  original_name VARCHAR(255) NOT NULL,
  mime_type VARCHAR(120) NOT NULL,
  size BIGINT NOT NULL,
  status VARCHAR(20) NOT NULL,
  submitted_at DATETIME NOT NULL,
  score DOUBLE NULL,
  feedback TEXT,
  graded_at DATETIME NULL,
  UNIQUE KEY idx_assignment_student (assignment_id, student_id),
  INDEX idx_assignment_submissions_assignment (assignment_id)
);

CREATE TABLE upload_sessions (
  id VARCHAR(64) PRIMARY KEY,
  assignment_id BIGINT UNSIGNED NOT NULL,
  student_id BIGINT UNSIGNED NOT NULL,
  original_name VARCHAR(255) NOT NULL,
  mime_type VARCHAR(120) NOT NULL,
  total_size BIGINT NOT NULL,
  chunk_size BIGINT NOT NULL,
  total_chunks INT NOT NULL,
  expires_at DATETIME NOT NULL,
  created_at DATETIME(3) NULL,
  INDEX idx_upload_sessions_expiry (expires_at)
);
