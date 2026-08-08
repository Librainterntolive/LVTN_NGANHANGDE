-- Luu song song hai ban cho moi cau hoi:
--   1. Ban goc  : nguyen van / dien giai bang ngon ngu cua tai lieu nguon.
--   2. Ban hien thi: tieng Viet, la ban dich hoac dien giai co dan chung.
--
-- Muc dich: khi bao ve de tai phai chi ra duoc cau hoi tieng Viet bat nguon tu
-- dau, va cach dich thuat ngu dua tren nguon nao cong nhan. Khong chap nhan
-- ban dich tu bia ra.
--
-- questions.content         = ban HIEN THI cho nguoi hoc (tieng Viet).
-- questions.content_original = ban GOC theo ngon ngu nguon.

ALTER TABLE questions
  ADD COLUMN content_original TEXT NULL
    COMMENT 'Nguyen van hoac dien giai bang ngon ngu cua tai lieu nguon' AFTER content,
  ADD COLUMN original_language VARCHAR(10) NULL
    COMMENT 'Ma ngon ngu cua ban goc, vi du en, vi' AFTER content_original,
  ADD COLUMN translation_status VARCHAR(20) NOT NULL DEFAULT 'original'
    COMMENT 'original = soan thang bang tieng Viet; translated = dich/dien giai tu ban goc' AFTER original_language,
  ADD COLUMN translation_refs VARCHAR(1000) NULL
    COMMENT 'Cac nguon cong nhan cach dich thuat ngu, ngan cach bang dau xuong dong' AFTER translation_status;

ALTER TABLE answers
  ADD COLUMN content_original TEXT NULL
    COMMENT 'Noi dung dap an theo ngon ngu ban goc' AFTER content;

-- 20 cau hoi hien co duoc soan truc tiep bang tieng Anh tu tai lieu go.dev.
-- Chung la BAN GOC, chua co ban dich tieng Viet: chuyen content sang
-- content_original va danh dau ngon ngu nguon la tieng Anh.
UPDATE questions
SET content_original = content,
    original_language = 'en',
    translation_status = 'original'
WHERE content_original IS NULL
  AND source_id IN (SELECT id FROM sources WHERE url LIKE 'https://go.dev/%');

UPDATE answers a
JOIN questions q ON q.id = a.question_id
SET a.content_original = a.content
WHERE a.content_original IS NULL
  AND q.original_language = 'en';
