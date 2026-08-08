package service

import (
	"quiz-backend/internal/entity"
	"quiz-backend/internal/repository"
)

// AuditService lưu sự kiện nghiệp vụ. Lỗi ghi log không làm thất bại thao tác chính.
type AuditService struct {
	repo     *repository.AuditRepository
	userRepo *repository.UserRepository
}

func NewAuditService(repo *repository.AuditRepository, userRepo *repository.UserRepository) *AuditService {
	return &AuditService{repo: repo, userRepo: userRepo}
}

func (s *AuditService) Log(actorID uint, action, entityType string, entityID uint, description string) {
	_ = s.repo.Create(&entity.AuditLog{
		ActorUserID: actorID,
		Action:      action,
		EntityType:  entityType,
		EntityID:    entityID,
		Description: description,
	})
}

func (s *AuditService) GetPaged(action string, limit, offset int) ([]entity.AuditLog, int64, error) {
	items, total, err := s.repo.FindPaged(action, limit, offset)
	if err != nil || len(items) == 0 {
		return items, total, err
	}
	ids := make([]uint, 0, len(items))
	for _, item := range items {
		ids = append(ids, item.ActorUserID)
	}
	names, err := s.userRepo.FindNameMap(ids)
	if err != nil {
		return nil, 0, err
	}
	for index := range items {
		items[index].ActorName = names[items[index].ActorUserID]
	}
	return items, total, nil
}
