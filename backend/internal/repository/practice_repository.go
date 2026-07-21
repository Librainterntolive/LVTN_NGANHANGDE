package repository

import (
	"time"

	"quiz-backend/internal/entity"

	"gorm.io/gorm"
)

type PracticeRepository struct {
	db *gorm.DB
}

func NewPracticeRepository(db *gorm.DB) *PracticeRepository {
	return &PracticeRepository{db: db}
}

// AnswerEvent: 1 lần trả lời 1 câu hỏi (từ bài thi hoặc từ luyện tập), theo thời gian
type AnswerEvent struct {
	QuestionID uint
	IsCorrect  bool
	At         time.Time
}

// AnswerEvents: gộp lịch sử trả lời của người dùng từ bài thi + luyện tập, sắp theo thời gian
func (r *PracticeRepository) AnswerEvents(userID uint) ([]AnswerEvent, error) {
	var examEvents []AnswerEvent
	err := r.db.Table("submission_details sd").
		Select("sd.question_id, sd.is_correct, s.submit_time as at").
		Joins("JOIN submissions s ON s.id = sd.submission_id").
		Where("s.user_id = ? AND s.status <> ?", userID, "in_progress").
		Scan(&examEvents).Error
	if err != nil {
		return nil, err
	}
	var practiceEvents []AnswerEvent
	err = r.db.Model(&entity.PracticeAnswer{}).
		Select("question_id, is_correct, created_at as at").
		Where("user_id = ?", userID).Scan(&practiceEvents).Error
	if err != nil {
		return nil, err
	}
	events := append(examEvents, practiceEvents...)
	// sắp xếp theo thời gian tăng dần (chèn đơn giản vì dữ liệu 1 người dùng không lớn)
	for i := 1; i < len(events); i++ {
		for j := i; j > 0 && events[j].At.Before(events[j-1].At); j-- {
			events[j], events[j-1] = events[j-1], events[j]
		}
	}
	return events, nil
}

func (r *PracticeRepository) SaveAnswers(answers []entity.PracticeAnswer) error {
	if len(answers) == 0 {
		return nil
	}
	return r.db.Create(&answers).Error
}

// SubmissionSummary: tổng lượt làm bài đã nộp + điểm trung bình của người dùng
func (r *PracticeRepository) SubmissionSummary(userID uint) (int64, float64) {
	var row struct {
		N   int64
		Avg float64
	}
	r.db.Table("submissions").
		Select("count(*) as n, coalesce(avg(total_score), 0) as avg").
		Where("user_id = ? AND status <> ?", userID, "in_progress").Scan(&row)
	return row.N, row.Avg
}

// ActivityDates: các ngày (yyyy-mm-dd) người dùng có hoạt động (nộp bài / luyện tập) - tính streak
func (r *PracticeRepository) ActivityDates(userID uint) map[string]bool {
	dates := map[string]bool{}
	var d1 []string
	r.db.Table("submissions").
		Where("user_id = ? AND status <> ?", userID, "in_progress").
		Distinct().Pluck("DATE_FORMAT(submit_time, '%Y-%m-%d')", &d1)
	var d2 []string
	r.db.Model(&entity.PracticeAnswer{}).
		Where("user_id = ?", userID).
		Distinct().Pluck("DATE_FORMAT(created_at, '%Y-%m-%d')", &d2)
	for _, d := range append(d1, d2...) {
		if d != "" {
			dates[d] = true
		}
	}
	return dates
}
