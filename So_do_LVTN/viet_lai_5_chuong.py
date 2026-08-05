# -*- coding: utf-8 -*-
"""Tái cấu trúc luận văn 12 chương -> 5 chương theo mẫu tham khảo."""
import os
import re
import shutil
import sys

sys.stdout.reconfigure(encoding='utf-8')
HERE = os.path.dirname(os.path.abspath(__file__))
UNP = os.path.join(HERE, 'unpacked')
DOC = os.path.join(UNP, 'word', 'document.xml')
SODO = r'D:\Luan van tot nghiep\So_do_LVTN'

xml = open(DOC, encoding='utf-8').read()
dau, than, cuoi = re.match(r'(.*?<w:body>)(.*)(</w:body>.*)', xml, re.S).groups()


# ---------- cắt khối ----------
def cat_khoi(s):
    kq, i, n = [], 0, len(s)
    while i < n:
        m = re.compile(r'<(w:\w+)([^>]*?)(/?)>').match(s, i)
        if not m:
            j = s.find('<', i + 1)
            if j < 0:
                break
            i = j
            continue
        ten, tu_dong = m.group(1), m.group(3)
        if tu_dong:
            kq.append(s[i:m.end()]); i = m.end(); continue
        muc, sau = 1, m.end()
        mo = re.compile(r'<' + ten + r'(?:\s[^>]*?)?(/?)>')
        dg = re.compile(r'</' + ten + r'>')
        while muc and sau < n:
            a, b = mo.search(s, sau), dg.search(s, sau)
            if not b:
                break
            if a and a.start() < b.start():
                if not a.group(1):
                    muc += 1
                sau = a.end()
            else:
                muc -= 1; sau = b.end()
        kq.append(s[i:sau]); i = sau
    return kq


K = cat_khoi(than)
print('So khoi:', len(K))


def chu(k):
    return ''.join(re.findall(r'<w:t[^>]*>(.*?)</w:t>', k, re.S)).strip()


def kieu(k):
    m = re.search(r'<w:pStyle w:val="([^"]+)"', k)
    return m.group(1) if m else ''


def muc_tieu_de(k):
    m = re.match(r'Heading(\d)', kieu(k))
    return int(m.group(1)) if m else 0


def dat_kieu(k, kv):
    return re.sub(r'(<w:pStyle w:val=")[^"]+(")', r'\g<1>' + kv + r'\g<2>', k, count=1)


def dat_chu(k, moi):
    st = [True]
    def f(m):
        if st[0]:
            st[0] = False
            return '<w:t xml:space="preserve">' + moi + '</w:t>'
        return '<w:t xml:space="preserve"></w:t>'
    return re.sub(r'<w:t[^>]*>.*?</w:t>', f, k, flags=re.S)


def bo_so(t):
    return re.sub(r'^(?:Chương\s+)?[0-9A-Z]+(?:[.\-][0-9]+)*\.?\s+', '', t).strip()


def bo_sect(k):
    return re.sub(r'<w:sectPr\b.*?</w:sectPr>', '', k, flags=re.S)


# ---------- tìm phạm vi theo tiêu đề ----------
TD = [(i, muc_tieu_de(k), chu(k)) for i, k in enumerate(K) if muc_tieu_de(k)]


def pham_vi(bat_dau_bang):
    """Trả (i, j) : khối tiêu đề i và các khối con tới trước tiêu đề cùng/cao hơn."""
    for idx, (i, lv, t) in enumerate(TD):
        if t.startswith(bat_dau_bang):
            for (i2, lv2, _) in TD[idx + 1:]:
                if lv2 <= lv:
                    return i, i2
            return i, len(K)
    raise KeyError(bat_dau_bang)


def than_muc(pfx):
    """Các khối BÊN TRONG một mục (bỏ dòng tiêu đề)."""
    i, j = pham_vi(pfx)
    return [bo_sect(k) for k in K[i + 1:j]]


