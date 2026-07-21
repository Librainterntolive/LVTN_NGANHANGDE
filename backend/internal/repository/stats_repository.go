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
	TotalUsers       int64 `json:"total_users"`
	TotalQuestions   int64 `json:"total_questions"`
	TotalExams       int64 `json:"total_exams"`
	TotalSubmissions int64 `json:"total_submissions"`
}

func (r *StatsRepository) GetOverview() Overview {
	var o Overview
	r.db.Model(&entity.User{}).Count(&o.TotalUsers)
	r.db.Model(&entity.Question{}).Count(&o.TotalQuestions)
	r.db.Model(&entity.Exam{}).Count(&o.TotalExams)
	r.db.Model(&entity.Submission{}).Count(&o.TotalSubmissions)
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
	var stats []ExamStat
	r.db.Table("exams e").
		Select(`e.id as exam_id, e.title,
			COUNT(s.id) as attempts,
			COALESCE(AVG(s.total_score),0) as avg_score,
			COALESCE(SUM(s.is_passed),0) as pass_count`).
		Joins("LEFT JOIN submissions s ON s.exam_id = e.id").
		Group("e.id, e.title").
		Order("e.id desc").
		Scan(&stats)

	// tính tỉ lệ đậu
	for i := range stats {
		if stats[i].Attempts > 0 {
			stats[i].PassRate = float64(stats[i].PassCount) / float64(stats[i].Attempts) * 100
		}
	}
	return stats
}
