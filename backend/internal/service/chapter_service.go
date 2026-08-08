package service

import (
	"errors"
	"strings"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/entity"
	"quiz-backend/internal/repository"
)

type ChapterService struct {
	repo *repository.ChapterRepository
}

func NewChapterService(repo *repository.ChapterRepository) *ChapterService {
	return &ChapterService{repo: repo}
}

// GetBySubject: danh sách chương của môn (kèm số câu hỏi mỗi chương)
func (s *ChapterService) GetBySubject(subjectID string) ([]entity.Chapter, error) {
	chapters, err := s.repo.FindBySubject(subjectID)
	if err != nil {
		return nil, err
	}
	counts, _ := s.repo.QuestionCounts(subjectID)
	for i := range chapters {
		chapters[i].QuestionCount = counts[chapters[i].ID]
	}
	return chapters, nil
}

func (s *ChapterService) Create(in dto.ChapterInput) (*entity.Chapter, error) {
	name := strings.TrimSpace(in.Name)
	if name == "" {
		return nil, errors.New("Tên chương không được để trống")
	}
	chapter := &entity.Chapter{SubjectID: in.SubjectID, Name: name, OrderIndex: in.OrderIndex}
	err := s.repo.Create(chapter)
	return chapter, err
}

func (s *ChapterService) Update(id string, in dto.ChapterInput) (*entity.Chapter, error) {
	name := strings.TrimSpace(in.Name)
	if name == "" {
		return nil, errors.New("Tên chương không được để trống")
	}
	chapter, err := s.repo.FindByID(id)
	if err != nil {
		return nil, err
	}
	chapter.Name = name
	chapter.OrderIndex = in.OrderIndex
	err = s.repo.Update(chapter)
	return chapter, err
}

func (s *ChapterService) Delete(id string) error {
	return s.repo.Delete(id)
}
