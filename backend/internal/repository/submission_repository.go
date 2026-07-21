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

func (r *SubmissionRepository) Update(s *entity.Submission) error {
	return r.db.Save(s).Error
}

func (r *SubmissionRepository) CreateDetail(d *entity.SubmissionDetail) error {
	return r.db.Create(d).Error
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
