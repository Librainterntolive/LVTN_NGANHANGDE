package repository

import (
	"quiz-backend/internal/entity"

	"gorm.io/gorm"
)

type StatsRepository struct {
	db *gorm.DB
}

func NewStatsRepository(db *gorm.DB) *StatsRepository {
	return &StatsRepository{db: db}
}

// Tổng quan
type Overview struct {
	TotalUsers             int64 `json:"total_users"`
	TotalQuestions         int64 `json:"total_questions"`
	TotalApprovedQuestions int64 `json:"total_approved_questions"`
	TotalVerifiedSources   int64 `json:"total_verified_sources"`
	TotalExams             int64 `json:"total_exams"`
	TotalSubmissions       int64 `json:"total_submissions"`
}

func (r *StatsRepository) GetOverview(userID uint, isAdmin bool) Overview {
	var o Overview
	if isAdmin {
		r.db.Model(&entity.User{}).Count(&o.TotalUsers)
		r.db.Model(&entity.Question{}).Count(&o.TotalQuestions)
		r.db.Model(&entity.Question{}).Where("status = ? AND review_status = ?", "active", "approved").Count(&o.TotalApprovedQuestions)
		r.db.Model(&entity.Source{}).Where("verification_status = ?", "verified").Count(&o.TotalVerifiedSources)
		r.db.Model(&entity.Exam{}).Count(&o.TotalExams)
		r.db.Model(&entity.Submission{}).Count(&o.TotalSubmissions)
		return o
	}
	r.db.Table("class_students cs").Joins("JOIN classes c ON c.id = cs.class_id").Where("c.created_by = ?", userID).Distinct("cs.student_id").Count(&o.TotalUsers)
	r.db.Model(&entity.Question{}).Where("created_by = ?", userID).Count(&o.TotalQuestions)
	r.db.Model(&entity.Question{}).Where("created_by = ? AND status = ? AND review_status = ?", userID, "active", "approved").Count(&o.TotalApprovedQuestions)
	r.db.Model(&entity.Source{}).Where("created_by = ? AND verification_status = ?", userID, "verified").Count(&o.TotalVerifiedSources)
	r.db.Model(&entity.Exam{}).Where("created_by = ?", userID).Count(&o.TotalExams)
	r.db.Table("submissions s").Joins("JOIN exams e ON e.id = s.exam_id").Where("e.created_by = ?", userID).Count(&o.TotalSubmissions)
	return o
}

// Thống kê theo từng đề thi
type ExamStat struct {
	ExamID    uint    `json:"exam_id"`
	Title     string  `json:"title"`
	Attempts  int64   `json:"attempts"`
	AvgScore  float64 `json:"avg_score"`
	PassCount int64   `json:"pass_count"`
	PassRate  float64 `json:"pass_rate"`
}

func (r *StatsRepository) GetExamStats() []ExamStat {
	stats, _, _ := r.GetExamStatsPaged(0, true, 1000, 0)
	return stats
}

func (r *StatsRepository) GetExamStatsPaged(userID uint, isAdmin bool, limit, offset int) ([]ExamStat, int64, error) {
	var stats []ExamStat
	var total int64
	examQuery := r.db.Model(&entity.Exam{})
	if !isAdmin {
		examQuery = examQuery.Where("created_by = ?", userID)
	}
	if err := examQuery.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	query := r.db.Table("exams e").
		Select(`e.id as exam_id, e.title,
			COUNT(s.id) as attempts,
			COALESCE(AVG(s.total_score),0) as avg_score,
			COALESCE(SUM(s.is_passed),0) as pass_count`).
		Joins("LEFT JOIN submissions s ON s.exam_id = e.id").
		Group("e.id, e.title")
	if !isAdmin {
		query = query.Where("e.created_by = ?", userID)
	}
	if err := query.Order("e.id desc").Limit(limit).Offset(offset).Scan(&stats).Error; err != nil {
		return nil, 0, err
	}

	// tính tỉ lệ đậu
	for i := range stats {
		if stats[i].Attempts > 0 {
			stats[i].PassRate = float64(stats[i].PassCount) / float64(stats[i].Attempts) * 100
		}
	}
	return stats, total, nil
}
