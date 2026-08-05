# -*- coding: utf-8 -*-
"""
Sinh 14 sơ đồ bổ sung cho 7 chức năng chưa có trong luận văn.

Mỗi sơ đồ xuất ra 2 tệp:
  - .drawio : mở bằng draw.io để chỉnh sửa
  - .png    : chèn thẳng vào Word

Chạy:  python sinh_so_do_bo_sung.py

Dữ liệu sơ đồ khai báo ở phần SO_DO bên dưới, muốn sửa nội dung thì sửa
ở đó rồi chạy lại, cả hai tệp sẽ được cập nhật cùng lúc.
"""
import math
import os
import sys
from xml.sax.saxutils import escape

from PIL import Image, ImageDraw, ImageFont

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

HERE = os.path.dirname(os.path.abspath(__file__))
TRANG_W, TRANG_H = 1100, 850
TL = 2  # tỉ lệ phóng khi xuất PNG cho nét

FONT_THUONG = r'C:\Windows\Fonts\times.ttf'
FONT_DAM = r'C:\Windows\Fonts\timesbd.ttf'


def font(dam=False, co=13):
    duong_dan = FONT_DAM if dam else FONT_THUONG
    try:
        return ImageFont.truetype(duong_dan, co * TL)
    except OSError:
        return ImageFont.load_default()


# =====================================================================
# Phần dựng .drawio
# =====================================================================
HEAD = ('<mxfile host="app.diagrams.net">\n<diagram id="d1" name="Trang-1">\n'
        '<mxGraphModel dx="800" dy="600" grid="1" gridSize="10" guides="1" tooltips="1" '
        'connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1100" '
        'pageHeight="850" math="0" shadow="0"><root>\n'
        '<mxCell id="0"/>\n<mxCell id="1" parent="0"/>\n')
FOOT = '</root></mxGraphModel>\n</diagram>\n</mxfile>\n'


def bo_cuc_use_case(muc):
    """Tính toạ độ cho sơ đồ use case."""
    n = len(muc)
    cao_o, khoang = 76, 115
    tong = (n - 1) * khoang + cao_o
    y0 = max(60, (TRANG_H - tong) / 2 - 40)
    y_giua = y0 + tong / 2 - 40
    return y0, y_giua, cao_o, khoang


def drawio_use_case(tieu_de, tac_nhan, trung_tam, muc):
    y0, y_giua, cao_o, khoang = bo_cuc_use_case(muc)
    x = [HEAD]
    x.append(f'<mxCell id="T" value="{escape(tieu_de)}" '
             'style="text;html=1;fontStyle=1;fontSize=14;" vertex="1" parent="1">'
             '<mxGeometry x="120" y="8" width="760" height="26" as="geometry"/></mxCell>\n')
    x.append(f'<mxCell id="AC" value="{escape(tac_nhan)}" '
             'style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;'
             f'outlineConnect=0;" vertex="1" parent="1"><mxGeometry x="60" y="{y_giua + 10}" '
             'width="36" height="60" as="geometry"/></mxCell>\n')
    x.append(f'<mxCell id="C" value="{escape(trung_tam)}" '
             'style="ellipse;whiteSpace=wrap;html=1;fillColor=none;" vertex="1" parent="1">'
             f'<mxGeometry x="360" y="{y_giua}" width="220" height="80" as="geometry"/></mxCell>\n')
    x.append('<mxCell id="ea" value="" style="endArrow=none;html=1;" edge="1" parent="1" '
             'source="AC" target="C"><mxGeometry relative="1" as="geometry"/></mxCell>\n')
    for i, (ten, loai) in enumerate(muc):
        y = y0 + i * khoang
        x.append(f'<mxCell id="S{i}" value="{escape(ten)}" '
                 'style="ellipse;whiteSpace=wrap;html=1;fillColor=none;" vertex="1" parent="1">'
                 f'<mxGeometry x="780" y="{y}" width="200" height="{cao_o}" as="geometry"/></mxCell>\n')
        x.append(f'<mxCell id="es{i}" value="&amp;lt;&amp;lt;{loai}&amp;gt;&amp;gt;" '
                 'style="endArrow=open;dashed=1;html=1;endFill=0;" edge="1" parent="1" '
                 f'source="C" target="S{i}"><mxGeometry relative="1" as="geometry"/></mxCell>\n')
    x.append(FOOT)
    return ''.join(x)


