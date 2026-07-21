package repository

import (
	"quiz-backend/internal/entity"

	"gorm.io/gorm"
)

type ExamRepository struct {
	db *gorm.DB
}

func NewExamRepository(db *gorm.DB) *ExamRepository {
	return &ExamRepository{db: db}
}

func (r *ExamRepository) FindAll(keyword, subjectID string) ([]entity.Exam, error) {
	var exams []entity.Exam
	q := r.db
	if keyword != "" {
		q = q.Where("title LIKE ?", "%"+keyword+"%")
	}
	if subjectID != "" {
		q = q.Where("subject_id = ?", subjectID)
	}
	err := q.Order("id desc").Find(&exams).Error
	return exams, err
}

func (r *ExamRepository) FindByID(id string) (*entity.Exam, error) {
	var exam entity.Exam
	err := r.db.First(&exam, id).Error
	return &exam, err
}

func (r *ExamRepository) Create(e *entity.Exam) error {
	return r.db.Create(e).Error
}

func (r *ExamRepository) Update(e *entity.Exam) error {
	return r.db.Save(e).Error
}

func (r *ExamRepository) Delete(id string) error {
	r.db.Where("exam_id = ?", id).Delete(&entity.ExamQuestion{})
	r.db.Where("exam_id = ?", id).Delete(&entity.ExamClass{})
	return r.db.Delete(&entity.Exam{}, id).Error
}

// ----- câu hỏi trong đề -----
func (r *ExamRepository) GetQuestionIDs(examID uint) []uint {
	var ids []uint
	r.db.Model(&entity.ExamQuestion{}).Where("exam_id = ?", examID).
		Order("order_index asc").Pluck("question_id", &ids)
	return ids
}

func (r *ExamRepository) GetClassIDs(examID uint) []uint {
	var ids []uint
	r.db.Model(&entity.ExamClass{}).Where("exam_id = ?", examID).Pluck("class_id", &ids)
	return ids
}

func (r *ExamRepository) SetQuestions(examID uint, qids []uint) {
	r.db.Where("exam_id = ?", examID).Delete(&entity.ExamQuestion{})
	for i, qid := range qids {
		r.db.Create(&entity.ExamQuestion{ExamID: examID, QuestionID: qid, OrderIndex: i, Points: 1})
	}
}

func (r *ExamRepository) SetClasses(examID uint, cids []uint) {
	r.db.Where("exam_id = ?", examID).Delete(&entity.ExamClass{})
	for _, cid := range cids {
		r.db.Create(&entity.ExamClass{ExamID: examID, ClassID: cid})
	}
}

func (r *ExamRepository) CountQuestions(examID uint) int64 {
	var n int64
	r.db.Model(&entity.ExamQuestion{}).Where("exam_id = ?", examID).Count(&n)
	return n
}

// đề đã phát hành (cho mọi người duyệt trong "ngân hàng đề")
func (r *ExamRepository) FindPublished() ([]entity.Exam, error) {
	var exams []entity.Exam
	err := r.db.Where("status = ?", "published").Order("id desc").Find(&exams).Error
	return exams, err
}

// đề công khai cho khách dùng thử (published + public)
func (r *ExamRepository) FindPublic() ([]entity.Exam, error) {
	var exams []entity.Exam
	err := r.db.Where("status = ? AND access_type = ?", "published", "public").
		Order("id desc").Find(&exams).Error
	return exams, err
}

// IsAssignedToStudent: sinh viên có thuộc lớp nào được giao đề này không?
// Dùng để chặn người ngoài lớp mở đề private dù biết ID đề.
func (r *ExamRepository) IsAssignedToStudent(examID, studentID uint) bool {
	var n int64
	r.db.Model(&entity.ExamClass{}).
		Where("exam_id = ? AND class_id IN (?)", examID,
			r.db.Model(&entity.ClassStudent{}).Select("class_id").
				Where("student_id = ?", studentID),
		).Count(&n)
	return n > 0
}

// đề thi sinh viên được phép làm
func (r *ExamRepository) FindAvailableForStudent(studentID interface{}) ([]entity.Exam, error) {
	var exams []entity.Exam
	err := r.db.Where(
		"status = ? AND (access_type = ? OR id IN (?))",
		"published", "public",
		r.db.Model(&entity.ExamClass{}).Select("exam_id").
			Where("class_id IN (?)",
				r.db.Model(&entity.ClassStudent{}).Select("class_id").
					Where("student_id = ?", studentID),
			),
	).Order("id desc").Find(&exams).Error
	return exams, err
}
