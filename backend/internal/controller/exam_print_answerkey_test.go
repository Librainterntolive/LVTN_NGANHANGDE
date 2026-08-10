package controller

import (
	"bytes"
	"strings"
	"testing"

	"quiz-backend/internal/entity"
)

// renderPaper dung ban in tu mot de thi mau.
func renderPaper(t *testing.T, questions []entity.Question) string {
	t.Helper()
	var out bytes.Buffer
	data := struct {
		Exam      entity.Exam
		Questions []entity.Question
		PrintedAt string
	}{
		Exam:      entity.Exam{ID: 12, Title: "Đề kiểm tra Mạng máy tính", Duration: 45},
		Questions: questions,
		PrintedAt: "10/08/2026",
	}
	if err := printExamTemplate.Execute(&out, data); err != nil {
		t.Fatalf("dung ban in that bai: %v", err)
	}
	return out.String()
}

// Ban in phat cho sinh vien TUYET DOI khong duoc danh dau dap an dung.
// Phep kiem: doi cho dap an dung tu A sang B, phan markup phai giong het nhau -
// chi khac noi dung chu. Neu ai do them in dam hay to mau cho dap an dung de
// tien cham bai, bai kiem tra nay se that bai ngay.
func TestBanInKhongDanhDauDapAnDung(t *testing.T) {
	dapAn := func(correctIndex int) []entity.Answer {
		list := make([]entity.Answer, 4)
		for i := range list {
			list[i] = entity.Answer{
				Label:     string(rune('A' + i)),
				Content:   "Nội dung đáp án",
				IsCorrect: i == correctIndex,
			}
		}
		return list
	}

	cauA := renderPaper(t, []entity.Question{{Content: "Câu hỏi thử", Answers: dapAn(0)}})
	cauB := renderPaper(t, []entity.Question{{Content: "Câu hỏi thử", Answers: dapAn(1)}})

	if cauA != cauB {
		t.Fatal("ban in thay doi khi dap an dung doi vi tri -> dap an dung dang bi lo ra ngoai")
	}

	// Khong duoc chua bat ky dau hieu nao ve dap an
	for _, cam := range []string{"is_correct", "IsCorrect", "correct", "đáp án đúng", "dap an dung"} {
		if strings.Contains(strings.ToLower(cauA), strings.ToLower(cam)) {
			t.Fatalf("ban in chua dau hieu ve dap an dung: %q", cam)
		}
	}
}

// Ban in phai khai bao UTF-8, neu khong dau tieng Viet se hien sai khi mo tep
// HTML da tai ve.
func TestBanInKhaiBaoUTF8VaGiuDauTiengViet(t *testing.T) {
	paper := renderPaper(t, []entity.Question{{
		Content: "Trạng thái TIME-WAIT của TCP tồn tại để làm gì?",
		Answers: []entity.Answer{
			{Label: "A", Content: "Chờ đủ thời gian để chắc chắn bên kia đã nhận ACK", IsCorrect: true},
			{Label: "B", Content: "Chờ hệ điều hành cấp lại cổng", IsCorrect: false},
		},
	}})

	if !strings.Contains(paper, `charset="utf-8"`) && !strings.Contains(paper, "charset=utf-8") {
		t.Fatal("ban in phai khai bao charset utf-8")
	}
	for _, chu := range []string{"Trạng thái TIME-WAIT", "Chờ đủ thời gian", "ĐỀ KIỂM TRA HỌC PHẦN"} {
		if !strings.Contains(paper, chu) {
			t.Fatalf("ban in mat noi dung tieng Viet: %q", chu)
		}
	}
}

// Ban in phai danh so cau lien tuc bat dau tu 1, va co cho ghi ho ten sinh vien.
func TestBanInDanhSoCauVaCoChoGhiThongTinSinhVien(t *testing.T) {
	qs := make([]entity.Question, 3)
	for i := range qs {
		qs[i] = entity.Question{
			Content: "Nội dung câu hỏi",
			Answers: []entity.Answer{{Label: "A", Content: "A", IsCorrect: true}, {Label: "B", Content: "B"}},
		}
	}
	paper := renderPaper(t, qs)

	for _, so := range []string{"Câu 1.", "Câu 2.", "Câu 3."} {
		if !strings.Contains(paper, so) {
			t.Fatalf("ban in thieu %q", so)
		}
	}
	if strings.Contains(paper, "Câu 0.") {
		t.Fatal("so cau phai bat dau tu 1, khong phai 0")
	}
	for _, muc := range []string{"Họ và tên", "Lớp / Mã sinh viên", "Thời gian làm bài"} {
		if !strings.Contains(paper, muc) {
			t.Fatalf("ban in thieu muc %q", muc)
		}
	}
}

// Nut "In de" chi de bam tren man hinh, khong duoc in ra giay.
func TestBanInAnNutInKhiInRaGiay(t *testing.T) {
	paper := renderPaper(t, []entity.Question{{
		Content: "Câu hỏi", Answers: []entity.Answer{{Label: "A", Content: "A", IsCorrect: true}, {Label: "B", Content: "B"}},
	}})
	if !strings.Contains(paper, "@media print") || !strings.Contains(paper, ".no-print") {
		t.Fatal("ban in phai co quy tac an phan tu .no-print khi in")
	}
	if !strings.Contains(paper, `class="no-print"`) {
		t.Fatal("nut In de phai duoc gan class no-print")
	}
}
