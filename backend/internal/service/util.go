package service

import "errors"
import "strings"
import "quiz-backend/internal/entity"
import "quiz-backend/internal/dto"

// ErrNotOwner: sửa/xóa thứ do người khác tạo.
// Controller đổi lỗi này thành HTTP 403.
var ErrNotOwner = errors.New("day khong phai du lieu ban tao, khong the sua hoac xoa")

// canModify: Admin toàn quyền; các vai trò khác chỉ đụng được thứ mình tạo.
// Dùng chung cho đề thi, câu hỏi và lớp học.
func canModify(createdBy, userID uint, role string) bool {
	return role == "Admin" || createdBy == userID
}

// emailOrNil: email bỏ trống -> NULL thay vì chuỗi rỗng.
// MySQL cho phép nhiều NULL trên cột uniqueIndex, nhưng chỉ một chuỗi rỗng.
func emailOrNil(s string) *string {
	s = strings.TrimSpace(s)
	if s == "" {
		return nil
	}
	return &s
}

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