def ca_muc(pfx, kieu_moi, so_moi, ten_moi=None):
    """Cả mục kèm tiêu đề, đổi cấp và đánh số lại. Con cũng tụt 1 cấp."""
    i, j = pham_vi(pfx)
    goc = muc_tieu_de(K[i])
    lech = int(kieu_moi[-1]) - goc
    ra = []
    for idx in range(i, j):
        k = bo_sect(K[idx])
        lv = muc_tieu_de(k)
        if idx == i:
            ten = ten_moi if ten_moi else bo_so(chu(k))
            ra.append(dat_chu(dat_kieu(k, kieu_moi), so_moi + ' ' + ten))
        elif lv:
            moi = min(lv + lech, 9)
            ra.append(dat_kieu(k, f'Heading{moi}'))
        else:
            ra.append(k)
    return ra


# ---------- tạo đoạn mới ----------
def P(t, ki=None, giua=False, ngh=False):
    pPr = (f'<w:pStyle w:val="{ki}"/>' if ki else '') + ('<w:jc w:val="center"/>' if giua else '')
    rPr = '<w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>' + ('<w:i/>' if ngh else '') + '</w:rPr>'
    return f'<w:p><w:pPr>{pPr}</w:pPr><w:r>{rPr}<w:t xml:space="preserve">{t}</w:t></w:r></w:p>'


def H(lv, t):
    return P(t, f'Heading{lv}')


def chu_thich(mo_ta):
    """Chú thích hình, dựng đúng 2 run như các chú thích sẵn có:
    run 1 'Hình x-y.' đậm-nghiêng-gạch chân, run 2 phần mô tả chỉ nghiêng.
    Số hiệu để tạm 0-0, bước đánh số lại phía dưới sẽ điền đúng."""
    return ('<w:p><w:pPr><w:spacing w:after="200"/><w:jc w:val="center"/></w:pPr>'
            '<w:r><w:rPr><w:b/><w:i/><w:sz w:val="24"/><w:u w:val="single"/></w:rPr>'
            '<w:t>Hình 0-0.</w:t></w:r>'
            '<w:r><w:rPr><w:i/><w:sz w:val="24"/></w:rPr>'
            f'<w:t xml:space="preserve"> {mo_ta}</w:t></w:r></w:p>')


def doi_so_hinh(k, so_moi):
    """Chỉ thay run chứa 'Hình x-y.', giữ nguyên phần mô tả và định dạng."""
    return re.sub(r'(<w:t[^>]*>)Hình\s+[\w\-]+\.(</w:t>)',
                  r'\g<1>' + so_moi + r'\g<2>', k, count=1)


# ---------- nhúng ảnh ----------
RELS = os.path.join(UNP, 'word', '_rels', 'document.xml.rels')
rels = open(RELS, encoding='utf-8').read()
_next = [max(int(x) for x in re.findall(r'Id="rId(\d+)"', rels)) + 1]
_pic = [9000]


def them_anh(ten_png):
    """Chép PNG vào gói, tạo quan hệ, trả về đoạn XML chứa ảnh."""
    global rels
    src = os.path.join(SODO, ten_png)
    dich = 'media/' + ten_png
    shutil.copy(src, os.path.join(UNP, 'word', 'media', ten_png))
    rid = f'rId{_next[0]}'; _next[0] += 1
    rels = rels.replace('</Relationships>',
        f'<Relationship Id="{rid}" Type="http://schemas.openxmlformats.org/'
        f'officeDocument/2006/relationships/image" Target="{dich}"/></Relationships>')
    from PIL import Image
    w, h = Image.open(src).size
    cx = 5486400                      # 6 inch
    cy = int(cx * h / w)
    _pic[0] += 1
    return ('<w:p><w:pPr><w:spacing w:before="120" w:after="40"/><w:jc w:val="center"/></w:pPr>'
            '<w:r><w:rPr><w:noProof/></w:rPr><w:drawing>'
            f'<wp:inline distT="0" distB="0" distL="0" distR="0">'
            f'<wp:extent cx="{cx}" cy="{cy}"/><wp:effectExtent l="0" t="0" r="0" b="0"/>'
            f'<wp:docPr id="{_pic[0]}" name="Picture {_pic[0]}"/>'
            '<wp:cNvGraphicFramePr><a:graphicFrameLocks xmlns:a="http://schemas.openxmlformats.org/'
            'drawingml/2006/main" noChangeAspect="1"/></wp:cNvGraphicFramePr>'
            '<a:graphic xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main">'
            '<a:graphicData uri="http://schemas.openxmlformats.org/drawingml/2006/picture">'
            '<pic:pic xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture">'
            f'<pic:nvPicPr><pic:cNvPr id="0" name="{ten_png}"/><pic:cNvPicPr/></pic:nvPicPr>'
            f'<pic:blipFill><a:blip r:embed="{rid}"/><a:stretch><a:fillRect/></a:stretch></pic:blipFill>'
            f'<pic:spPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="{cx}" cy="{cy}"/></a:xfrm>'
            '<a:prstGeom prst="rect"><a:avLst/></a:prstGeom></pic:spPr>'
            '</pic:pic></a:graphicData></a:graphic></wp:inline></w:drawing></w:r></w:p>')


