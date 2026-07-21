package repository

import (
	"quiz-backend/internal/entity"

	"gorm.io/gorm"
)

type ChapterRepository struct {
	db *gorm.DB
}

func NewChapterRepository(db *gorm.DB) *ChapterRepository {
	return &ChapterRepository{db: db}
}

func (r *ChapterRepository) FindBySubject(subjectID string) ([]entity.Chapter, error) {
	var chapters []entity.Chapter
	err := r.db.Where("subject_id = ?", subjectID).Order("order_index asc, id asc").Find(&chapters).Error
	return chapters, err
}

func (r *ChapterRepository) FindByID(id string) (*entity.Chapter, error) {
	var chapter entity.Chapter
	err := r.db.First(&chapter, id).Error
	return &chapter, err
}

// QuestionCounts: đếm số câu hỏi của từng chương trong 1 môn
func (r *ChapterRepository) QuestionCounts(subjectID string) (map[uint]int64, error) {
	var rows []struct {
		ChapterID uint
		N         int64
	}
	err := r.db.Model(&entity.Question{}).
		Select("chapter_id, count(*) as n").
		Where("subject_id = ? AND chapter_id IS NOT NULL", subjectID).
		Group("chapter_id").Scan(&rows).Error
	m := map[uint]int64{}
	for _, row := range rows {
		m[row.ChapterID] = row.N
	}
	return m, err
}

func (r *ChapterRepository) Create(ch *entity.Chapter) error {
	return r.db.Create(ch).Error
}

func (r *ChapterRepository) Update(ch *entity.Chapter) error {
	return r.db.Save(ch).Error
}

// Delete: xóa chương; câu hỏi thuộc chương trở về "chưa phân chương" (không xóa câu hỏi)
func (r *ChapterRepository) Delete(id string) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Model(&entity.Question{}).Where("chapter_id = ?", id).
			Update("chapter_id", nil).Error; err != nil {
			return err
		}
		return tx.Delete(&entity.Chapter{}, id).Error
	})
}
