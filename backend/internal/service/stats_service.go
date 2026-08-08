package service

import "quiz-backend/internal/repository"

type StatsService struct {
	repo *repository.StatsRepository
}

func NewStatsService(repo *repository.StatsRepository) *StatsService {
	return &StatsService{repo: repo}
}

func (s *StatsService) Overview(userID uint, role string) repository.Overview {
	return s.repo.GetOverview(userID, role == "Admin")
}

func (s *StatsService) ExamStats(userID uint, role string) []repository.ExamStat {
	stats, _, _ := s.repo.GetExamStatsPaged(userID, role == "Admin", 1000, 0)
	return stats
}

func (s *StatsService) ExamStatsPaged(userID uint, role string, limit, offset int) ([]repository.ExamStat, int64, error) {
	return s.repo.GetExamStatsPaged(userID, role == "Admin", limit, offset)
}