# =====================================================================
# 7 chức năng bổ sung
# =====================================================================
CN_MOI = [
    ('Quản trị người dùng',
     '19_Use_case_Quan_tri_nguoi_dung.png', '20_Tuan_tu_Tao_tai_khoan.png',
     'Chức năng này dành riêng cho quản trị viên, cho phép tạo và quản lý toàn bộ '
     'tài khoản trong hệ thống. Quản trị viên xem danh sách người dùng, tạo tài khoản '
     'mới, cập nhật thông tin, phân quyền vai trò (Quản trị viên, Giảng viên, Sinh viên), '
     'tạm khóa tài khoản kèm lý do và xóa tài khoản khi cần.',
     'Khi tạo tài khoản, hệ thống kiểm tra trùng tên đăng nhập và địa chỉ thư điện tử, '
     'mã hóa mật khẩu bằng thuật toán bcrypt trước khi lưu. Mật khẩu gốc không được '
     'lưu ở bất kỳ đâu trong cơ sở dữ liệu.'),

    ('Quản lý môn học và chương',
     '21_Use_case_Quan_ly_mon_hoc_chuong.png', '22_Tuan_tu_Them_chuong.png',
     'Môn học là đơn vị phân loại cao nhất của ngân hàng câu hỏi, bên trong mỗi môn '
     'lại chia thành các chương. Giảng viên thêm, sửa, xóa môn học và chương; ngoài ra '
     'có thể tạm ẩn một môn khỏi danh sách lựa chọn mà không xóa dữ liệu, phục vụ việc '
     'thu hẹp phạm vi sử dụng theo từng học kỳ.',
     'Hệ thống chặn xóa môn học khi môn đó còn câu hỏi hoặc đề thi, nhằm tránh để lại '
     'các bản ghi tham chiếu tới môn không còn tồn tại. Việc phân chương là cơ sở cho '
     'chức năng sinh đề theo ma trận trình bày ở phần sau.'),

    ('Import câu hỏi từ tệp',
     '23_Use_case_Import_cau_hoi.png', '24_Tuan_tu_Import_cau_hoi.png',
     'Chức năng cho phép giảng viên đưa hàng loạt câu hỏi vào ngân hàng từ tệp Excel '
     '(.xlsx) hoặc CSV, thay vì nhập thủ công từng câu. Hệ thống cung cấp sẵn tệp mẫu '
     'để tải về điền nội dung.',
     'Khi nhận tệp, hệ thống kiểm tra định dạng và dung lượng, nhận diện các cột theo '
     'tên tiêu đề nên người dùng không bắt buộc đặt đúng thứ tự cột. Mỗi dòng được '
     'kiểm tra riêng: dòng hợp lệ được ghi nhận, dòng sai bị bỏ qua và báo rõ lý do '
     'kèm số thứ tự dòng. Kết thúc, hệ thống trả về mã môn đã nhận câu hỏi để giao '
     'diện tự mở đúng môn đó cho người dùng xem kết quả.'),

    ('Quản lý kho đề cá nhân',
     '25_Use_case_Kho_ca_nhan.png', '26_Tuan_tu_Luu_de_vao_kho.png',
     'Kho đề cá nhân là không gian lưu trữ riêng của từng người dùng, tổ chức theo cấu '
     'trúc thư mục nhiều cấp. Người dùng tạo thư mục, đổi tên, xóa thư mục cùng toàn bộ '
     'thư mục con, lưu các đề quan tâm vào thư mục và ghi chú cá nhân cho từng đề.',
     'Mọi thao tác đều kiểm tra quyền sở hữu: hệ thống đối chiếu thư mục với người đang '
     'đăng nhập trước khi cho phép sửa hoặc xóa, bảo đảm không ai can thiệp được vào '
     'kho của người khác.'),

    ('Ngân hàng đề dùng chung',
     '27_Use_case_Ngan_hang_de.png', '28_Tuan_tu_Nhan_ban_de.png',
     'Các đề thi đã phát hành được tập hợp thành ngân hàng đề dùng chung để mọi giảng '
     'viên tham khảo. Người dùng duyệt danh sách, xem trước nội dung đề và nhân bản đề '
     'về tài khoản của mình.',
     'Bản sao được tạo ở trạng thái Nháp với phạm vi Riêng tư, dùng chung danh sách câu '
     'hỏi với đề gốc. Nhờ vậy giảng viên có thể chỉnh sửa tự do trên bản sao mà không '
     'ảnh hưởng tới đề gốc đang được sử dụng.'),

    ('Sổ tay câu sai và luyện tập',
     '29_Use_case_So_tay_cau_sai.png', '30_Tuan_tu_Luyen_lai_cau_sai.png',
     'Sau mỗi bài thi, những câu sinh viên trả lời sai được tự động tập hợp vào sổ tay '
     'câu sai. Sinh viên mở sổ tay để xem lại, luyện tập lại các câu này và theo dõi '
     'tiến bộ của bản thân.',
     'Bài luyện tập được chấm ngay nhưng ghi vào nhật ký luyện tập riêng, không tính '
     'vào kết quả thi chính thức. Đây là điểm khác biệt so với các hệ thống thi trực '
     'tuyến thông thường vốn chỉ dừng ở việc trả về điểm số.'),

    ('Thống kê và báo cáo',
     '31_Use_case_Thong_ke_bao_cao.png', '32_Tuan_tu_Xem_thong_ke.png',
     'Chức năng tổng hợp số liệu phục vụ giảng viên đánh giá kết quả giảng dạy: số môn '
     'học, số câu hỏi trong ngân hàng, số đề thi và số lượt làm bài.',
     'Ở mức chi tiết hơn, hệ thống thống kê theo từng đề thi gồm số lượt thi, điểm '
     'trung bình và tỉ lệ đạt, giúp giảng viên nhận ra đề nào quá khó hoặc quá dễ để '
     'điều chỉnh ngân hàng câu hỏi cho phù hợp.'),
]

