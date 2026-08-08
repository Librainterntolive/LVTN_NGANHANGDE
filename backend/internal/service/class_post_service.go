package service

import (
	"errors"
	"log"
	"strconv"
	"strings"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/entity"
	"quiz-backend/internal/repository"
)

type ClassPostService struct {
	repo      *repository.ClassPostRepository
	classRepo *repository.ClassRepository
	userRepo  *repository.UserRepository
}

func NewClassPostService(repo *repository.ClassPostRepository, classRepo *repository.ClassRepository, userRepo *repository.UserRepository) *ClassPostService {
	return &ClassPostService{repo: repo, classRepo: classRepo, userRepo: userRepo}
}

func (s *ClassPostService) canView(classID uint, userID uint, role string) error {
	classroom, err := s.classRepo.FindByID(strconv.FormatUint(uint64(classID), 10))
	if err != nil {
		return errors.New("khong tim thay lop")
	}
	if role == "Student" {
		if !s.classRepo.IsStudentIn(classID, userID) {
			return ErrNotOwner
		}
		return nil
	}
	if role != "Admin" && classroom.CreatedBy != userID && !classroom.IsPublic {
		return ErrNotOwner
	}
	return nil
}

func (s *ClassPostService) canManage(classID uint, userID uint, role string) error {
	if role == "Student" || role == "" {
		return ErrNotOwner
	}
	return s.canView(classID, userID, role)
}

func (s *ClassPostService) withAuthorNames(items []entity.ClassPost) {
	ids := make([]uint, 0, len(items))
	for _, item := range items {
		ids = append(ids, item.CreatedBy)
	}
	names, err := s.userRepo.FindNameMap(ids)
	if err != nil {
		return
	}
	for index := range items {
		items[index].AuthorName = names[items[index].CreatedBy]
	}
}

func (s *ClassPostService) List(classID, userID uint, role string, limit, offset int) ([]entity.ClassPost, int64, error) {
	if err := s.canView(classID, userID, role); err != nil {
		return nil, 0, err
	}
	items, total, err := s.repo.FindPaged(classID, limit, offset)
	if err != nil {
		return nil, 0, err
	}
	s.withAuthorNames(items)
	return items, total, nil
}

func (s *ClassPostService) Create(classID, userID uint, role string, input dto.ClassPostInput) (*entity.ClassPost, error) {
	if err := s.canManage(classID, userID, role); err != nil {
		return nil, err
	}
	content := strings.TrimSpace(input.Content)
	if content == "" {
		return nil, errors.New("noi dung thong bao khong duoc de trong")
	}
	item := &entity.ClassPost{ClassID: classID, CreatedBy: userID, Content: content}
	if err := s.repo.Create(item); err != nil {
		return nil, err
	}
	go s.notifyClassPost(item)
	return item, nil
}

func (s *ClassPostService) notifyClassPost(item *entity.ClassPost) {
	classroom, err := s.classRepo.FindByID(strconv.FormatUint(uint64(item.ClassID), 10))
	if err != nil {
		return
	}
	author, err := s.userRepo.FindByID(strconv.FormatUint(uint64(item.CreatedBy), 10))
	if err != nil {
		return
	}
	authorName := author.FullName
	if authorName == "" {
		authorName = author.Username
	}
	students, err := s.classRepo.FindStudents(strconv.FormatUint(uint64(item.ClassID), 10))
	if err != nil {
		return
	}
	for _, student := range students {
		if student.Email == nil || *student.Email == "" {
			continue
		}
		if err := SendClassPostPublished(*student.Email, classroom.Name, authorName, item.Content); err != nil {
			log.Printf("gui email thong bao lop that bai: %v", err)
		}
	}
}

func (s *ClassPostService) Update(id string, userID uint, role string, input dto.ClassPostInput) (*entity.ClassPost, error) {
	item, err := s.repo.FindByID(id)
	if err != nil {
		return nil, err
	}
	if err := s.canManage(item.ClassID, userID, role); err != nil {
		return nil, err
	}
	content := strings.TrimSpace(input.Content)
	if content == "" {
		return nil, errors.New("noi dung thong bao khong duoc de trong")
	}
	item.Content = content
	if err := s.repo.Update(item); err != nil {
		return nil, err
	}
	return item, nil
}

func (s *ClassPostService) Delete(id string, userID uint, role string) (*entity.ClassPost, error) {
	item, err := s.repo.FindByID(id)
	if err != nil {
		return nil, err
	}
	if err := s.canManage(item.ClassID, userID, role); err != nil {
		return nil, err
	}
	if err := s.repo.Delete(id); err != nil {
		return nil, err
	}
	return item, nil
}