def cot_tuan_tu(doi_tuong):
    return [120] + [350 + i * 300 for i in range(len(doi_tuong))]


def drawio_tuan_tu(tieu_de, tac_nhan, doi_tuong, thong_diep):
    cot = cot_tuan_tu(doi_tuong)
    day = 150 + len(thong_diep) * 62
    x = [HEAD]
    x.append(f'<mxCell id="T" value="{escape(tieu_de)}" '
             'style="text;html=1;fontStyle=1;fontSize=14;" vertex="1" parent="1">'
             '<mxGeometry x="120" y="8" width="760" height="26" as="geometry"/></mxCell>\n')
    x.append(f'<mxCell id="p0" value="{escape(tac_nhan)}" '
             'style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;'
             'outlineConnect=0;" vertex="1" parent="1">'
             '<mxGeometry x="102" y="40" width="36" height="60" as="geometry"/></mxCell>\n')
    x.append('<mxCell id="ll0" value="" style="endArrow=none;dashed=1;html=1;" edge="1" '
             'parent="1"><mxGeometry relative="1" as="geometry">'
             '<mxPoint x="120" y="106" as="sourcePoint"/>'
             f'<mxPoint x="120" y="{day}" as="targetPoint"/></mxGeometry></mxCell>\n')
    for i, ten in enumerate(doi_tuong, start=1):
        cx = cot[i]
        x.append(f'<mxCell id="p{i}" value="&quot;{escape(ten)}&quot;" '
                 'style="rounded=0;whiteSpace=wrap;html=1;fillColor=none;" vertex="1" parent="1">'
                 f'<mxGeometry x="{cx - 70}" y="40" width="140" height="34" as="geometry"/></mxCell>\n')
        x.append(f'<mxCell id="ll{i}" value="" style="endArrow=none;dashed=1;html=1;" edge="1" '
                 'parent="1"><mxGeometry relative="1" as="geometry">'
                 f'<mxPoint x="{cx}" y="74" as="sourcePoint"/>'
                 f'<mxPoint x="{cx}" y="{day}" as="targetPoint"/></mxGeometry></mxCell>\n')
    for i, (so, noi_dung, tu, den, hoi_dap) in enumerate(thong_diep):
        y = 135 + i * 62
        style = ('endArrow=open;dashed=1;html=1;endFill=0;' if hoi_dap
                 else 'endArrow=open;html=1;')
        x.append(f'<mxCell id="m{i}" value="{escape(so + ". " + noi_dung)}" '
                 f'style="{style}" edge="1" parent="1">'
                 '<mxGeometry relative="1" as="geometry">'
                 f'<mxPoint x="{cot[tu]}" y="{y}" as="sourcePoint"/>'
                 f'<mxPoint x="{cot[den]}" y="{y}" as="targetPoint"/></mxGeometry></mxCell>\n')
    x.append(FOOT)
    return ''.join(x)


# =====================================================================
# Phần vẽ .png
# =====================================================================
DEN = (0, 0, 0)
XAM = (110, 110, 110)


def _ngat_dong(d, chu, fnt, rong_toi_da):
    tu = chu.split()
    dong, hien = [], ''
    for t in tu:
        thu = (hien + ' ' + t).strip()
        if d.textlength(thu, font=fnt) <= rong_toi_da or not hien:
            hien = thu
        else:
            dong.append(hien)
            hien = t
    if hien:
        dong.append(hien)
    return dong


