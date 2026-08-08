-- Don du lieu thu nghiem con sot lai tu giai doan phat trien.
--
-- Nguyen tac: he thong chi luu du lieu that. Cac lop va tai khoan duoi day duoc
-- tao ra de thu chuc nang trong luc lam do an (ten khong dau, email rac nhu
-- dia chi email vo nghia), khong phai lop hoc va sinh vien co that.
--
-- AN TOAN:
--   - Da sao luu CSDL truoc khi chay (backend/backups/quiz_db-20260808-134621.sql).
--   - Khong dong toi tai khoan admin (dang giu 20 cau hoi, 1 de thi, 2 nguon)
--     va tai khoan gv01 (tai khoan Teacher duy nhat).
--   - Cac tai khoan bi xoa deu KHONG so huu cau hoi, de thi, nguon hay lop nao.
--     Neu mot tai khoan bat ngo con giu du lieu, khoa ngoai NO ACTION se chan
--     lenh xoa lai thay vi xoa lan sang du lieu that.
--   - Xoa lop se tu dong go class_students va exam_classes (ON DELETE CASCADE).

START TRANSACTION;

-- 1) Cac lop thu nghiem: Lop CNTT1, Lop Test Ma, Lop cua GV01, KIEM THU,
--    Lop ON CHUNG, test. Xoa theo ma lop cho chac chan, khong theo id.
DELETE FROM classes
WHERE code IN ('LOP001', 'KZ5KKH', 'SL8LGD', 'S5ZXZV', 'NZC7RE', 'ED2547');

-- 2) Cac tai khoan thu nghiem khong so huu bat ky du lieu nao.
--    Dieu kien NOT EXISTS la lop bao ve thu hai: neu tai khoan da kip tao
--    cau hoi / de thi / nguon / lop that thi se duoc giu lai.
DELETE u FROM users u
WHERE u.username IN ('sv01', 'minhtu', 'Tu08', 'sv001', 'sv002', 'sv003', 'sv004', 'admin1', 'admin2')
  AND u.role <> 'Admin'
  AND NOT EXISTS (SELECT 1 FROM questions   q  WHERE q.created_by  = u.id)
  AND NOT EXISTS (SELECT 1 FROM exams       e  WHERE e.created_by  = u.id)
  AND NOT EXISTS (SELECT 1 FROM classes     c  WHERE c.created_by  = u.id)
  AND NOT EXISTS (SELECT 1 FROM sources     s  WHERE s.created_by  = u.id)
  AND NOT EXISTS (SELECT 1 FROM submissions sb WHERE sb.user_id    = u.id);

COMMIT;

-- Kiem tra sau khi chay:
--   SELECT id, username, role FROM users ORDER BY id;
--   SELECT id, name, code FROM classes ORDER BY id;
--   SELECT COUNT(*) FROM questions;  -- phai van la 20
--   SELECT COUNT(*) FROM sources;    -- phai van la 2
