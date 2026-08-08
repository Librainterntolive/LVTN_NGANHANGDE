ALTER TABLE email_otps
  ADD COLUMN purpose VARCHAR(30) NOT NULL DEFAULT 'registration' AFTER user_id,
  ADD INDEX idx_email_otps_user_purpose (user_id, purpose);