def _chu_giua(d, chu, fnt, cx, cy, rong_toi_da, mau=DEN):
    dong = _ngat_dong(d, chu, fnt, rong_toi_da)
    cao = (fnt.size + 3 * TL)
    y = cy - len(dong) * cao / 2
    for ln in dong:
        w = d.textlength(ln, font=fnt)
        d.text((cx - w / 2, y), ln, font=fnt, fill=mau)
        y += cao


def _tac_nhan(d, x, y, ten, fnt):
    """Vẽ hình người que UML."""
    s = TL
    x, y = x * s, y * s
    r = 9 * s
    d.ellipse([x - r, y, x + r, y + 2 * r], outline=DEN, width=2)
    d.line([x, y + 2 * r, x, y + 5 * r], fill=DEN, width=2)          # thân
    d.line([x - 2 * r, y + 3 * r, x + 2 * r, y + 3 * r], fill=DEN, width=2)  # tay
    d.line([x, y + 5 * r, x - 1.6 * r, y + 7.5 * r], fill=DEN, width=2)      # chân trái
    d.line([x, y + 5 * r, x + 1.6 * r, y + 7.5 * r], fill=DEN, width=2)      # chân phải
    w = d.textlength(ten, font=fnt)
    d.text((x - w / 2, y + 8 * r), ten, font=fnt, fill=DEN)


def _mui_ten(d, x1, y1, x2, y2, dut=False, dac=True):
    """Vẽ đoạn thẳng (liền hoặc đứt) kèm đầu mũi tên hướng theo đường."""
    s = TL
    X1, Y1, X2, Y2 = x1 * s, y1 * s, x2 * s, y2 * s
    dx, dy = X2 - X1, Y2 - Y1
    dai = math.hypot(dx, dy)
    if dai == 0:
        return
    ux, uy = dx / dai, dy / dai   # vector đơn vị dọc theo đường

    if dut:
        buoc, net = 10 * s, 6 * s
        t = 0.0
        while t < dai:
            t2 = min(t + net, dai)
            d.line([X1 + ux * t, Y1 + uy * t, X1 + ux * t2, Y1 + uy * t2],
                   fill=DEN, width=2)
            t += buoc
    else:
        d.line([X1, Y1, X2, Y2], fill=DEN, width=2)

    # đầu mũi tên: lùi lại theo vector đơn vị rồi tỏa sang hai bên
    dd, ngang = 11 * s, 5 * s
    gx, gy = X2 - ux * dd, Y2 - uy * dd      # gốc mũi tên
    px, py = -uy * ngang, ux * ngang         # vector vuông góc
    if dac:
        d.polygon([(X2, Y2), (gx + px, gy + py), (gx - px, gy - py)], fill=DEN)
    else:
        d.line([X2, Y2, gx + px, gy + py], fill=DEN, width=2)
        d.line([X2, Y2, gx - px, gy - py], fill=DEN, width=2)


def png_use_case(tieu_de, tac_nhan, trung_tam, muc):
    y0, y_giua, cao_o, khoang = bo_cuc_use_case(muc)
    img = Image.new('RGB', (TRANG_W * TL, TRANG_H * TL), 'white')
    d = ImageDraw.Draw(img)
    f_td, f_o, f_nh = font(True, 15), font(False, 12), font(False, 10)

    w = d.textlength(tieu_de, font=f_td)
    d.text(((TRANG_W * TL - w) / 2, 18 * TL), tieu_de, font=f_td, fill=DEN)

    _tac_nhan(d, 78, y_giua + 12, tac_nhan, f_o)

    # ca sử dụng chính
    cx, cy = 470, y_giua + 40
    d.ellipse([(cx - 110) * TL, (cy - 40) * TL, (cx + 110) * TL, (cy + 40) * TL],
              outline=DEN, width=2)
    _chu_giua(d, trung_tam, f_o, cx * TL, cy * TL, 190 * TL)
    d.line([96 * TL, (y_giua + 40) * TL, (cx - 110) * TL, cy * TL], fill=DEN, width=2)

    for i, (ten, loai) in enumerate(muc):
        y = y0 + i * khoang + cao_o / 2
        ox = 880
        d.ellipse([(ox - 100) * TL, (y - 38) * TL, (ox + 100) * TL, (y + 38) * TL],
                  outline=DEN, width=2)
        _chu_giua(d, ten, f_o, ox * TL, y * TL, 175 * TL)
        _mui_ten(d, cx + 110, cy, ox - 100, y, dut=True, dac=False)
        nhan = f'<<{loai}>>'
        mx, my = (cx + 110 + ox - 100) / 2, (cy + y) / 2
        wn = d.textlength(nhan, font=f_nh)
        d.rectangle([mx * TL - wn / 2 - 2, my * TL - 9 * TL,
                     mx * TL + wn / 2 + 2, my * TL + 3 * TL], fill='white')
        d.text((mx * TL - wn / 2, my * TL - 8 * TL), nhan, font=f_nh, fill=XAM)
    return img


