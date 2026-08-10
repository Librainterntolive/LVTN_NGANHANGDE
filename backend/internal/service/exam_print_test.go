package service

import (
	"strings"
	"testing"

	"quiz-backend/internal/entity"
)

func deThiMau(shuffle, shuffleAnswers bool) (*entity.Exam, []entity.Question) {
	exam := &entity.Exam{ID: 12, Title: "Đề kiểm tra", Duration: 45,
		Shuffle: shuffle, ShuffleAnswers: shuffleAnswers}
	qs := make([]entity.Question, 10)
	for i := range qs {
		qs[i] = entity.Question{
			ID:      uint(i + 1),
			Content: "Câu hỏi số " + itoa(i+1),
			Answers: []entity.Answer{
				{ID: uint(i*4 + 1), Label: "A", Content: "Đáp án A", IsCorrect: true},
				{ID: uint(i*4 + 2), Label: "B", Content: "Đáp án B"},
				{ID: uint(i*4 + 3), Label: "C", Content: "Đáp án C"},
				{ID: uint(i*4 + 4), Label: "D", Content: "Đáp án D"},
			},
		}
	}
	return exam, qs
}

func thuTuCauHoi(v ExamVariant) string {
	var b strings.Builder
	for _, q := range v.Questions {
		b.WriteString(q.Content + "|")
	}
	return b.String()
}

// Cac ma de khac nhau phai co thu tu cau hoi khac nhau, neu khong thi in nhieu
// ma de chang co tac dung chong nhin bai.
func TestMoiMaDeCoThuTuCauKhacNhau(t *testing.T) {
	exam, qs := deThiMau(true, true)
	thay := map[string]bool{}
	for i := 0; i < 4; i++ {
		thay[thuTuCauHoi(buildVariant(exam, qs, i))] = true
	}
	if len(thay) < 4 {
		t.Fatalf("4 ma de chi tao ra %d thu tu khac nhau", len(thay))
	}
}

// In lai cung mot ma de phai ra dung to giay cu. Giang vien in thieu vai ban
// va in bu thi hai lan in phai giong het nhau.
func TestInLaiCungMaDeChoKetQuaGiongHet(t *testing.T) {
	exam, qs := deThiMau(true, true)
	lan1 := buildVariant(exam, qs, 2)
	lan2 := buildVariant(exam, qs, 2)

	if thuTuCauHoi(lan1) != thuTuCauHoi(lan2) {
		t.Fatal("in lai cung ma de ra thu tu cau khac nhau")
	}
	if lan1.Code != lan2.Code {
		t.Fatalf("ma de doi giua hai lan in: %s vs %s", lan1.Code, lan2.Code)
	}
	for i := range lan1.AnswerKey {
		if lan1.AnswerKey[i] != lan2.AnswerKey[i] {
			t.Fatal("bang dap an doi giua hai lan in cung ma de")
		}
	}
}

// Sau khi xao dap an phai danh lai nhan theo dung thu tu hien thi. Neu giu nhan
// cu thi to de se hien "C. ... A. ... D. ... B." — sai hoan toan.
func TestNhanDapAnLuonTheoThuTuABCD(t *testing.T) {
	exam, qs := deThiMau(true, true)
	for i := 0; i < 4; i++ {
		for _, q := range buildVariant(exam, qs, i).Questions {
			for k, a := range q.Answers {
				mong := string(rune('A' + k))
				if a.Label != mong {
					t.Fatalf("ma de %d: nhan dap an thu %d la %q, phai la %q", i, k, a.Label, mong)
				}
			}
		}
	}
}

// Bang dap an phai tro dung dap an dung sau khi da xao va danh lai nhan.
func TestBangDapAnKhopVoiDapAnDungSauKhiXao(t *testing.T) {
	exam, qs := deThiMau(true, true)
	for i := 0; i < 4; i++ {
		v := buildVariant(exam, qs, i)
		if len(v.AnswerKey) != len(v.Questions) {
			t.Fatalf("ma de %d: bang dap an co %d muc nhung de co %d cau", i, len(v.AnswerKey), len(v.Questions))
		}
		for qi, q := range v.Questions {
			var nhanDung string
			for _, a := range q.Answers {
				if a.IsCorrect {
					nhanDung = a.Label
				}
			}
			if v.AnswerKey[qi] != nhanDung {
				t.Fatalf("ma de %d cau %d: bang dap an ghi %q nhung dap an dung o nhan %q",
					i, qi+1, v.AnswerKey[qi], nhanDung)
			}
		}
	}
}

// De thi tat xao tron thi moi ma de phai giu nguyen thu tu goc.
func TestTatXaoTronThiCacMaDeGiongNhau(t *testing.T) {
	exam, qs := deThiMau(false, false)
	goc := thuTuCauHoi(buildVariant(exam, qs, 0))
	for i := 1; i < 4; i++ {
		if thuTuCauHoi(buildVariant(exam, qs, i)) != goc {
			t.Fatalf("de tat xao tron nhung ma de %d van bi xao", i)
		}
	}
}

// Ma de dau tien giu nguyen thu tu goc de giang vien doi chieu voi ban xem truoc.
func TestMaDeDauTienGiuThuTuGoc(t *testing.T) {
	exam, qs := deThiMau(true, true)
	v := buildVariant(exam, qs, 0)
	for i, q := range v.Questions {
		if q.Content != qs[i].Content {
			t.Fatalf("ma de dau tien bi xao o vi tri %d", i)
		}
	}
}

// Cac ma de phai co ma so khac nhau de phan biet tren giay.
func TestCacMaDeCoMaSoKhacNhau(t *testing.T) {
	exam, qs := deThiMau(true, true)
	thay := map[string]bool{}
	for i := 0; i < MaxExamVariants; i++ {
		thay[buildVariant(exam, qs, i).Code] = true
	}
	if len(thay) != MaxExamVariants {
		t.Fatalf("%d ma de chi co %d ma so khac nhau", MaxExamVariants, len(thay))
	}
}
