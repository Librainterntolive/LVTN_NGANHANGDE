package repository

import (
	"quiz-backend/internal/entity"

	"gorm.io/gorm"
)

type ClassRepository struct {
	db *gorm.DB
}

func NewClassRepository(db *gorm.DB) *ClassRepository {
	return &ClassRepository{db: db}
}

func (r *ClassRepository) FindAll() ([]entity.Class, error) {
	var classes []entity.Class
	err := r.db.Order("id desc").Find(&classes).Error
	return classes, err
}

// lớp do 1 giáo viên tạo
func (r *ClassRepository) FindByCreator(createdBy uint) ([]entity.Class, error) {
	var classes []entity.Class
	err := r.db.Where("created_by = ?", createdBy).Order("id desc").Find(&classes).Error
	return classes, err
}
func (r *ClassRepository) FindPaged(createdBy uint, all bool, limit, offset int) ([]entity.Class, int64, error) {
	var rows []entity.Class
	var total int64
	query := r.db.Model(&entity.Class{})
	if !all {
		query = query.Where("created_by = ?", createdBy)
	}
	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	err := query.Order("id desc").Limit(limit).Offset(offset).Find(&rows).Error
	return rows, total, err
}

// lớp có thể giao đề: của mình HOẶC lớp dùng chung
func (r *ClassRepository) FindAssignable(userID uint) ([]entity.Class, error) {
	var classes []entity.Class
	err := r.db.Where("created_by = ? OR is_public = ?", userID, true).
		Order("id desc").Find(&classes).Error
	return classes, err
}

func (r *ClassRepository) FindAssignablePaged(userID uint, limit, offset int) ([]entity.Class, int64, error) {
	var classes []entity.Class
	var total int64
	query := r.db.Model(&entity.Class{}).Where("created_by = ? OR is_public = ?", userID, true)
	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	err := query.Order("id desc").Limit(limit).Offset(offset).Find(&classes).Error
	return classes, total, err
}

// tìm lớp theo mã tham gia
func (r *ClassRepository) FindByCode(code string) (*entity.Class, error) {
	var class entity.Class
	err := r.db.Where("code = ?", code).First(&class).Error
	return &class, err
}

// kiểm tra mã đã tồn tại chưa
func (r *ClassRepository) CodeExists(code string) bool {
	var n int64
	r.db.Model(&entity.Class{}).Where("code = ?", code).Count(&n)
	return n > 0
}

// các lớp mà 1 sinh viên đã tham gia
func (r *ClassRepository) FindByStudent(studentID uint) ([]entity.Class, error) {
	var classes []entity.Class
	err := r.db.Joins("JOIN class_students cs ON cs.class_id = classes.id").
		Where("cs.student_id = ?", studentID).Order("classes.id desc").Find(&classes).Error
	return classes, err
}

func (r *ClassRepository) FindByStudentPaged(studentID uint, limit, offset int) ([]entity.Class, int64, error) {
	var classes []entity.Class
	query := r.db.Model(&entity.Class{}).
		Joins("JOIN class_students cs ON cs.class_id = classes.id").
		Where("cs.student_id = ?", studentID)
	var total int64
	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	err := query.Order("classes.id desc").Limit(limit).Offset(offset).Find(&classes).Error
	return classes, total, err
}

// kiểm tra SV đã trong lớp chưa
func (r *ClassRepository) IsStudentIn(classID, studentID uint) bool {
	var n int64
	r.db.Model(&entity.ClassStudent{}).Where("class_id = ? AND student_id = ?", classID, studentID).Count(&n)
	return n > 0
}

func (r *ClassRepository) FindByID(id string) (*entity.Class, error) {
	var class entity.Class
	err := r.db.First(&class, id).Error
	return &class, err
}

func (r *ClassRepository) Create(c *entity.Class) error {
	return r.db.Create(c).Error
}

func (r *ClassRepository) Update(c *entity.Class) error {
	return r.db.Save(c).Error
}

