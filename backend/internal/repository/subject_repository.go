package repository

import (
	"quiz-backend/internal/entity"

	"gorm.io/gorm"
)

type SubjectRepository struct {
	db *gorm.DB
}

func NewSubjectRepository(db *gorm.DB) *SubjectRepository {
	return &SubjectRepository{db: db}
}

func (r *SubjectRepository) FindAll() ([]entity.Subject, error) {
	var subjects []entity.Subject
	err := r.db.Order("id asc").Find(&subjects).Error
	return subjects, err
}

func (r *SubjectRepository) FindByID(id string) (*entity.Subject, error) {
	var subject entity.Subject
	err := r.db.First(&subject, id).Error
	return &subject, err
}

func (r *SubjectRepository) Create(s *entity.Subject) error {
	return r.db.Create(s).Error
}

func (r *SubjectRepository) Update(s *entity.Subject) error {
	return r.db.Save(s).Error
}

func (r *SubjectRepository) Delete(id string) error {
	return r.db.Delete(&entity.Subject{}, id).Error
}
