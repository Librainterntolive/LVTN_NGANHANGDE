package repository

import (
	"errors"

	"quiz-backend/internal/entity"

	"gorm.io/gorm"
)

type SourceRepository struct {
	db *gorm.DB
}

func NewSourceRepository(db *gorm.DB) *SourceRepository {
	return &SourceRepository{db: db}
}

func (r *SourceRepository) FindPaged(keyword string, limit, offset int) ([]entity.Source, int64, error) {
	q := r.db.Model(&entity.Source{})
	if keyword != "" {
		q = q.Where("title LIKE ? OR publisher LIKE ?", "%"+keyword+"%", "%"+keyword+"%")
	}
	var total int64
	if err := q.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	var items []entity.Source
	err := q.Order("id desc").Limit(limit).Offset(offset).Find(&items).Error
	return items, total, err
}

func (r *SourceRepository) FindByID(id uint) (*entity.Source, error) {
	var source entity.Source
	err := r.db.First(&source, id).Error
	return &source, err
}

func (r *SourceRepository) FindByURL(url string) (*entity.Source, error) {
	var source entity.Source
	err := r.db.Where("url = ?", url).First(&source).Error
	return &source, err
}

func (r *SourceRepository) Create(source *entity.Source) error {
	return r.db.Create(source).Error
}
func (r *SourceRepository) Update(source *entity.Source) error {
	return r.db.Save(source).Error
}

func (r *SourceRepository) FindOrCreate(source *entity.Source) (*entity.Source, error) {
	existing, err := r.FindByURL(source.URL)
	if err == nil {
		return existing, nil
	}
	if !errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, err
	}
	if err := r.Create(source); err != nil {
		return nil, err
	}
	return source, nil
}
