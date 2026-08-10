package service

import (
	"errors"
	"math/rand"

	"quiz-backend/internal/entity"
)

// So ma de toi da cho mot lan in. Dat tran de tranh mot yeu cau lam sinh ra
// hang tram trang giay va treo may chu.
const MaxExamVariants = 8

// ExamVariant la mot ma de: cung bo cau hoi nhung khac thu tu cau va thu tu
// dap an, kem bang dap an rieng cho giang vien cham bai.
type ExamVariant struct {
	Code      string            // ma de in tren giay, vi du "132"
	Questions []entity.Question // da xao tron va danh lai nhan A/B/C/D
	AnswerKey []string          // dap an dung theo tung cau: ["A","C","B",...]
}

// PrintVariants dung nhieu ma de tu mot de thi.
//
// Thu tu cau va dap an duoc xao theo seed suy ra tu ID de thi va so thu tu ma
// de, KHONG dung thoi gian. Nho vay in lai cung mot ma de bao gio cung ra dung
// to giay cu — dieu bat buoc khi giang vien in thieu vai ban va can in bu.
func (s *ExamService) PrintVariants(idStr string, userID uint, role string, count int) (*entity.Exam, []ExamVariant, error) {
	exam, questions, err := s.Preview(idStr, userID, role)
	if err != nil {
		return nil, nil, err
	}
	if len(questions) == 0 {
		return nil, nil, errors.New("Đề thi chưa có câu hỏi nên không in được")
	}
	if count < 1 {
		count = 1
	}
	if count > MaxExamVariants {
		return nil, nil, errors.New("Chỉ in được tối đa " + itoa(MaxExamVariants) + " mã đề trong một lần")
	}

	variants := make([]ExamVariant, 0, count)
	for i := 0; i < count; i++ {
		variants = append(variants, buildVariant(exam, questions, i))
	}
	return exam, variants, nil
}

// buildVariant dung mot ma de tu bo cau hoi goc.
func buildVariant(exam *entity.Exam, source []entity.Question, index int) ExamVariant {
	// Seed co dinh theo (de thi, ma de) nen ket qua lap lai duoc.
	rnd := rand.New(rand.NewSource(int64(exam.ID)*1000 + int64(index)))

	ordered := make([]entity.Question, len(source))
	copy(ordered, source)
	// Ma de dau tien giu nguyen thu tu goc de giang vien doi chieu voi ban
	// xem truoc tren man hinh; cac ma sau moi xao.
	if exam.Shuffle && index > 0 {
		rnd.Shuffle(len(ordered), func(i, j int) { ordered[i], ordered[j] = ordered[j], ordered[i] })
	}

	key := make([]string, 0, len(ordered))
	out := make([]entity.Question, 0, len(ordered))
	for _, q := range ordered {
		answers := make([]entity.Answer, len(q.Answers))
		copy(answers, q.Answers)
		if exam.ShuffleAnswers && index > 0 {
			rnd.Shuffle(len(answers), func(i, j int) { answers[i], answers[j] = answers[j], answers[i] })
		}
		// Sau khi xao phai danh lai nhan theo dung thu tu hien thi. Neu giu
		// nhan cu thi to de se hien "C. ... A. ... D. ... B." — sai hoan toan.
		correct := ""
		for k := range answers {
			answers[k].Label = string(rune('A' + k))
			if answers[k].IsCorrect {
				correct = answers[k].Label
			}
		}
		key = append(key, correct)

		copied := q
		copied.Answers = answers
		out = append(out, copied)
	}

	return ExamVariant{Code: variantCode(exam.ID, index), Questions: out, AnswerKey: key}
}

// variantCode sinh ma de ba chu so, khac nhau giua cac ma trong cung de thi.
// Dung day so co dinh thay vi ngau nhien de ma de on dinh qua cac lan in.
func variantCode(examID uint, index int) string {
	base := []int{132, 209, 357, 485, 570, 628, 743, 896}
	code := base[index%len(base)] + int(examID%10)
	return itoa(code)
}

func itoa(n int) string {
	if n == 0 {
		return "0"
	}
	neg := n < 0
	if neg {
		n = -n
	}
	var b []byte
	for n > 0 {
		b = append([]byte{byte('0' + n%10)}, b...)
		n /= 10
	}
	if neg {
		return "-" + string(b)
	}
	return string(b)
}
