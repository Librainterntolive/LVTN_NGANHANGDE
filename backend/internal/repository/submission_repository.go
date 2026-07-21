package repository

import (
	"quiz-backend/internal/entity"

	"gorm.io/gorm"
)

type SubmissionRepository struct {
	db *gorm.DB
}

func NewSubmissionRepository(db *gorm.DB) *SubmissionRepository {
	return &SubmissionRepository{db: db}
}

func (r *SubmissionRepository) Create(s *entity.Submission) error {
	return r.db.Create(s).Error
}

// CountAttempts: số lần sinh viên đã vào làm đề này (tính cả bài đang làm dở)
func (r *SubmissionRepository) CountAttempts(examID, userID uint) int64 {
	var n int64
	r.db.Model(&entity.Submission{}).
		Where("exam_id = ? AND user_id = ?", examID, userID).Count(&n)
	return n
}

// FindInProgress: phiên làm bài đang mở của sinh viên (nil nếu không có).
// Đây là nguồn "giờ bắt đầu" đáng tin cậy - lưu ở server, client không sửa được.
func (r *SubmissionRepository) FindInProgress(examID, userID uint) *entity.Submission {
	var s entity.Submission
	err := r.db.Where("exam_id = ? AND user_id = ? AND status = ?",
		examID, userID, "in_progress").Order("id desc").First(&s).Error
	if err != nil {
		return nil
	}
	return &s
}

// SubmitTx: lưu bài + toàn bộ chi tiết trong 1 giao dịch.
// Nếu lỗi giữa chừng thì rollback, không để lại bài chấm dở trong CSDL.
func (r *SubmissionRepository) SubmitTx(s *entity.Submission, details []entity.SubmissionDetail) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Save(s).Error; err != nil {
			return err
		}
		if len(details) == 0 {
			return nil
		}
		for i := range details {
			details[i].SubmissionID = s.ID
		}
		return tx.Create(&details).Error
	})
}

// FindAnswer: lấy 1 đáp án để chấm
func (r *SubmissionRepository) FindAnswer(answerID uint) (*entity.Answer, error) {
	var a entity.Answer
	err := r.db.First(&a, answerID).Error
	return &a, err
}

// SubmissionRow: dữ liệu hiển thị lịch sử làm bài
type SubmissionRow struct {
	ID         uint    `json:"id"`
	ExamID     uint    `json:"exam_id"`
	ExamTitle  string  `json:"exam_title"`
	TotalScore float64 `json:"total_score"`
	IsPassed   bool    `json:"is_passed"`
	SubmitTime string  `json:"submit_time"`
}

func (r *SubmissionRepository) FindByUser(userID interface{}) ([]SubmissionRow, error) {
	var rows []SubmissionRow
	err := r.db.Table("submissions s").
		Select("s.id, s.exam_id, e.title as exam_title, s.total_score, s.is_passed, s.submit_time").
		Joins("JOIN exams e ON e.id = s.exam_id").
		Where("s.user_id = ?", userID).
		Order("s.id desc").
		Scan(&rows).Error
	return rows, err
}
