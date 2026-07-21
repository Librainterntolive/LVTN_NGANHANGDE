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

// lớp có thể giao đề: của mình HOẶC lớp dùng chung
func (r *ClassRepository) FindAssignable(userID uint) ([]entity.Class, error) {
	var classes []entity.Class
	err := r.db.Where("created_by = ? OR is_public = ?", userID, true).
		Order("id desc").Find(&classes).Error
	return classes, err
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

func (r *ClassRepository) Delete(id string) error {
	r.db.Where("class_id = ?", id).Delete(&entity.ClassStudent{})
	return r.db.Delete(&entity.Class{}, id).Error
}

// StudentCounts: số sinh viên của từng lớp
func (r *ClassRepository) StudentCounts() (map[uint]int64, error) {
	var rows []struct {
		ClassID uint
		N       int64
	}
	err := r.db.Model(&entity.ClassStudent{}).
		Select("class_id, count(*) as n").Group("class_id").Scan(&rows).Error
	m := map[uint]int64{}
	for _, row := range rows {
		m[row.ClassID] = row.N
	}
	return m, err
}

// ExamCounts: số đề thi đã giao cho từng lớp
func (r *ClassRepository) ExamCounts() (map[uint]int64, error) {
	var rows []struct {
		ClassID uint
		N       int64
	}
	err := r.db.Model(&entity.ExamClass{}).
		Select("class_id, count(*) as n").Group("class_id").Scan(&rows).Error
	m := map[uint]int64{}
	for _, row := range rows {
		m[row.ClassID] = row.N
	}
	return m, err
}

// FindExams: các đề thi đã giao cho 1 lớp
func (r *ClassRepository) FindExams(classID string) ([]entity.Exam, error) {
	var exams []entity.Exam
	err := r.db.Joins("JOIN exam_classes ec ON ec.exam_id = exams.id").
		Where("ec.class_id = ?", classID).Order("exams.id desc").Find(&exams).Error
	return exams, err
}

// Sinh viên trong lớp
func (r *ClassRepository) FindStudents(classID string) ([]entity.User, error) {
	var students []entity.User
	err := r.db.Joins("JOIN class_students cs ON cs.student_id = users.id").
		Where("cs.class_id = ?", classID).Find(&students).Error
	return students, err
}

func (r *ClassRepository) AddStudent(classID, studentID uint) error {
	return r.db.Create(&entity.ClassStudent{ClassID: classID, StudentID: studentID}).Error
}

func (r *ClassRepository) RemoveStudent(classID, studentID string) error {
	return r.db.Where("class_id = ? AND student_id = ?", classID, studentID).
		Delete(&entity.ClassStudent{}).Error
}
