-- Truy xuất nguồn và quy trình duyệt câu hỏi.
-- Chạy bằng MySQL/Wamp: mysql -u root quiz_db < 20260807_add_sources_and_review.sql

CREATE TABLE IF NOT EXISTS sources (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publisher VARCHAR(255) NULL,
    url VARCHAR(191) NOT NULL,
    published_year VARCHAR(20) NULL,
    license_note VARCHAR(500) NULL,
    verification_status VARCHAR(20) NOT NULL DEFAULT 'pending',
    created_by BIGINT UNSIGNED NOT NULL,
    created_at DATETIME(3) NULL,
    UNIQUE KEY uk_sources_url (url),
    KEY idx_sources_created_by (created_by)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE questions
    ADD COLUMN source_id BIGINT UNSIGNED NULL,
    ADD COLUMN source_ref VARCHAR(500) NULL,
    ADD COLUMN review_status VARCHAR(20) NOT NULL DEFAULT 'draft',
    ADD COLUMN review_note VARCHAR(500) NULL,
    ADD COLUMN reviewed_by BIGINT UNSIGNED NULL,
    ADD COLUMN reviewed_at DATETIME(3) NULL;

CREATE INDEX idx_questions_source_id ON questions (source_id);
CREATE INDEX idx_questions_review_status ON questions (review_status);

-- Câu cũ không có nguồn được đưa về nháp để không thể dùng trong đề mới.
UPDATE questions
SET status = 'draft', review_status = 'draft'
WHERE source_id IS NULL;
