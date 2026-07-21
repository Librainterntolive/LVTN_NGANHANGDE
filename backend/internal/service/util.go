package service

import "quiz-backend/internal/entity"
import "quiz-backend/internal/dto"

// defaultStr: trả về def nếu v rỗng
func defaultStr(v, def string) string {
	if v == "" {
		return def
	}
	return v
}

// toAnswers: chuyển dto.AnswerInput -> entity.Answer, tự gán nhãn A/B/C/D nếu trống
func toAnswers(in []dto.AnswerInput) []entity.Answer {
	out := make([]entity.Answer, 0, len(in))
	for i, a := range in {
		label := a.Label
		if label == "" {
			label = string(rune('A' + i))
		}
		out = append(out, entity.Answer{
			Label:      label,
			Content:    a.Content,
			IsCorrect:  a.IsCorrect,
			OrderIndex: i,
		})
	}
	return out
}
