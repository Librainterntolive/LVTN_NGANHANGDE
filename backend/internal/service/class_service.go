package service

import (
	cryptorand "crypto/rand"
	"errors"
	"fmt"
	"math/big"
	"strconv"
	"strings"

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
func (s *ClassService) genCode() (string, error) {
	const charset = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
	charsetLength := big.NewInt(int64(len(charset)))
	for {
		b := make([]byte, 6)
		for i := range b {
			index, err := cryptorand.Int(cryptorand.Reader, charsetLength)
			if err != nil {
				return "", err
			}
			b[i] = charset[index.Int64()]
		}
		code := string(b)
		if !s.repo.CodeExists(code) {
			return code, nil
		}
	}
}

func (s *ClassService) userNameMap(classes []entity.Class) map[uint]string {
	creatorIDs := make([]uint, 0, len(classes))
	for _, classroom := range classes {
		creatorIDs = append(creatorIDs, classroom.CreatedBy)
	}
	names, err := s.userRepo.FindNameMap(creatorIDs)
	if err != nil {
		return map[uint]string{}
	}
	return names
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
func (s *ClassService) GetPaged(role string, userID uint, keyword string, limit, offset int) ([]entity.Class, int64, error) {
	rows, total, err := s.repo.FindPaged(userID, role == "Admin", keyword, limit, offset)
	if err != nil {
		return nil, 0, err
	}
	s.fillInfo(rows)
	return rows, total, nil
}

func (s *ClassService) GetOne(id string, userID uint, role string) (*entity.Class, error) {
	class, err := s.repo.FindByID(id)
	if err != nil {
		return nil, errors.New("Không tìm thấy lớp")
	}
	if role == "Student" {
		if !s.repo.IsStudentIn(class.ID, userID) {
			return nil, ErrNotOwner
		}
	} else if _, err := s.canManageStudents(id, userID, role); err != nil {
		return nil, err
	}
	items := []entity.Class{*class}
	s.fillInfo(items)
	*class = items[0]
	return class, nil
}

// fillInfo: điền tên GV + số sinh viên + số đề đã giao cho danh sách lớp
func (s *ClassService) fillInfo(classes []entity.Class) {
	names := s.userNameMap(classes)
	classIDs := make([]uint, 0, len(classes))
	for _, classroom := range classes {
		classIDs = append(classIDs, classroom.ID)
	}
	studentCounts, _ := s.repo.StudentCounts(classIDs)
	examCounts, _ := s.repo.ExamCounts(classIDs)
	for i := range classes {
		classes[i].CreatorName = names[classes[i].CreatedBy]
		classes[i].StudentCount = studentCounts[classes[i].ID]
		classes[i].ExamCount = examCounts[classes[i].ID]
	}
}

// GetExams: đề thi đã giao cho lớp
func (s *ClassService) GetExams(classID string, userID uint, role string) ([]entity.Exam, error) {
	if _, err := s.canManageStudents(classID, userID, role); err != nil {
		return nil, err
	}
	return s.repo.FindExams(classID)
}

func (s *ClassService) GetExamsPaged(classID string, userID uint, role string, limit, offset int) ([]entity.Exam, int64, error) {
	if _, err := s.canManageStudents(classID, userID, role); err != nil {
		return nil, 0, err
	}
	return s.repo.FindExamsPaged(classID, limit, offset)
}

func (s *ClassService) Create(in dto.ClassInput, createdBy uint) (*entity.Class, error) {
	code, err := s.genCode()
	if err != nil {
		return nil, err
	}
	class := &entity.Class{
		Name: in.Name, Description: in.Description, IsPublic: in.IsPublic,
		CreatedBy: createdBy, Code: code,
	}
	err = s.repo.Create(class)
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

func (s *ClassService) GetAssignablePaged(role string, userID uint, keyword string, limit, offset int) ([]entity.Class, int64, error) {
	if role == "Admin" {
		rows, total, err := s.repo.FindPaged(userID, true, keyword, limit, offset)
		if err != nil {
			return nil, 0, err
		}
		s.fillInfo(rows)
		return rows, total, nil
	}
	rows, total, err := s.repo.FindAssignablePaged(userID, keyword, limit, offset)
	if err != nil {
		return nil, 0, err
	}
	s.fillInfo(rows)
	return rows, total, nil
}

func (s *ClassService) Update(id string, in dto.ClassInput, userID uint, role string) (*entity.Class, error) {
	class, err := s.repo.FindByID(id)
	if err != nil {
		return nil, err
	}
	if !canModify(class.CreatedBy, userID, role) {
		return nil, ErrNotOwner
	}
	class.Name = in.Name
	class.Description = in.Description
	class.IsPublic = in.IsPublic
	err = s.repo.Update(class)
	return class, err
}

func (s *ClassService) Delete(id string, userID uint, role string) error {
	class, err := s.repo.FindByID(id)
	if err != nil {
		return errors.New("Không tìm thấy lớp")
	}
	if !canModify(class.CreatedBy, userID, role) {
		return ErrNotOwner
	}
	return s.repo.Delete(id)
}

func (s *ClassService) canManageStudents(classID string, userID uint, role string) (*entity.Class, error) {
	class, err := s.repo.FindByID(classID)
	if err != nil {
		return nil, errors.New("Không tìm thấy lớp")
	}
	if !canModify(class.CreatedBy, userID, role) {
		return nil, ErrNotOwner
	}
	return class, nil
}

func (s *ClassService) GetStudents(classID string, userID uint, role string) ([]entity.User, error) {
	if _, err := s.canManageStudents(classID, userID, role); err != nil {
		return nil, err
	}
	return s.repo.FindStudents(classID)
}

func (s *ClassService) GetStudentsPaged(classID string, userID uint, role string, limit, offset int) ([]entity.User, int64, error) {
	if _, err := s.canManageStudents(classID, userID, role); err != nil {
		return nil, 0, err
	}
	return s.repo.FindStudentsPaged(classID, limit, offset)
}

func (s *ClassService) AddStudent(classID string, studentID uint, userID uint, role string) error {
	class, err := s.canManageStudents(classID, userID, role)
	if err != nil {
		return err
	}
	// chỉ thêm được tài khoản sinh viên vào lớp
	stu, err := s.userRepo.FindByID(strconv.Itoa(int(studentID)))
	if err != nil {
		return errors.New("Không tìm thấy tài khoản")
	}
	if stu.Role != "Student" {
		return errors.New("Chỉ thêm được tài khoản sinh viên vào lớp")
	}
	if err := s.repo.AddStudent(class.ID, studentID); err != nil {
		return err
	}
	if stu.Email != nil && *stu.Email != "" {
		go func(email, className, classCode string) {
			if err := SendClassJoined(email, className, classCode); err != nil {
				fmt.Printf("gui email them sinh vien that bai: %v\n", err)
			}
		}(*stu.Email, class.Name, class.Code)
	}
	return nil
}

func (s *ClassService) RemoveStudent(classID, studentID string, userID uint, role string) error {
	class, err := s.canManageStudents(classID, userID, role)
	if err != nil {
		return err
	}
	student, err := s.userRepo.FindByID(studentID)
	if err != nil {
		return errors.New("Không tìm thấy tài khoản")
	}
	if err := s.repo.RemoveStudent(classID, studentID); err != nil {
		return err
	}
	if student.Email != nil && *student.Email != "" {
		go func(email, className string) {
			if err := SendClassRemoved(email, className); err != nil {
				fmt.Printf("gui email xoa sinh vien that bai: %v\n", err)
			}
		}(*student.Email, class.Name)
	}
	return nil
}

// SV tự tham gia lớp bằng mã
func (s *ClassService) JoinByCode(code string, studentID uint) (*entity.Class, error) {
	class, err := s.repo.FindByCode(code)
	if err != nil {
		return nil, errors.New("Mã lớp không đúng")
	}
	if s.repo.IsStudentIn(class.ID, studentID) {
		return class, nil // đã ở trong lớp, coi như thành công
	}
	if err := s.repo.AddStudent(class.ID, studentID); err != nil {
		return nil, err
	}
	student, studentErr := s.userRepo.FindByID(strconv.FormatUint(uint64(studentID), 10))
	if studentErr == nil && student.Email != nil && *student.Email != "" {
		go func(email, className, classCode string) {
			if err := SendClassJoined(email, className, classCode); err != nil {
				fmt.Printf("gui email tham gia lop that bai: %v\n", err)
			}
		}(*student.Email, class.Name, class.Code)
	}
	return class, nil
}

// lớp của 1 sinh viên (kèm tên GV)
func (s *ClassService) GetMyClasses(studentID uint) ([]entity.Class, error) {
	classes, err := s.repo.FindByStudent(studentID)
	if err != nil {
		return nil, err
	}
	names := s.userNameMap(classes)
	for i := range classes {
		classes[i].CreatorName = names[classes[i].CreatedBy]
	}
	return classes, nil
}

func (s *ClassService) GetMyClassesPaged(studentID uint, limit, offset int) ([]entity.Class, int64, error) {
	classes, total, err := s.repo.FindByStudentPaged(studentID, limit, offset)
	if err != nil {
		return nil, 0, err
	}
	names := s.userNameMap(classes)
	for i := range classes {
		classes[i].CreatorName = names[classes[i].CreatedBy]
	}
	return classes, total, nil
}

func (s *ClassService) SearchStudents(keyword string) ([]entity.User, error) {
	keyword = strings.TrimSpace(keyword)
	if len(keyword) < 2 {
		return []entity.User{}, nil
	}
	return s.userRepo.FindStudentsByKeyword(keyword, 8)
}
