package repository

import (
	"quiz-backend/internal/entity"

	"gorm.io/gorm"
)

type ClassPostRepository struct{ db *gorm.DB }

func NewClassPostRepository(db *gorm.DB) *ClassPostRepository { return &ClassPostRepository{db: db} }

func (r *ClassPostRepository) Create(item *entity.ClassPost) error { return r.db.Create(item).Error }

func (r *ClassPostRepository) FindByID(id string) (*entity.ClassPost, error) {
	var item entity.ClassPost
	err := r.db.First(&item, id).Error
	return &item, err
}

func (r *ClassPostRepository) FindPaged(classID uint, limit, offset int) ([]entity.ClassPost, int64, error) {
	query := r.db.Model(&entity.ClassPost{}).Where("class_id = ?", classID)
	var total int64
	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	var items []entity.ClassPost
	err := query.Order("created_at DESC, id DESC").Limit(limit).Offset(offset).Find(&items).Error
	return items, total, err
}

func (r *ClassPostRepository) Update(item *entity.ClassPost) error { return r.db.Save(item).Error }
func (r *ClassPostRepository) Delete(id string) error {
	return r.db.Delete(&entity.ClassPost{}, id).Error
}
