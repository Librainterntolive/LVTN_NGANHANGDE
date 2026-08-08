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

// FindAll: danh sách môn đang dùng (bỏ qua môn đã tạm ẩn).
func (r *SubjectRepository) FindAll() ([]entity.Subject, error) {
	var subjects []entity.Subject
	err := r.db.Where("hidden = ?", false).Order("id asc").Find(&subjects).Error
	return subjects, err
}

// FindAllIncludingHidden: kể cả môn đã ẩn (cho màn hình quản lý môn học,
// để Admin còn thấy mà bật lại).
func (r *SubjectRepository) FindAllIncludingHidden() ([]entity.Subject, error) {
	var subjects []entity.Subject
	err := r.db.Order("id asc").Find(&subjects).Error
	return subjects, err
}

func (r *SubjectRepository) FindPaged(includeHidden bool, level, keyword string, limit, offset int) ([]entity.Subject, int64, error) {
	query := r.db.Model(&entity.Subject{})
	if !includeHidden {
		query = query.Where("hidden = ?", false)
	}
	if level != "" {
		query = query.Where("level = ?", level)
	}
	if keyword != "" {
		query = query.Where("name LIKE ? OR description LIKE ?", "%"+keyword+"%", "%"+keyword+"%")
	}

	var total int64
	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	var subjects []entity.Subject
	err := query.Order("name asc, id asc").Limit(limit).Offset(offset).Find(&subjects).Error
	return subjects, total, err
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

// CountUsage: số câu hỏi và số đề thi đang thuộc môn này.
// Dùng để chặn xóa môn còn dữ liệu (xóa sẽ làm mồ côi cả ngân hàng câu hỏi).
func (r *SubjectRepository) CountUsage(id string) (questions, exams int64) {
	r.db.Model(&entity.Question{}).Where("subject_id = ?", id).Count(&questions)
	r.db.Model(&entity.Exam{}).Where("subject_id = ?", id).Count(&exams)
	return
}
