package repository

import (
	"quiz-backend/internal/entity"

	"gorm.io/gorm"
)

type AuditRepository struct{ db *gorm.DB }

func NewAuditRepository(db *gorm.DB) *AuditRepository { return &AuditRepository{db: db} }

func (r *AuditRepository) Create(item *entity.AuditLog) error {
	return r.db.Create(item).Error
}

func (r *AuditRepository) FindPaged(action string, limit, offset int) ([]entity.AuditLog, int64, error) {
	query := r.db.Model(&entity.AuditLog{})
	if action != "" {
		query = query.Where("action = ?", action)
	}
	var total int64
	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	var items []entity.AuditLog
	err := query.Order("created_at DESC, id DESC").Limit(limit).Offset(offset).Find(&items).Error
	return items, total, err
}
