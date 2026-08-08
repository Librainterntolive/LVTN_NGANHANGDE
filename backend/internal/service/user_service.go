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
func (s *UserService) GetPaged(keyword string, limit, offset int) ([]entity.User, int64, error) {
	return s.repo.FindPaged(keyword, limit, offset)
}

func (s *UserService) Create(in dto.UserInput) (*entity.User, error) {
	if in.Password == "" {
		return nil, errors.New("can nhap mat khau")
	}
	// Bỏ qua lỗi ở đây thì mật khẩu dài quá 72 ký tự sẽ tạo ra tài khoản có
	// chuỗi băm rỗng - trông như tạo thành công nhưng không bao giờ đăng nhập được.
	hash, err := bcrypt.GenerateFromPassword([]byte(in.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, errors.New("mat khau khong hop le (toi da 72 ky tu)")
	}
	user := &entity.User{
		Username:     in.Username,
		Email:        emailOrNil(in.Email),
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
	user.Email = emailOrNil(in.Email)
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
		hash, err := bcrypt.GenerateFromPassword([]byte(in.Password), bcrypt.DefaultCost)
		if err != nil {
			return nil, errors.New("mat khau khong hop le (toi da 72 ky tu)")
		}
		user.PasswordHash = string(hash)
	}
	err = s.repo.Update(user)
	return user, err
}

func (s *UserService) Delete(id string) error {
	return s.repo.Delete(id)
}
