package service

import (
	"errors"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/entity"
	"quiz-backend/internal/repository"
	"quiz-backend/pkg"

	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	userRepo *repository.UserRepository
}

func NewAuthService(userRepo *repository.UserRepository) *AuthService {
	return &AuthService{userRepo: userRepo}
}

func (s *AuthService) Register(in dto.RegisterInput) (*entity.User, error) {
	hash, err := bcrypt.GenerateFromPassword([]byte(in.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, errors.New("khong ma hoa duoc mat khau")
	}
	user := &entity.User{
		Username:     in.Username,
		Email:        in.Email,
		PasswordHash: string(hash),
		FullName:     in.FullName,
		Role:         defaultStr(in.Role, "Student"),
		Status:       "active",
	}
	if err := s.userRepo.Create(user); err != nil {
		return nil, errors.New("username hoac email da ton tai")
	}
	return user, nil
}

// Login: trả token + user nếu đúng
func (s *AuthService) Login(in dto.LoginInput) (string, *entity.User, error) {
	user, err := s.userRepo.FindByUsername(in.Username)
	if err != nil {
		return "", nil, errors.New("sai tai khoan hoac mat khau")
	}
	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(in.Password)); err != nil {
		return "", nil, errors.New("sai tai khoan hoac mat khau")
	}
	// tài khoản bị tạm khóa -> từ chối, báo lý do
	if user.Status == "locked" {
		msg := "Tai khoan da bi tam khoa"
		if user.LockReason != "" {
			msg += ": " + user.LockReason
		}
		return "", nil, errors.New(msg)
	}
	token, err := pkg.GenerateToken(user.ID, user.Username, user.Role)
	if err != nil {
		return "", nil, errors.New("khong tao duoc token")
	}
	return token, user, nil
}
