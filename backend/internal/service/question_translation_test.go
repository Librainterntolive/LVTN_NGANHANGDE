package service

import (
	"strings"
	"testing"

	"quiz-backend/internal/dto"
)

// Cau hoi khai la ban dich phai chung minh duoc dich tu dau. Ba truong hop
// duoi day deu la cach mot ban dich bia co the lot vao ngan hang de.
func TestValidateTranslationTuChoiBanDichThieuDanChung(t *testing.T) {
	cases := []struct {
		ten    string
		input  dto.QuestionInput
		tuKhoa string
	}{
		{
			ten: "thieu nguyen ban",
			input: dto.QuestionInput{
				Content:           "Lệnh nào khởi tạo một Go module mới?",
				TranslationStatus: "translated",
				OriginalLanguage:  "en",
				TranslationRefs:   "https://go.dev/ref/spec",
			},
			tuKhoa: "nguyên bản",
		},
		{
			ten: "thieu ngon ngu ban goc",
			input: dto.QuestionInput{
				Content:           "Lệnh nào khởi tạo một Go module mới?",
				ContentOriginal:   "Which command initializes a new Go module?",
				TranslationStatus: "translated",
				TranslationRefs:   "https://go.dev/ref/spec",
			},
			tuKhoa: "ngôn ngữ",
		},
		{
			ten: "thieu nguon cong nhan cach dich",
			input: dto.QuestionInput{
				Content:           "Lệnh nào khởi tạo một Go module mới?",
				ContentOriginal:   "Which command initializes a new Go module?",
				TranslationStatus: "translated",
				OriginalLanguage:  "en",
			},
			tuKhoa: "cách dịch",
		},
	}

	for _, c := range cases {
		t.Run(c.ten, func(t *testing.T) {
			err := validateTranslation(c.input)
			if err == nil {
				t.Fatalf("phai tu choi truong hop %q nhung lai chap nhan", c.ten)
			}
			if !strings.Contains(err.Error(), c.tuKhoa) {
				t.Fatalf("thong bao loi phai neu ro thieu gi (%q), nhan duoc: %q", c.tuKhoa, err.Error())
			}
		})
	}
}

// Khoang trang khong duoc tinh la da khai bao.
func TestValidateTranslationKhongChapNhanKhoangTrang(t *testing.T) {
	in := dto.QuestionInput{
		Content:           "Lệnh nào khởi tạo một Go module mới?",
		ContentOriginal:   "   ",
		OriginalLanguage:  "  ",
		TranslationStatus: "translated",
		TranslationRefs:   "\t\n",
	}
	if err := validateTranslation(in); err == nil {
		t.Fatal("chuoi toan khoang trang phai bi tu choi")
	}
}

// Ban dich khai bao day du thi duoc chap nhan.
func TestValidateTranslationChapNhanBanDichDayDu(t *testing.T) {
	in := dto.QuestionInput{
		Content:           "Lệnh nào khởi tạo một Go module mới tên example/hello?",
		ContentOriginal:   "Which command initializes a new Go module named example/hello?",
		OriginalLanguage:  "en",
		TranslationStatus: "translated",
		TranslationRefs:   "https://go.dev/ref/mod\nhttps://go.dev/doc/tutorial/getting-started",
	}
	if err := validateTranslation(in); err != nil {
		t.Fatalf("ban dich day du phai duoc chap nhan, nhan duoc loi: %v", err)
	}
}

// Cau hoi soan thang bang tieng Viet khong bi bat buoc khai nguyen ban.
func TestValidateTranslationBoQuaCauHoiSoanGoc(t *testing.T) {
	for _, status := range []string{"", "original", "gia-tri-la"} {
		in := dto.QuestionInput{
			Content:           "Câu hỏi tự soạn bằng tiếng Việt",
			TranslationStatus: status,
		}
		if err := validateTranslation(in); err != nil {
			t.Fatalf("trang thai %q phai duoc coi la ban goc, nhan duoc loi: %v", status, err)
		}
	}
}

// Gia tri la phai duoc quy ve original, khong duoc ghi thang vao CSDL.
func TestValidTranslationStatusChiNhanHaiGiaTri(t *testing.T) {
	if got := validTranslationStatus("translated"); got != "translated" {
		t.Fatalf("mong doi translated, nhan duoc %q", got)
	}
	for _, input := range []string{"", "original", "TRANSLATED", "bia-dat"} {
		if got := validTranslationStatus(input); got != "original" {
			t.Fatalf("gia tri %q phai quy ve original, nhan duoc %q", input, got)
		}
	}
}
