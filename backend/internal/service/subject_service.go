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

// GetAll: mặc định chỉ trả môn đang dùng.
// includeHidden = true (màn hình quản lý môn học) thì trả cả môn đã tạm ẩn.
func (s *SubjectService) GetAll(includeHidden bool) ([]entity.Subject, error) {
	if includeHidden {
		return s.repo.FindAllIncludingHidden()
	}
	return s.repo.FindAll()
}

func normalizeSubjectPaging(page, limit int) (int, int) {
	if page < 1 {
		page = 1
	}
	if limit < 1 {
		limit = 12
	}
	if limit > 15 {
		limit = 15
	}
	return page, limit
}

func (s *SubjectService) GetPaged(includeHidden bool, level, keyword string, page, limit int) ([]entity.Subject, int64, int, int, error) {
	page, limit = normalizeSubjectPaging(page, limit)
	items, total, err := s.repo.FindPaged(includeHidden, level, keyword, limit, (page-1)*limit)
	return items, total, page, limit, err
}

func (s *SubjectService) GetByID(id string) (*entity.Subject, error) {
	return s.repo.FindByID(id)
}

func (s *SubjectService) Create(in dto.SubjectInput) (*entity.Subject, error) {
	subject := &entity.Subject{
		Name: in.Name, Level: defaultStr(in.Level, "Khác"),
		Description: in.Description, Hidden: in.Hidden,
	}
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
	subject.Hidden = in.Hidden
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
