CREATE TABLE password_reset_requests (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'pending',
  created_at DATETIME(3) NULL,
  approved_at DATETIME NULL,
  INDEX idx_password_reset_requests_user (user_id),
  INDEX idx_password_reset_requests_status (status)
);
