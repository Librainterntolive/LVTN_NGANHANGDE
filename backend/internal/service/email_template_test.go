package service

import (
	"strings"
	"testing"
)

// Thu co ban HTML phai gui kem ban van ban thuan. Ung dung mail chi hien van
// ban se roi ve ban do; thu chi co HTML cung bi bo loc thu rac danh gia thap.
func TestBuildMessageGuiKemCaBanVanBanThuan(t *testing.T) {
	msg := buildMessage("sv@example.com", "QuizBank <no-reply@example.com>",
		"Mã xác minh", "Mã của bạn: 123456", "<html><body>123456</body></html>")

	for _, phai := range []string{
		"multipart/alternative",
		"Content-Type: text/plain; charset=UTF-8",
		"Content-Type: text/html; charset=UTF-8",
		"Mã của bạn: 123456",
		"<html>",
	} {
		if !strings.Contains(msg, phai) {
			t.Fatalf("thu thieu phan %q", phai)
		}
	}

	// Ranh gioi phai mo dung hai lan va dong dung mot lan.
	if n := strings.Count(msg, "--quizbank-boundary-8f4c1d92e7--"); n != 1 {
		t.Fatalf("phai co dung 1 ranh gioi ket thuc, dem duoc %d", n)
	}
}

// Khong co ban HTML thi giu nguyen thu van ban thuan, khong boc multipart.
func TestBuildMessageKhongCoHTMLThiGiuVanBanThuan(t *testing.T) {
	msg := buildMessage("sv@example.com", "a@b.com", "Tiêu đề", "Nội dung", "")
	if strings.Contains(msg, "multipart") {
		t.Fatal("thu khong co HTML thi khong duoc boc multipart")
	}
	if !strings.Contains(msg, "Content-Type: text/plain; charset=UTF-8") {
		t.Fatal("thieu khai bao text/plain")
	}
}

// Noi dung dua vao thu phai duoc thoat ky tu HTML. Neu khong, ten lop hoc hay
// noi dung thong bao do nguoi dung nhap co the chen the vao thu cua nguoi khac.
func TestBuildEmailThoatKyTuHTML(t *testing.T) {
	_, htmlBody := buildEmail(
		"Tiêu đề <script>alert(1)</script>",
		[]emailBlock{
			{Text: `Lớp "Toán A2" <img src=x onerror=alert(1)>`},
			{Code: "<b>123456</b>"},
			{Note: "Ghi chú & lưu ý"},
		},
		"Chân thư <hr>",
	)

	// Diem mau chot khong phai la chuoi "onerror=" co con hay khong, ma la dau
	// mo the "<" da bi thoat chua. Con "<" thi trinh doc thu moi hieu do la the;
	// da thanh "&lt;" thi ca doan chi la chu thuong, khong chay duoc.
	for _, cam := range []string{"<script", "<img", "<hr>", "<b>"} {
		if strings.Contains(htmlBody, cam) {
			t.Fatalf("the do nguoi dung nhap chua duoc thoat, van con %q", cam)
		}
	}
	if !strings.Contains(htmlBody, "&lt;script&gt;") {
		t.Fatal("the phai duoc thoat thanh &lt;script&gt;")
	}
	if !strings.Contains(htmlBody, "&amp;") {
		t.Fatal("dau & phai duoc thoat thanh &amp;")
	}
}

// Ban van ban thuan phai chua du thong tin de doc duoc khi khong co HTML.
func TestBuildEmailBanVanBanChuaDuNoiDung(t *testing.T) {
	text, _ := buildEmail(
		"Xác minh địa chỉ email",
		[]emailBlock{
			{Text: "Nhập mã dưới đây."},
			{Code: "046639"},
			{Note: "Không chia sẻ mã này."},
		},
		"Chân thư.",
	)

	for _, phai := range []string{"Xác minh địa chỉ email", "Nhập mã dưới đây.", "046639", "Không chia sẻ mã này.", "Chân thư.", brandName} {
		if !strings.Contains(text, phai) {
			t.Fatalf("ban van ban thieu %q", phai)
		}
	}
}
