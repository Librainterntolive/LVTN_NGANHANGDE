package service

import (
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

func (s *SubjectService) Delete(id string) error {
	return s.repo.Delete(id)
}
