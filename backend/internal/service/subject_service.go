package service

import (
	"errors"
	"strconv"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/entity"
	"quiz-backend/internal/repository"
)

type SubjectService struct {
	repo *repository.SubjectRepository
}

func NewSubjectService(repo *repository.SubjectRepository) *SubjectService {
	return &SubjectService{repo: repo}
}

func (s *SubjectService) GetAll() ([]entity.Subject, error) {
	return s.repo.FindAll()
}

func (s *SubjectService) GetByID(id string) (*entity.Subject, error) {
	return s.repo.FindByID(id)
}

func (s *SubjectService) Create(in dto.SubjectInput) (*entity.Subject, error) {
	subject := &entity.Subject{Name: in.Name, Level: defaultStr(in.Level, "Khác"), Description: in.Description}
	err := s.repo.Create(subject)
	return subject, err
}

func (s *SubjectService) Update(id string, in dto.SubjectInput) (*entity.Subject, error) {
	subject, err := s.repo.FindByID(id)
	if err != nil {
		return nil, err
	}
	subject.Name = in.Name
	subject.Level = defaultStr(in.Level, "Khác")
	subject.Description = in.Description
	err = s.repo.Update(subject)
	return subject, err
}

// Delete: chặn xóa môn còn câu hỏi hoặc đề thi.
// Xóa thẳng sẽ để lại câu hỏi/đề trỏ tới môn không còn tồn tại.
func (s *SubjectService) Delete(id string) error {
	questions, exams := s.repo.CountUsage(id)
	if questions > 0 || exams > 0 {
		return errors.New("mon hoc dang co " + strconv.FormatInt(questions, 10) +
			" cau hoi va " + strconv.FormatInt(exams, 10) +
			" de thi, khong the xoa - hay chuyen hoac xoa chung truoc")
	}
	return s.repo.Delete(id)
}