def png_tuan_tu(tieu_de, tac_nhan, doi_tuong, thong_diep):
    cot = cot_tuan_tu(doi_tuong)
    day = 150 + len(thong_diep) * 62
    cao = max(TRANG_H, day + 40)
    img = Image.new('RGB', (TRANG_W * TL, cao * TL), 'white')
    d = ImageDraw.Draw(img)
    f_td, f_o, f_m = font(True, 15), font(False, 12), font(False, 10)

    w = d.textlength(tieu_de, font=f_td)
    d.text(((TRANG_W * TL - w) / 2, 14 * TL), tieu_de, font=f_td, fill=DEN)

    _tac_nhan(d, 120, 48, tac_nhan, f_o)
    for i in range(len(cot)):
        x = cot[i]
        y_bd = 118 if i == 0 else 74
        for y in range(int(y_bd), int(day), 12):
            d.line([x * TL, y * TL, x * TL, min(y + 6, day) * TL], fill=XAM, width=1)
    for i, ten in enumerate(doi_tuong, start=1):
        x = cot[i]
        d.rectangle([(x - 70) * TL, 40 * TL, (x + 70) * TL, 74 * TL], outline=DEN, width=2)
        _chu_giua(d, ten, f_o, x * TL, 57 * TL, 130 * TL)

    for i, (so, noi_dung, tu, den, hoi_dap) in enumerate(thong_diep):
        y = 135 + i * 62
        x1, x2 = cot[tu], cot[den]
        if x1 == x2:   # thông điệp tự gọi
            s = TL
            d.line([x1 * s, y * s, (x1 + 60) * s, y * s], fill=DEN, width=2)
            d.line([(x1 + 60) * s, y * s, (x1 + 60) * s, (y + 18) * s], fill=DEN, width=2)
            _mui_ten(d, x1 + 60, y + 18, x1 + 6, y + 18, dac=True)
            nhan_x, nhan_y = x1 + 70, y - 4
            d.text((nhan_x * TL, nhan_y * TL), f'{so}. {noi_dung}', font=f_m, fill=DEN)
        else:
            _mui_ten(d, x1, y, x2, y, dut=hoi_dap, dac=not hoi_dap)
            chu = f'{so}. {noi_dung}'
            wn = d.textlength(chu, font=f_m)
            mx = (x1 + x2) / 2
            d.text((mx * TL - wn / 2, (y - 17) * TL), chu, font=f_m, fill=DEN)
    return img


# =====================================================================
# Dữ liệu 14 sơ đồ — sửa nội dung ở đây rồi chạy lại
# =====================================================================
UC = 'use_case'
TT = 'tuan_tu'

