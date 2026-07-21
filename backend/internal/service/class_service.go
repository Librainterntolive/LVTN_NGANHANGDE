package service

import (
	"errors"
	"math/rand"
	"time"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/entity"
	"quiz-backend/internal/repository"
)

type ClassService struct {
	repo     *repository.ClassRepository
	userRepo *repository.UserRepository
}

func NewClassService(repo *repository.ClassRepository, userRepo *repository.UserRepository) *ClassService {
	return &ClassService{repo: repo, userRepo: userRepo}
}

// sinh mã lớp ngẫu nhiên 6 ký tự (không trùng)
func (s *ClassService) genCode() string {
	const charset = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	for {
		b := make([]byte, 6)
		for i := range b {
			b[i] = charset[r.Intn(len(charset))]
		}
		code := string(b)
		if !s.repo.CodeExists(code) {
			return code
		}
	}
}

func (s *ClassService) userNameMap() map[uint]string {
	m := map[uint]string{}
	users, _ := s.userRepo.FindAll()
	for _, u := range users {
		name := u.FullName
		if name == "" {
			name = u.Username
		}
		m[u.ID] = name
	}
	return m
}

// GetAll: Teacher chỉ thấy lớp của mình, Admin thấy tất cả
func (s *ClassService) GetAll(role string, userID uint) ([]entity.Class, error) {
	var classes []entity.Class
	var err error
	if role == "Teacher" {
		classes, err = s.repo.FindByCreator(userID)
	} else {
		classes, err = s.repo.FindAll()
	}
	if err != nil {
		return nil, err
	}
	s.fillInfo(classes)
	return classes, nil
}

// fillInfo: điền tên GV + số sinh viên + số đề đã giao cho danh sách lớp
func (s *ClassService) fillInfo(classes []entity.Class) {
	names := s.userNameMap()
	studentCounts, _ := s.repo.StudentCounts()
	examCounts, _ := s.repo.ExamCounts()
	for i := range classes {
		classes[i].CreatorName = names[classes[i].CreatedBy]
		classes[i].StudentCount = studentCounts[classes[i].ID]
		classes[i].ExamCount = examCounts[classes[i].ID]
	}
}

// GetExams: đề thi đã giao cho lớp
func (s *ClassService) GetExams(classID string) ([]entity.Exam, error) {
	return s.repo.FindExams(classID)
}

func (s *ClassService) Create(in dto.ClassInput, createdBy uint) (*entity.Class, error) {
	class := &entity.Class{
		Name: in.Name, Description: in.Description, IsPublic: in.IsPublic,
		CreatedBy: createdBy, Code: s.genCode(),
	}
	err := s.repo.Create(class)
	return class, err
}

// lớp có thể giao đề: Admin thấy tất cả; GV thấy lớp của mình + lớp dùng chung
func (s *ClassService) GetAssignable(role string, userID uint) ([]entity.Class, error) {
	var classes []entity.Class
	var err error
	if role == "Admin" {
		classes, err = s.repo.FindAll()
	} else {
		classes, err = s.repo.FindAssignable(userID)
	}
	if err != nil {
		return nil, err
	}
	s.fillInfo(classes)
	return classes, nil
}

func (s *ClassService) Update(id string, in dto.ClassInput) (*entity.Class, error) {
	class, err := s.repo.FindByID(id)
	if err != nil {
		return nil, err
	}
	class.Name = in.Name
	class.Description = in.Description
	class.IsPublic = in.IsPublic
	err = s.repo.Update(class)
	return class, err
}

func (s *ClassService) Delete(id string) error {
	return s.repo.Delete(id)
}

func (s *ClassService) GetStudents(classID string) ([]entity.User, error) {
	return s.repo.FindStudents(classID)
}

func (s *ClassService) AddStudent(classID string, studentID uint) error {
	class, err := s.repo.FindByID(classID)
	if err != nil {
		return err
	}
	return s.repo.AddStudent(class.ID, studentID)
}

func (s *ClassService) RemoveStudent(classID, studentID string) error {
	return s.repo.RemoveStudent(classID, studentID)
}

// SV tự tham gia lớp bằng mã
func (s *ClassService) JoinByCode(code string, studentID uint) (*entity.Class, error) {
	class, err := s.repo.FindByCode(code)
	if err != nil {
		return nil, errors.New("ma lop khong dung")
	}
	if s.repo.IsStudentIn(class.ID, studentID) {
		return class, nil // đã ở trong lớp, coi như thành công
	}
	if err := s.repo.AddStudent(class.ID, studentID); err != nil {
		return nil, err
	}
	return class, nil
}

// lớp của 1 sinh viên (kèm tên GV)
func (s *ClassService) GetMyClasses(studentID uint) ([]entity.Class, error) {
	classes, err := s.repo.FindByStudent(studentID)
	if err != nil {
		return nil, err
	}
	names := s.userNameMap()
	for i := range classes {
		classes[i].CreatorName = names[classes[i].CreatedBy]
	}
	return classes, nil
}
