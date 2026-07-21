package service

import "quiz-backend/internal/repository"

type StatsService struct {
	repo *repository.StatsRepository
}

func NewStatsService(repo *repository.StatsRepository) *StatsService {
	return &StatsService{repo: repo}
}

func (s *StatsService) Overview() repository.Overview {
	return s.repo.GetOverview()
}

func (s *StatsService) ExamStats() []repository.ExamStat {
	return s.repo.GetExamStats()
}
