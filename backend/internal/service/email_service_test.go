package service

import (
	"mime"
	"strings"
	"testing"
)

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