SO_DO = [
    # --- 1. Quản trị người dùng ---
    ('19_Use_case_Quan_tri_nguoi_dung', UC,
     ('Sơ đồ Use Case — Quản trị người dùng', 'Quản trị viên', 'QUẢN TRỊ NGƯỜI DÙNG',
      [('Xem danh sách người dùng', 'include'),
       ('Tạo tài khoản mới', 'include'),
       ('Cập nhật thông tin tài khoản', 'extend'),
       ('Phân quyền vai trò', 'extend'),
       ('Khóa / mở khóa tài khoản', 'extend'),
       ('Xóa tài khoản', 'extend')])),

    ('20_Tuan_tu_Tao_tai_khoan', TT,
     ('Sơ đồ tuần tự — Tạo tài khoản người dùng', 'Quản trị viên',
      ['Hệ thống', 'Bảng dữ liệu người dùng'],
      [('1', 'Chọn chức năng Tạo tài khoản', 0, 1, False),
       ('1.1', 'Yêu cầu nhập thông tin tài khoản', 1, 0, True),
       ('1.1.1', 'Nhập tên đăng nhập, email, vai trò, mật khẩu', 0, 1, False),
       ('1.1.2', 'Kiểm tra dữ liệu hợp lệ', 1, 1, False),
       ('1.1.3', 'Kiểm tra trùng tên đăng nhập / email', 1, 2, False),
       ('1.1.4', 'Trả về kết quả kiểm tra', 2, 1, True),
       ('1.1.5', 'Mã hóa mật khẩu (bcrypt)', 1, 1, False),
       ('1.1.6', 'Ghi tài khoản mới', 1, 2, False),
       ('1.1.7', 'Trả về mã tài khoản', 2, 1, True),
       ('1.1.8', 'Thông báo tạo tài khoản thành công', 1, 0, True)])),

    # --- 2. Quản lý môn học và chương ---
    ('21_Use_case_Quan_ly_mon_hoc_chuong', UC,
     ('Sơ đồ Use Case — Quản lý môn học và chương', 'Giảng viên',
      'QUẢN LÝ MÔN HỌC VÀ CHƯƠNG',
      [('Thêm môn học', 'include'),
       ('Sửa thông tin môn học', 'extend'),
       ('Tạm ẩn / hiện môn học', 'extend'),
       ('Xóa môn học', 'extend'),
       ('Thêm chương cho môn học', 'include'),
       ('Sửa / xóa chương', 'extend')])),

    ('22_Tuan_tu_Them_chuong', TT,
     ('Sơ đồ tuần tự — Thêm chương cho môn học', 'Giảng viên',
      ['Hệ thống', 'Bảng dữ liệu chương'],
      [('1', 'Chọn môn học cần thêm chương', 0, 1, False),
       ('1.1', 'Hiển thị danh sách chương hiện có', 1, 0, True),
       ('1.1.1', 'Nhập tên chương và thứ tự', 0, 1, False),
       ('1.1.2', 'Kiểm tra môn học tồn tại', 1, 1, False),
       ('1.1.3', 'Ghi chương mới', 1, 2, False),
       ('1.1.4', 'Trả về mã chương', 2, 1, True),
       ('1.1.5', 'Đếm số câu hỏi thuộc chương', 1, 2, False),
       ('1.1.6', 'Trả về danh sách chương đã cập nhật', 2, 1, True),
       ('1.1.7', 'Hiển thị chương vừa thêm', 1, 0, True)])),

    # --- 3. Import câu hỏi từ tệp ---
    ('23_Use_case_Import_cau_hoi', UC,
     ('Sơ đồ Use Case — Import câu hỏi từ tệp', 'Giảng viên', 'IMPORT CÂU HỎI TỪ TỆP',
      [('Tải tệp mẫu Excel', 'extend'),
       ('Chọn tệp .csv hoặc .xlsx', 'include'),
       ('Nhận diện cột theo tiêu đề', 'include'),
       ('Ghi nhận câu hỏi hợp lệ', 'include'),
       ('Báo lỗi theo từng dòng', 'extend')])),

    ('24_Tuan_tu_Import_cau_hoi', TT,
     ('Sơ đồ tuần tự — Import câu hỏi từ tệp', 'Giảng viên',
      ['Hệ thống', 'Bảng dữ liệu câu hỏi'],
      [('1', 'Chọn tệp và bấm Import', 0, 1, False),
       ('1.1', 'Kiểm tra định dạng và dung lượng tệp', 1, 1, False),
       ('1.2', 'Đọc dữ liệu, nhận diện cột theo tiêu đề', 1, 1, False),
       ('1.3', 'Duyệt từng dòng, kiểm tra nội dung và đáp án đúng', 1, 1, False),
       ('1.4', 'Ghi câu hỏi và các đáp án hợp lệ', 1, 2, False),
       ('1.5', 'Trả về mã các câu hỏi đã tạo', 2, 1, True),
       ('1.6', 'Tổng hợp số câu thành công và các dòng lỗi', 1, 1, False),
       ('1.7', 'Trả kết quả kèm mã môn đã nhận câu hỏi', 1, 0, True),
       ('1.8', 'Mở đúng môn để xem câu hỏi vừa nhập', 0, 1, False)])),

    # --- 4. Kho đề cá nhân ---
    ('25_Use_case_Kho_ca_nhan', UC,
     ('Sơ đồ Use Case — Kho đề cá nhân', 'Sinh viên', 'QUẢN LÝ KHO ĐỀ CÁ NHÂN',
      [('Tạo thư mục', 'include'),
       ('Đổi tên thư mục', 'extend'),
       ('Xóa thư mục và thư mục con', 'extend'),
       ('Lưu đề vào thư mục', 'include'),
       ('Gỡ đề khỏi thư mục', 'extend'),
       ('Ghi chú cá nhân cho đề', 'extend')])),

    ('26_Tuan_tu_Luu_de_vao_kho', TT,
     ('Sơ đồ tuần tự — Lưu đề vào kho cá nhân', 'Sinh viên',
      ['Hệ thống', 'Bảng dữ liệu kho đề'],
      [('1', 'Chọn đề trong ngân hàng đề', 0, 1, False),
       ('1.1', 'Hiển thị danh sách thư mục cá nhân', 1, 0, True),
       ('1.1.1', 'Chọn thư mục cần lưu', 0, 1, False),
       ('1.1.2', 'Kiểm tra thư mục thuộc quyền sở hữu', 1, 2, False),
       ('1.1.3', 'Trả về kết quả kiểm tra', 2, 1, True),
       ('1.1.4', 'Kiểm tra đề đã có trong thư mục chưa', 1, 2, False),
       ('1.1.5', 'Ghi liên kết đề - thư mục', 1, 2, False),
       ('1.1.6', 'Xác nhận đã lưu', 2, 1, True),
       ('1.1.7', 'Hiển thị nhãn Đã lưu trên đề', 1, 0, True)])),

    # --- 5. Ngân hàng đề dùng chung ---
    ('27_Use_case_Ngan_hang_de', UC,
     ('Sơ đồ Use Case — Ngân hàng đề dùng chung', 'Giảng viên', 'NGÂN HÀNG ĐỀ DÙNG CHUNG',
      [('Duyệt các đề đã phát hành', 'include'),
       ('Xem trước nội dung đề', 'extend'),
       ('Nhân bản đề về tài khoản', 'include'),
       ('Chỉnh sửa bản sao', 'extend'),
       ('Lưu đề vào kho cá nhân', 'extend')])),

    ('28_Tuan_tu_Nhan_ban_de', TT,
     ('Sơ đồ tuần tự — Nhân bản đề thi', 'Giảng viên',
      ['Hệ thống', 'Bảng dữ liệu đề thi'],
      [('1', 'Chọn đề cần nhân bản', 0, 1, False),
       ('1.1', 'Đọc thông tin đề gốc', 1, 2, False),
       ('1.2', 'Trả về cấu hình đề gốc', 2, 1, True),
       ('1.3', 'Tạo đề mới: trạng thái Nháp, phạm vi Riêng', 1, 2, False),
       ('1.4', 'Trả về mã đề mới', 2, 1, True),
       ('1.5', 'Sao chép danh sách câu hỏi của đề gốc', 1, 2, False),
       ('1.6', 'Xác nhận đã sao chép', 2, 1, True),
       ('1.7', 'Thông báo nhân bản thành công', 1, 0, True)])),

    # --- 6. Sổ tay câu sai ---
    ('29_Use_case_So_tay_cau_sai', UC,
     ('Sơ đồ Use Case — Sổ tay câu sai và luyện tập', 'Sinh viên',
      'SỔ TAY CÂU SAI VÀ LUYỆN TẬP',
      [('Xem danh sách câu đã làm sai', 'include'),
       ('Luyện lại các câu sai', 'include'),
       ('Nộp bài luyện tập', 'include'),
       ('Xem thống kê học tập cá nhân', 'extend')])),

    ('30_Tuan_tu_Luyen_lai_cau_sai', TT,
     ('Sơ đồ tuần tự — Luyện lại câu sai', 'Sinh viên',
      ['Hệ thống', 'Bảng dữ liệu luyện tập'],
      [('1', 'Mở sổ tay câu sai', 0, 1, False),
       ('1.1', 'Truy vấn các câu đã trả lời sai', 1, 2, False),
       ('1.2', 'Trả về danh sách câu sai', 2, 1, True),
       ('1.3', 'Hiển thị đề luyện tập (ẩn đáp án đúng)', 1, 0, True),
       ('1.4', 'Chọn đáp án và nộp bài luyện tập', 0, 1, False),
       ('1.5', 'Đối chiếu với đáp án đúng', 1, 1, False),
       ('1.6', 'Ghi nhật ký luyện tập', 1, 2, False),
       ('1.7', 'Xác nhận đã ghi', 2, 1, True),
       ('1.8', 'Hiển thị số câu đúng và câu cần ôn tiếp', 1, 0, True)])),

    # --- 7. Thống kê báo cáo ---
    ('31_Use_case_Thong_ke_bao_cao', UC,
     ('Sơ đồ Use Case — Thống kê và báo cáo', 'Giảng viên', 'THỐNG KÊ VÀ BÁO CÁO',
      [('Xem thống kê tổng quan', 'include'),
       ('Thống kê kết quả theo đề thi', 'include'),
       ('Xem tỉ lệ đạt / không đạt', 'extend'),
       ('Xem điểm trung bình và số lượt thi', 'extend')])),

    ('32_Tuan_tu_Xem_thong_ke', TT,
     ('Sơ đồ tuần tự — Xem thống kê kết quả thi', 'Giảng viên',
      ['Hệ thống', 'Bảng dữ liệu bài làm'],
      [('1', 'Mở trang Thống kê', 0, 1, False),
       ('1.1', 'Truy vấn số liệu tổng quan', 1, 2, False),
       ('1.2', 'Trả về số môn, câu hỏi, đề thi, lượt thi', 2, 1, True),
       ('1.3', 'Hiển thị bảng tổng quan', 1, 0, True),
       ('1.4', 'Chọn xem thống kê theo đề thi', 0, 1, False),
       ('1.5', 'Tính điểm trung bình và tỉ lệ đạt từng đề', 1, 2, False),
       ('1.6', 'Trả về kết quả tổng hợp', 2, 1, True),
       ('1.7', 'Hiển thị bảng thống kê theo đề', 1, 0, True)])),
]


def main():
    for ten, loai, tham_so in SO_DO:
        if loai == UC:
            xml = drawio_use_case(*tham_so)
            img = png_use_case(*tham_so)
        else:
            xml = drawio_tuan_tu(*tham_so)
            img = png_tuan_tu(*tham_so)
        with open(os.path.join(HERE, ten + '.drawio'), 'w', encoding='utf-8') as f:
            f.write(xml)
        img.save(os.path.join(HERE, ten + '.png'))
        print(f'  {ten}  (.drawio + .png {img.width}x{img.height})')
    print(f'\nĐã sinh {len(SO_DO)} sơ đồ vào {HERE}')


if __name__ == '__main__':
    main()