# 4 chức năng đã có sẵn trong luận văn cũ
CN_CU = [
    ('Quản lý ngân hàng câu hỏi', '6.1', '6.2', '6.4', '6.5'),
    ('Tạo và giao đề thi',        '7.1', '7.2', '7.4', None),
    ('Tổ chức thi và chấm điểm',  '8.1', '8.2', '8.4', None),
    ('Quản lý lớp học',           '9.1', '9.2', '9.4', '9.5'),
]

# =====================================================================
# Ghép thân mới
# =====================================================================
i_ch1 = pham_vi('Chương 1.')[0]
M = list(K[:i_ch1])        # phần đầu (bìa, mục lục...) giữ nguyên

# ----- Chương 1 -----
M.append(dat_chu(K[i_ch1], 'Chương 1. GIỚI THIỆU'))
M += ca_muc('1.1', 'Heading2', '1.1', 'ĐẶT VẤN ĐỀ')
M.append(H(2, '1.2 NHỮNG THÁCH THỨC CẦN GIẢI QUYẾT'))
M.append(H(3, '1.2.1 Về mặt kỹ thuật'))
M.append(P('Hệ thống phải bảo đảm tính công bằng của kỳ thi trong môi trường trực '
           'tuyến, nơi người làm bài hoàn toàn nằm ngoài tầm quan sát của giảng viên. '
           'Bài toán đặt ra gồm: trộn thứ tự câu hỏi và đáp án cho từng sinh viên; giữ '
           'thời gian làm bài ở phía máy chủ để việc tải lại trang không làm mới đồng '
           'hồ; kiểm soát số lần làm bài và chặn nộp bài quá hạn.'))
