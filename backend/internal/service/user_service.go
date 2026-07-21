package service

import (
	"errors"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/entity"
	"quiz-backend/internal/repository"

	"golang.org/x/crypto/bcrypt"
)

type UserService struct {
	repo *repository.UserRepository
}

func NewUserService(repo *repository.UserRepository) *UserService {
	return &UserService{repo: repo}
}

func (s *UserService) GetAll() ([]entity.User, error) {
	return s.repo.FindAll()
}

func (s *UserService) Create(in dto.UserInput) (*entity.User, error) {
	if in.Password == "" {
		return nil, errors.New("can nhap mat khau")
	}
	hash, _ := bcrypt.GenerateFromPassword([]byte(in.Password), bcrypt.DefaultCost)
	user := &entity.User{
		Username:     in.Username,
		Email:        in.Email,
		PasswordHash: string(hash),
		FullName:     in.FullName,
		Role:         defaultStr(in.Role, "Student"),
		Status:       defaultStr(in.Status, "active"),
	}
	if err := s.repo.Create(user); err != nil {
		return nil, errors.New("username/email da ton tai")
	}
	return user, nil
}

func (s *UserService) Update(id string, in dto.UserInput) (*entity.User, error) {
	user, err := s.repo.FindByID(id)
	if err != nil {
		return nil, err
	}
	user.FullName = in.FullName
	user.Email = in.Email
	if in.Role != "" {
		user.Role = in.Role
	}
	if in.Status != "" {
		user.Status = in.Status
	}
	// khóa -> lưu lý do; mở khóa -> xóa lý do
	if user.Status == "locked" {
		user.LockReason = in.LockReason
	} else {
		user.LockReason = ""
	}
	if in.Password != "" {
		hash, _ := bcrypt.GenerateFromPassword([]byte(in.Password), bcrypt.DefaultCost)
		user.PasswordHash = string(hash)
	}
	err = s.repo.Update(user)
	return user, err
}

func (s *UserService) Delete(id string) error {
	return s.repo.Delete(id)
}
