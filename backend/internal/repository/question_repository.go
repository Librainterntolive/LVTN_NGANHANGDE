package repository

import (
	"quiz-backend/internal/entity"

	"gorm.io/gorm"
)

type QuestionRepository struct {
	db *gorm.DB
}

func NewQuestionRepository(db *gorm.DB) *QuestionRepository {
	return &QuestionRepository{db: db}
}

// QuestionFilter: điều kiện lọc danh sách câu hỏi
type QuestionFilter struct {
	SubjectID string
	Keyword   string
	OwnerMode string // "" / me / others
	OwnerID   uint
	ChapterID  string // "" = tất cả, "none" = chưa phân chương, khác = id chương
	Status     string // "" = tất cả, draft / active
	Difficulty string // "" = tất cả, easy / medium / hard
}

// buildQuery: dựng điều kiện lọc dùng chung cho FindPaged và Count
func (r *QuestionRepository) buildQuery(f QuestionFilter) *gorm.DB {
	q := r.db.Model(&entity.Question{})
	if f.SubjectID != "" {
		q = q.Where("subject_id = ?", f.SubjectID)
	}
	if f.Keyword != "" {
		q = q.Where("content LIKE ?", "%"+f.Keyword+"%")
	}
	if f.OwnerMode == "me" {
		q = q.Where("created_by = ?", f.OwnerID)
	} else if f.OwnerMode == "others" {
		q = q.Where("created_by <> ?", f.OwnerID)
	}
	if f.ChapterID == "none" {
		q = q.Where("chapter_id IS NULL")
	} else if f.ChapterID != "" {
		q = q.Where("chapter_id = ?", f.ChapterID)
	}
	if f.Status != "" {
		q = q.Where("status = ?", f.Status)
	}
	if f.Difficulty != "" {
		q = q.Where("difficulty = ?", f.Difficulty)
	}
	return q
}

// FindPaged: lấy 1 trang câu hỏi (kèm đáp án)
func (r *QuestionRepository) FindPaged(f QuestionFilter, limit, offset int) ([]entity.Question, error) {
	var questions []entity.Question
	err := r.buildQuery(f).
		Preload("Answers").Order("id desc").Limit(limit).Offset(offset).Find(&questions).Error
	return questions, err
}

// Count: tổng số câu hỏi khớp điều kiện (để biết còn dữ liệu)
func (r *QuestionRepository) Count(f QuestionFilter) (int64, error) {
	var n int64
	err := r.buildQuery(f).Count(&n).Error
	return n, err
}

// UsedCounts: số đề thi đang dùng từng câu hỏi (map id -> số đề)
func (r *QuestionRepository) UsedCounts(ids []uint) (map[uint]int64, error) {
	m := map[uint]int64{}
	if len(ids) == 0 {
		return m, nil
	}
	var rows []struct {
		QuestionID uint
		N          int64
	}
	err := r.db.Model(&entity.ExamQuestion{}).
		Select("question_id, count(*) as n").
		Where("question_id IN ?", ids).
		Group("question_id").Scan(&rows).Error
	for _, row := range rows {
		m[row.QuestionID] = row.N
	}
	return m, err
}

// UsedCount: số đề thi đang dùng 1 câu hỏi (để khóa sửa/xóa)
func (r *QuestionRepository) UsedCount(id uint) int64 {
	var n int64
	r.db.Model(&entity.ExamQuestion{}).Where("question_id = ?", id).Count(&n)
	return n
}

// PickRandomIDs: bốc ngẫu nhiên id câu hỏi CHÍNH THỨC theo chương + độ khó (cho ma trận đề).
// exclude: các id đã bốc ở dòng ma trận trước (tránh trùng).
func (r *QuestionRepository) PickRandomIDs(subjectID uint, chapter, difficulty string, limit int, exclude []uint) ([]uint, error) {
	q := r.db.Model(&entity.Question{}).
		Where("subject_id = ? AND status = ?", subjectID, "active")
	if chapter == "none" {
		q = q.Where("chapter_id IS NULL")
	} else if chapter != "" && chapter != "any" {
		q = q.Where("chapter_id = ?", chapter)
	}
	if difficulty != "" && difficulty != "any" {
		q = q.Where("difficulty = ?", difficulty)
	}
	if len(exclude) > 0 {
		q = q.Where("id NOT IN ?", exclude)
	}
	var ids []uint
	err := q.Order("RAND()").Limit(limit).Pluck("id", &ids).Error
	return ids, err
}

// CountDraft: đếm câu hỏi ở trạng thái nháp trong danh sách id (chặn đưa vào đề)
func (r *QuestionRepository) CountDraft(ids []uint) int64 {
	if len(ids) == 0 {
		return 0
	}
	var n int64
	r.db.Model(&entity.Question{}).Where("id IN ? AND status = ?", ids, "draft").Count(&n)
	return n
}

func (r *QuestionRepository) FindByID(id string) (*entity.Question, error) {
	var question entity.Question
	err := r.db.Preload("Answers").First(&question, id).Error
	return &question, err
}

// FindByIDs: lấy nhiều câu hỏi (cho đề thi)
func (r *QuestionRepository) FindByIDs(ids []uint) ([]entity.Question, error) {
	var questions []entity.Question
	err := r.db.Preload("Answers").Where("id IN ?", ids).Find(&questions).Error
	return questions, err
}

func (r *QuestionRepository) Create(q *entity.Question) error {
	return r.db.Create(q).Error
}

func (r *QuestionRepository) Update(q *entity.Question) error {
	return r.db.Save(q).Error
}

// ReplaceAnswers: xóa đáp án cũ và tạo lại
func (r *QuestionRepository) ReplaceAnswers(questionID uint, answers []entity.Answer) error {
	if err := r.db.Where("question_id = ?", questionID).Delete(&entity.Answer{}).Error; err != nil {
		return err
	}
	for i := range answers {
		answers[i].QuestionID = questionID
	}
	if len(answers) > 0 {
		return r.db.Create(&answers).Error
	}
	return nil
}

func (r *QuestionRepository) Delete(id string) error {
	r.db.Where("question_id = ?", id).Delete(&entity.Answer{})
	return r.db.Delete(&entity.Question{}, id).Error
}