M.append(P('Bên cạnh đó, dữ liệu ngân hàng câu hỏi có khối lượng lớn nên giao diện cần '
           'phân trang và tải dần thay vì tải toàn bộ một lần. Hệ thống cũng phải phân '
           'quyền chặt chẽ theo vai trò và theo quyền sở hữu dữ liệu, tránh việc giảng '
           'viên này sửa hoặc xóa dữ liệu của giảng viên khác.'))
M.append(H(3, '1.2.2 Về mặt nghiệp vụ'))
M.append(P('Quy trình ra đề tại các cơ sở đào tạo không đơn thuần là chọn ngẫu nhiên '
           'một số câu hỏi. Đề thi thường phải bám theo ma trận đề, tức là quy định số '
           'câu cho từng chương và từng mức độ khó. Hệ thống vì vậy cần hỗ trợ khai báo '
           'ma trận và tự sinh đề theo ma trận đó, đồng thời báo rõ khi ngân hàng không '
           'đủ câu hỏi để đáp ứng.'))
M.append(P('Ngoài ra, một câu hỏi thường được dùng lại ở nhiều đề khác nhau. Việc tổ '
           'chức dữ liệu phải cho phép dùng chung câu hỏi giữa các đề, đồng thời bảo vệ '
           'các đề đã phát hành khỏi bị thay đổi nội dung ngoài ý muốn khi câu hỏi gốc '
           'được chỉnh sửa.'))
M += ca_muc('1.3', 'Heading2', '1.3', 'NỘI DUNG VÀ PHẠM VI THỰC HIỆN')
M += ca_muc('1.4', 'Heading2', '1.4', 'KẾT QUẢ CẦN ĐẠT')
M.append(P(''))

# ----- Chương 2 -----
M.append(H(1, 'Chương 2. PHƯƠNG PHÁP THỰC HIỆN'))
M.append(H(2, '2.1 CÁC HỆ THỐNG TƯƠNG TỰ'))
i, j = pham_vi('Chương 3.')
M += [bo_sect(k) for k in K[i + 1:pham_vi('3.1')[0]]]     # đoạn dẫn nhập
for n, pfx in enumerate(['3.1', '3.2', '3.3', '3.4', '3.5'], start=1):
    M += ca_muc(pfx, 'Heading3', f'2.1.{n}')
M += ca_muc('4.2', 'Heading2', '2.2', 'CÔNG NGHỆ SỬ DỤNG')
M.append(H(2, '2.3 PHÂN TÍCH YÊU CẦU'))
M += ca_muc('2.1', 'Heading3', '2.3.1', 'Yêu cầu chức năng')
M += ca_muc('2.2', 'Heading3', '2.3.2', 'Yêu cầu phi chức năng')
M += ca_muc('2.4', 'Heading3', '2.3.3', 'Các quy trình, nghiệp vụ')
M += ca_muc('2.5', 'Heading3', '2.3.4', 'Tổng hợp các chức năng theo vai trò')
M += ca_muc('4.3', 'Heading3', '2.3.5', 'Sơ đồ chức năng')
M += ca_muc('4.4', 'Heading3', '2.3.6', 'Sơ đồ use case tổng quát')
M.append(P(''))

# ----- Chương 3 -----
M.append(H(1, 'Chương 3. THIẾT KẾ'))
M.append(H(2, '3.1 MÔ HÌNH DỮ LIỆU'))
M += ca_muc('5.1', 'Heading3', '3.1.1', 'Phân tích dữ liệu mức quan niệm')
M += ca_muc('5.2', 'Heading3', '3.1.2', 'Thiết kế dữ liệu mức luận lý')
M.append(H(3, '3.1.3 Dữ liệu liên quan của từng chức năng'))
for n, (ten, _, uc, _, _) in enumerate(CN_CU, start=1):
    pfx = uc[0] + '.3'
    try:
        M += ca_muc(pfx, 'Heading4', '', ten)
    except KeyError:
        pass