// Delete: xóa lớp + danh sách sinh viên + các liên kết giao đề cho lớp
func (r *ClassRepository) Delete(id string) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Where("class_id = ?", id).Delete(&entity.ClassPost{}).Error; err != nil {
			return err
		}
		if err := tx.Where("class_id = ?", id).Delete(&entity.ClassStudent{}).Error; err != nil {
			return err
		}
		if err := tx.Where("class_id = ?", id).Delete(&entity.ExamClass{}).Error; err != nil {
			return err
		}
		return tx.Delete(&entity.Class{}, id).Error
	})
}

// StudentCounts: số sinh viên của từng lớp
func (r *ClassRepository) StudentCounts(classIDs []uint) (map[uint]int64, error) {
	counts := map[uint]int64{}
	if len(classIDs) == 0 {
		return counts, nil
	}
	var rows []struct {
		ClassID uint
		N       int64
	}
	err := r.db.Model(&entity.ClassStudent{}).
		Where("class_id IN ?", classIDs).
		Select("class_id, count(*) as n").Group("class_id").Scan(&rows).Error
	for _, row := range rows {
		counts[row.ClassID] = row.N
	}
	return counts, err
}

// ExamCounts: số đề thi đã giao cho từng lớp
func (r *ClassRepository) ExamCounts(classIDs []uint) (map[uint]int64, error) {
	counts := map[uint]int64{}
	if len(classIDs) == 0 {
		return counts, nil
	}
	var rows []struct {
		ClassID uint
		N       int64
	}
	err := r.db.Model(&entity.ExamClass{}).
		Where("class_id IN ?", classIDs).
		Select("class_id, count(*) as n").Group("class_id").Scan(&rows).Error
	for _, row := range rows {
		counts[row.ClassID] = row.N
	}
	return counts, err
}

// FindExams: các đề thi đã giao cho 1 lớp
func (r *ClassRepository) FindExams(classID string) ([]entity.Exam, error) {
	var exams []entity.Exam
	err := r.db.Joins("JOIN exam_classes ec ON ec.exam_id = exams.id").
		Where("ec.class_id = ?", classID).Order("ec.exam_id desc").Find(&exams).Error
	return exams, err
}

func (r *ClassRepository) FindExamsPaged(classID string, limit, offset int) ([]entity.Exam, int64, error) {
	var exams []entity.Exam
	query := r.db.Model(&entity.Exam{}).Joins("JOIN exam_classes ec ON ec.exam_id = exams.id").
		Where("ec.class_id = ?", classID)
	var total int64
	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	err := query.Order("ec.exam_id desc").Limit(limit).Offset(offset).Find(&exams).Error
	return exams, total, err
}

// Sinh viên trong lớp
func (r *ClassRepository) FindStudents(classID string) ([]entity.User, error) {
	var students []entity.User
	err := r.db.Joins("JOIN class_students cs ON cs.student_id = users.id").
		Where("cs.class_id = ?", classID).Find(&students).Error
	return students, err
}

func (r *ClassRepository) FindStudentsPaged(classID string, limit, offset int) ([]entity.User, int64, error) {
	var students []entity.User
	query := r.db.Model(&entity.User{}).Joins("JOIN class_students cs ON cs.student_id = users.id").Where("cs.class_id = ?", classID)
	var total int64
	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	err := query.Order("users.full_name asc, users.username asc").Limit(limit).Offset(offset).Find(&students).Error
	return students, total, err
}

func (r *ClassRepository) AddStudent(classID, studentID uint) error {
	return r.db.Create(&entity.ClassStudent{ClassID: classID, StudentID: studentID}).Error
}

func (r *ClassRepository) RemoveStudent(classID, studentID string) error {
	result := r.db.Where("class_id = ? AND student_id = ?", classID, studentID).
		Delete(&entity.ClassStudent{})
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}
	return nil
}
