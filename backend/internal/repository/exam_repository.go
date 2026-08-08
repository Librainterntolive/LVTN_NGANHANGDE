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
func (r *ExamRepository) FindPaged(keyword, subjectID string, limit, offset int) ([]entity.Exam, int64, error) {
	var rows []entity.Exam
	var total int64
	q := r.db.Model(&entity.Exam{})
	if keyword != "" {
		q = q.Where("title LIKE ?", "%"+keyword+"%")
	}
	if subjectID != "" {
		q = q.Where("subject_id = ?", subjectID)
	}
	if err := q.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	err := q.Order("id desc").Limit(limit).Offset(offset).Find(&rows).Error
	return rows, total, err
}

func (r *ExamRepository) FindPagedForOwner(keyword, subjectID string, ownerID uint, isAdmin bool, limit, offset int) ([]entity.Exam, int64, error) {
	var rows []entity.Exam
	var total int64
	query := r.db.Model(&entity.Exam{})
	if !isAdmin {
		query = query.Where("created_by = ?", ownerID)
	}
	if keyword != "" {
		query = query.Where("title LIKE ?", "%"+keyword+"%")
	}
	if subjectID != "" {
		query = query.Where("subject_id = ?", subjectID)
	}
	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	err := query.Order("id desc").Limit(limit).Offset(offset).Find(&rows).Error
	return rows, total, err
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

// Delete: xóa đề + toàn bộ dữ liệu phụ thuộc, trong 1 giao dịch.
// Không dọn thì bảng submissions còn lại các bản ghi trỏ tới đề đã biến mất.
func (r *ExamRepository) Delete(id string) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		var subIDs []uint
		tx.Model(&entity.Submission{}).Where("exam_id = ?", id).Pluck("id", &subIDs)
		if len(subIDs) > 0 {
			if err := tx.Where("submission_id IN ?", subIDs).
				Delete(&entity.SubmissionDetail{}).Error; err != nil {
				return err
			}
		}
		if err := tx.Where("exam_id = ?", id).Delete(&entity.Submission{}).Error; err != nil {
			return err
		}
		if err := tx.Where("exam_id = ?", id).Delete(&entity.ExamQuestion{}).Error; err != nil {
			return err
		}
		if err := tx.Where("exam_id = ?", id).Delete(&entity.ExamClass{}).Error; err != nil {
			return err
		}
		if err := tx.Where("exam_id = ?", id).Delete(&entity.FolderExam{}).Error; err != nil {
			return err
		}
		return tx.Delete(&entity.Exam{}, id).Error
	})
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
	err := r.publishedPublicQuery().Order("id desc").Find(&exams).Error
	return exams, err
}

func (r *ExamRepository) FindPublishedPaged(subjectID, keyword string, limit, offset int) ([]entity.Exam, int64, error) {
	var exams []entity.Exam
	query := r.publishedPublicQuery()
	if subjectID != "" {
		query = query.Where("subject_id = ?", subjectID)
	}
	if keyword != "" {
		query = query.Where("title LIKE ?", "%"+keyword+"%")
	}
	var total int64
	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	err := query.Order("id desc").Limit(limit).Offset(offset).Find(&exams).Error
	return exams, total, err
}

// đề công khai cho khách dùng thử (published + public)
func (r *ExamRepository) FindPublic() ([]entity.Exam, error) {
	var exams []entity.Exam
	err := r.publishedPublicQuery().
		Order("id desc").Find(&exams).Error
	return exams, err
}
func (r *ExamRepository) FindPublicPaged(subjectID string, limit, offset int) ([]entity.Exam, int64, error) {
	var exams []entity.Exam
	var total int64
	query := r.publishedPublicQuery()
	if subjectID != "" {
		query = query.Where("subject_id = ?", subjectID)
	}
	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	err := query.Order("id desc").Limit(limit).Offset(offset).Find(&exams).Error
	return exams, total, err
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
	err := r.availableForStudent(studentID).Order("id desc").Find(&exams).Error
	return exams, err
}

func (r *ExamRepository) FindAvailableForStudentPaged(studentID interface{}, limit, offset int) ([]entity.Exam, int64, error) {
	var exams []entity.Exam
	query := r.availableForStudent(studentID)
	var total int64
	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	err := query.Order("id desc").Limit(limit).Offset(offset).Find(&exams).Error
	return exams, total, err
}

func (r *ExamRepository) availableForStudent(studentID interface{}) *gorm.DB {
	return r.withVerifiedQuestions(r.db.Model(&entity.Exam{})).Where(
		"status = ? AND (access_type = ? OR id IN (?))",
		"published", "public",
		r.db.Model(&entity.ExamClass{}).Select("exam_id").
			Where("class_id IN (?)",
				r.db.Model(&entity.ClassStudent{}).Select("class_id").
					Where("student_id = ?", studentID),
			),
	)
}

func (r *ExamRepository) publishedPublicQuery() *gorm.DB {
	return r.withVerifiedQuestions(r.db.Model(&entity.Exam{})).Where("status = ? AND access_type = ?", "published", "public")
}

func (r *ExamRepository) withVerifiedQuestions(query *gorm.DB) *gorm.DB {
	return query.Where(`EXISTS (SELECT 1 FROM exam_questions eq WHERE eq.exam_id = exams.id)
AND NOT EXISTS (
  SELECT 1 FROM exam_questions eq
  LEFT JOIN questions q ON q.id = eq.question_id
  LEFT JOIN sources s ON s.id = q.source_id
  WHERE eq.exam_id = exams.id
    AND (q.id IS NULL OR q.status <> 'active' OR q.review_status <> 'approved' OR s.id IS NULL OR s.verification_status <> 'verified')
)`)
}

func (r *ExamRepository) HasVerifiedQuestionSet(examID uint) bool {
	var total, invalid int64
	r.db.Model(&entity.ExamQuestion{}).Where("exam_id = ?", examID).Count(&total)
	if total == 0 {
		return false
	}
	r.db.Table("exam_questions eq").
		Joins("LEFT JOIN questions q ON q.id = eq.question_id").
		Joins("LEFT JOIN sources s ON s.id = q.source_id").
		Where("eq.exam_id = ? AND (q.id IS NULL OR q.status <> ? OR q.review_status <> ? OR s.id IS NULL OR s.verification_status <> ?)", examID, "active", "approved", "verified").
		Count(&invalid)
	return invalid == 0
}
