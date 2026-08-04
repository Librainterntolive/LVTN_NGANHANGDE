# -*- coding: utf-8 -*-
"""
Xuất file mẫu import (CSV + Excel) kèm mã môn THẬT lấy từ CSDL.

Khác với build.py (sinh SQL nạp thẳng vào CSDL), script này tạo file để
giáo viên tải về, sửa nội dung rồi import lại qua giao diện.

Chạy:  python xuat-file-mau.py
Yêu cầu: MySQL đang chạy và đã nạp danh sách môn học.
"""
import csv
import os
import subprocess
import sys

from openpyxl import Workbook

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

from build import BANKS, khong_dau, HEADER  # dùng lại dữ liệu và tiện ích

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, 'file-mau-import')
MYSQL = r'C:\wamp64\bin\mysql\mysql9.1.0\bin\mysql.exe'

# Số câu đưa vào mỗi file mẫu (đủ để import thử, không quá dài)
SO_CAU_MAU = 30


def lay_ma_mon():
    """Đọc bảng subjects, trả về {tên môn: id}."""
    sql = "SELECT id, name FROM subjects WHERE hidden = 0;"
    out = subprocess.run(
        [MYSQL, '-u', 'root', '-h', '127.0.0.1', '-P', '3306', 'quiz_db',
         '--default-character-set=utf8mb4', '-N', '-e', sql],
        capture_output=True, text=True, encoding='utf-8',
    )
    if out.returncode != 0:
        print('Không đọc được CSDL:', out.stderr[:200])
        raise SystemExit(1)

    m = {}
    for dong in out.stdout.strip().splitlines():
        if '\t' in dong:
            sid, ten = dong.split('\t', 1)
            m[ten.strip()] = int(sid)
    return m


def main():
    ma_mon = lay_ma_mon()
    os.makedirs(OUT, exist_ok=True)
    thieu = []

    for mon, rows in BANKS.items():
        sid = ma_mon.get(mon)
        if sid is None:
            thieu.append(mon)
            continue

        ten = khong_dau(mon)
        data = [[sid] + list(r) for r in rows[:SO_CAU_MAU]]

        with open(os.path.join(OUT, ten + '.csv'), 'w', newline='', encoding='utf-8-sig') as f:
            w = csv.writer(f)
            w.writerow(HEADER)
            w.writerows(data)

        wb = Workbook()
        ws = wb.active
        ws.title = 'CauHoi'
        ws.append(HEADER)
        for r in data:
            ws.append(r)
        ws.column_dimensions['B'].width = 60
        for col in 'CDEF':
            ws.column_dimensions[col].width = 26
        ws.freeze_panes = 'A2'
        wb.save(os.path.join(OUT, ten + '.xlsx'))

        print(f'  {mon:38s} mã môn {sid:3d} - {len(data)} câu')

    if thieu:
        print('\nKhông tìm thấy mã môn cho:', ', '.join(thieu))
    print(f'\nĐã xuất vào: {OUT}')


if __name__ == '__main__':
    main()
