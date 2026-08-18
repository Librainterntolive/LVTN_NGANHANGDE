-- Noi cot sources.url tu 191 len 250 ky tu.
--
-- Ly do: URL van kien tren tulieuvankien.dangcongsan.vn dai 194 ky tu. MySQL dang
-- chay o che do khong nghiem ngat nen khong bao loi ma AM THAM CAT bot phan duoi,
-- lam link nguon bi hong; cau lenh tra id nguon theo URL day du tra ra NULL, keo
-- theo 30 cau hoi khong duoc chen ma khong co thong bao loi nao.
--
-- Vi sao chi 250 chu khong phai 512: bang sources dang dung engine MyISAM, gioi han
-- do dai khoa la 1000 byte. Voi utf8mb4 (4 byte/ky tu) thi 250 * 4 = 1000 byte la
-- muc toi da con giu duoc khoa unique tren cot url.
--
-- Chay: mysql -u root quiz_db --default-character-set=utf8mb4 < 20260818_widen_source_url.sql

-- Xoa ban ghi nguon co URL da bi cat cut (khong cau hoi nao tro toi).
DELETE FROM sources
WHERE url = 'https://tulieuvankien.dangcongsan.vn/ban-chap-hanh-trung-uong-dang/dai-hoi-dang/lan-thu-xi/cuong-linh-xay-dung-dat-nuoc-trong-thoi-ky-qua-do-len-chu-nghia-xa-hoi-bo-sung-phat-trien-nam-2011-1'
  AND NOT EXISTS (SELECT 1 FROM (SELECT source_id FROM questions) q WHERE q.source_id = sources.id);

ALTER TABLE sources MODIFY COLUMN url VARCHAR(250) NOT NULL;