M.append(H(2, '3.2 MÔ HÌNH XỬ LÝ'))

M.append(H(3, '3.2.1 Use case chi tiết'))
for ten, mo_ta, uc, _, _ in CN_CU:
    M.append(H(4, ten))
    M += than_muc(mo_ta)
    M += than_muc(uc)
for ten, png_uc, _, t1, t2 in CN_MOI:
    M.append(H(4, ten))
    M.append(P(t1)); M.append(P(t2))
    M.append(them_anh(png_uc))
    M.append(chu_thich('Use case của chức năng ' + ten))

M.append(H(3, '3.2.2 Sơ đồ tuần tự'))
for ten, _, _, tt, _ in CN_CU:
    M.append(H(4, ten))
    M += than_muc(tt)
for ten, _, png_tt, _, _ in CN_MOI:
    M.append(H(4, ten))
    M.append(them_anh(png_tt))
    M.append(chu_thich('Sơ đồ tuần tự chức năng ' + ten))

M.append(H(3, '3.2.3 Sơ đồ hoạt động'))
for ten, _, _, _, hd in CN_CU:
    if hd:
        M.append(H(4, ten))
        M += than_muc(hd)

M.append(H(2, '3.3 HỆ THỐNG MÀN HÌNH'))
i, j = pham_vi('Chương 10.')
M += [bo_sect(k) for k in K[i + 1:pham_vi('10.1')[0]]]
for n in range(1, 12):
    M += ca_muc(f'10.{n} ', 'Heading3', f'3.3.{n}')
M.append(P(''))

# ----- Chương 4, 5 -----
M.append(H(1, 'Chương 4. THỬ NGHIỆM'))
for n, pfx in enumerate(['11.1', '11.2', '11.3'], start=1):
    M += ca_muc(pfx, 'Heading2', f'4.{n}')
M.append(P(''))
M.append(H(1, 'Chương 5. KẾT LUẬN'))
for n, pfx in enumerate(['12.1', '12.2', '12.3'], start=1):
    M += ca_muc(pfx, 'Heading2', f'5.{n}')
M.append(P(''))

# ----- Phụ lục + tài liệu tham khảo (giữ nguyên) -----
i_pl = pham_vi('PHỤ LỤC.')[0]
M += list(K[i_pl:])

# ---------- chuẩn hóa chữ hoa ở tiêu đề cấp 3 ----------
RIENG = {'google forms': 'Google Forms', 'azota': 'Azota', 'quizizz': 'Quizizz'}


def thuong_hoa(t):
    """'3.3.1 MÀN HÌNH ĐĂNG NHẬP' -> '3.3.1 Màn hình đăng nhập'."""
    m = re.match(r'^([\d.]+)\s+(.*)$', t)
    if not m:
        return t
    so, ten = m.group(1), m.group(2)
    if ten != ten.upper():           # đã có chữ thường thì giữ nguyên
        return t
    thap = ten.lower()
    ten = RIENG.get(thap, thap[:1].upper() + thap[1:])
    return f'{so} {ten}'


M = [dat_chu(k, thuong_hoa(chu(k))) if muc_tieu_de(k) == 3 else k for k in M]

# ---------- đánh số lại chú thích hình ----------
ch_hien = ['']
dem = [0]
ra = []
for k in M:
    lv = muc_tieu_de(k)
    t = chu(k)
    if lv == 1:
        m = re.match(r'Chương (\d+)', t)
        if m:
            ch_hien[0] = m.group(1); dem[0] = 0
        elif t.startswith('PHỤ LỤC'):
            if ch_hien[0] != 'PL':   # các phụ lục dùng chung một dãy số
                ch_hien[0] = 'PL'; dem[0] = 0
    if re.match(r'^Hình\s+[\w\-]+\.', t):
        if ch_hien[0]:
            dem[0] += 1
            k = doi_so_hinh(k, f'Hình {ch_hien[0]}-{dem[0]}.')
    ra.append(k)
M = ra

open(DOC, 'w', encoding='utf-8').write(dau + ''.join(M) + cuoi)
open(RELS, 'w', encoding='utf-8').write(rels)
print('So khoi moi:', len(M))
print('Da ghi document.xml va rels')
