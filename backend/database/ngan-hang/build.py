# -*- coding: utf-8 -*-
"""
Sinh dữ liệu ngân hàng câu hỏi cho các môn Đại học.

Chạy:  python build.py

Sinh ra 3 thứ trong thư mục out/:
  - <ten-mon>.csv / .xlsx : file import theo đúng mẫu của hệ thống
  - seed-cau-hoi.sql      : nạp thẳng toàn bộ câu hỏi + đáp án vào CSDL
  - seed-de-thi.sql       : tạo 2 đề cho mỗi môn từ ngân hàng vừa nạp

Dữ liệu câu hỏi nằm trong các file mon_*.py, mỗi file một nhóm môn.
Mỗi câu là một tuple: (nội dung, A, B, C, D, đáp án đúng, độ khó)
"""
import csv
import glob
import importlib
import os
import sys
import unicodedata

from openpyxl import Workbook

# Console Windows mặc định là cp1252, không in được tiếng Việt
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, 'out')
HEADER = ['subject_id', 'content', 'A', 'B', 'C', 'D', 'correct', 'difficulty']

# Tự nạp mọi file mon_*.py trong thư mục này -> {tên môn: [câu hỏi, ...]}
BANKS = {}
for path in sorted(glob.glob(os.path.join(HERE, 'mon_*.py'))):
    mod = importlib.import_module(os.path.splitext(os.path.basename(path))[0])
    BANKS.update(mod.DATA)


def khong_dau(s):
    """Bỏ dấu tiếng Việt để đặt tên file cho an toàn."""
    s = unicodedata.normalize('NFD', s)
    s = ''.join(c for c in s if unicodedata.category(c) != 'Mn')
    s = s.replace('đ', 'd').replace('Đ', 'D')
    keep = [c if c.isalnum() else '-' for c in s.lower()]
    return '-'.join(''.join(keep).split('-')).strip('-')


def esc(s):
    """Escape chuỗi cho câu lệnh SQL."""
    return s.replace('\\', '\\\\').replace("'", "''")


def main():
    os.makedirs(OUT, exist_ok=True)

    # Kiểm tra dữ liệu trước khi sinh file, tránh nạp câu hỏi hỏng vào CSDL
    loi = []
    for mon, rows in BANKS.items():
        for i, r in enumerate(rows, 1):
            if len(r) != 7:
                loi.append(f'{mon} câu {i}: cần 7 cột, đang có {len(r)}')
                continue
            if r[5] not in ('A', 'B', 'C', 'D'):
                loi.append(f'{mon} câu {i}: đáp án đúng phải là A/B/C/D')
            if r[6] not in ('easy', 'medium', 'hard'):
                loi.append(f'{mon} câu {i}: độ khó phải là easy/medium/hard')
            if len(set(r[1:5])) != 4:
                loi.append(f'{mon} câu {i}: 4 phương án bị trùng nhau')
    if loi:
        print('DỮ LIỆU CHƯA HỢP LỆ:')
        for e in loi[:30]:
            print('  -', e)
        raise SystemExit(1)

    sql_q = ["-- Ngân hàng câu hỏi các môn Đại học (sinh tự động từ build.py)",
             "-- Chạy: mysql -u root quiz_db < seed-cau-hoi.sql",
             "SET NAMES utf8mb4;", ""]
    tong = 0

    for mon, rows in BANKS.items():
        ten = khong_dau(mon)

        # --- file CSV + XLSX để giáo viên tải về / import lại ---
        csv_path = os.path.join(OUT, ten + '.csv')
        with open(csv_path, 'w', newline='', encoding='utf-8-sig') as f:
            w = csv.writer(f)
            w.writerow(HEADER)
            for r in rows:
                w.writerow(['{{ID_' + ten + '}}'] + list(r))

        wb = Workbook()
        ws = wb.active
        ws.title = 'CauHoi'
        ws.append(HEADER)
        for r in rows:
            ws.append(['{{ID_' + ten + '}}'] + list(r))
        ws.column_dimensions['B'].width = 60
        for col in 'CDEF':
            ws.column_dimensions[col].width = 26
        wb.save(os.path.join(OUT, ten + '.xlsx'))

        # --- SQL: tra id môn theo tên, chèn câu hỏi + 4 đáp án ---
        sql_q.append(f"-- ===== {mon} ({len(rows)} câu) =====")
        # COLLATE utf8mb4_bin: MySQL mặc định so sánh KHÔNG phân biệt dấu nên
        # 'Kinh tế vĩ mô' khớp nhầm với 'Kinh tế vi mô'. Phải so khớp nhị phân.
        sql_q.append(
            f"SET @sid = (SELECT id FROM subjects "
            f"WHERE name COLLATE utf8mb4_bin = '{esc(mon)}' LIMIT 1);"
        )
        for r in rows:
            noi_dung, a, b, c, d, dung, kho = r
            sql_q.append(
                "INSERT INTO questions (subject_id, chapter_id, created_by, content, "
                "question_type, difficulty, status, created_at) VALUES "
                f"(@sid, NULL, 1, '{esc(noi_dung)}', 'single', '{kho}', 'active', NOW());"
            )
            sql_q.append("SET @qid = LAST_INSERT_ID();")
            for idx, (nhan, noi) in enumerate(zip('ABCD', (a, b, c, d))):
                sql_q.append(
                    "INSERT INTO answers (question_id, label, content, is_correct, order_index) "
                    f"VALUES (@qid, '{nhan}', '{esc(noi)}', {1 if nhan == dung else 0}, {idx});"
                )
        sql_q.append("")
        tong += len(rows)
        print(f'  {mon:38s} {len(rows):3d} câu')

    with open(os.path.join(OUT, 'seed-cau-hoi.sql'), 'w', encoding='utf-8') as f:
        f.write('\n'.join(sql_q))

    print(f'\nTổng: {len(BANKS)} môn, {tong} câu hỏi -> {OUT}')


if __name__ == '__main__':
    main()
