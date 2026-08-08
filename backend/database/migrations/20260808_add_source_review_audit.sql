-- Lưu vết Admin đã xác thực/từ chối nguồn và thời điểm thực hiện.
ALTER TABLE sources
    ADD COLUMN reviewed_by BIGINT UNSIGNED NULL,
    ADD COLUMN reviewed_at DATETIME(3) NULL;
