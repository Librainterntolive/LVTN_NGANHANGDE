package service

import (
	"mime"
	"strings"
	"testing"
)

// Nguoi dung cuoi khong duoc thay chi tiet ky thuat cua may chu thu: ma loi
// SMTP, ten may chu, hay duong dan ho tro cua nha cung cap. Nhung thu do vua
// vo nghia voi ho, vua lo cau hinh he thong thu ben trong.
func TestSendEmailKhongLoChiTietKyThuatRaNguoiDung(t *testing.T) {
	t.Setenv("SMTP_HOST", "")
	t.Setenv("SMTP_USERNAME", "")
	t.Setenv("SMTP_PASSWORD", "")

	err := sendEmail("sinhvien@example.com", "Mã xác minh", "123456")
	if err == nil {
		t.Fatal("thieu cau hinh SMTP thi phai bao loi")
	}
	if err != ErrEmailNotSent {
		t.Fatalf("phai tra ve dung ErrEmailNotSent, nhan duoc: %v", err)
	}

	msg := err.Error()
	for _, cam := range []string{"535", "5.7.8", "smtp", "SMTP_", "google", "gmail", "password", "BadCredentials"} {
		if strings.Contains(strings.ToLower(msg), strings.ToLower(cam)) {
			t.Fatalf("thong bao loi khong duoc chua %q, nhan duoc: %q", cam, msg)
		}
	}
	if !strings.Contains(msg, "email") {
		t.Fatalf("thong bao phai cho nguoi dung biet la loi gui email, nhan duoc: %q", msg)
	}
}

// Tieu de tieng Viet co dau phai duoc ma hoa RFC 2047 truoc khi dat vao
// header Subject, va phai giai ma nguoc lai dung nguyen van.
func TestEncodeMailSubjectGiuNguyenTiengVietCoDau(t *testing.T) {
	cases := []string{
		"Đã có điểm bài tập: Bài tập tuần 3",
		"Sinh viên đã nộp bài: Báo cáo giữa kỳ",
		"Thông báo mới từ lớp Công nghệ thông tin K47",
		"Mã xác minh QuizBank",
	}

	decoder := new(mime.WordDecoder)
	for _, original := range cases {
		encoded := encodeMailSubject(original)

		if strings.ContainsAny(encoded, "\r\n") {
			t.Fatalf("tieu de da ma hoa khong duoc chua xuong dong: %q", encoded)
		}
		for _, r := range encoded {
			if r > 127 {
				t.Fatalf("tieu de %q van con ky tu ngoai ASCII: %q", original, encoded)
			}
		}

		decoded, err := decoder.DecodeHeader(encoded)
		if err != nil {
			t.Fatalf("khong giai ma duoc tieu de %q: %v", encoded, err)
		}
		if decoded != original {
			t.Fatalf("giai ma sai: mong doi %q, nhan duoc %q", original, decoded)
		}
	}
}

// Tieu de thuan ASCII khong can ma hoa, giu nguyen cho de doc.
func TestEncodeMailSubjectGiuNguyenChuoiASCII(t *testing.T) {
	const plain = "QuizBank notification"
	if got := encodeMailSubject(plain); got != plain {
		t.Fatalf("mong doi giu nguyen %q, nhan duoc %q", plain, got)
	}
}

// Khong cho phep chen them header qua ky tu xuong dong (CRLF injection).
func TestEncodeMailSubjectChanCRLFInjection(t *testing.T) {
	got := encodeMailSubject("Xin chao\r\nBcc: kesau@example.com")
	if strings.ContainsAny(got, "\r\n") {
		t.Fatalf("tieu de van con CRLF: %q", got)
	}
	if strings.Contains(got, "Bcc:") && strings.ContainsAny(got, "\r\n") {
		t.Fatalf("header bi chen them: %q", got)
	}
}
