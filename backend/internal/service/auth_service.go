package service

import (
	"errors"
	"fmt"
	"time"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/entity"
	"quiz-backend/internal/repository"
	"quiz-backend/pkg"

	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	userRepo *repository.UserRepository
}

const maxOTPAttempts = 5
const otpResendCooldown = time.Minute

func NewAuthService(userRepo *repository.UserRepository) *AuthService {
	return &AuthService{userRepo: userRepo}
}

func (s *AuthService) Register(in dto.RegisterInput) (*entity.User, error) {
	email := emailOrNil(in.Email)
	if email == nil {
		return nil, errors.New("Email là bắt buộc để xác minh")
	}
	hash, err := bcrypt.GenerateFromPassword([]byte(in.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, errors.New("Mật khẩu không hợp lệ (tối đa 72 ký tự)")
	}
	user := &entity.User{
		Username:     in.Username,
		Email:        email,
		PasswordHash: string(hash),
		FullName:     in.FullName,
		Role:         "Student",
		Status:       "pending_verification",
	}
	if err := s.userRepo.Create(user); err != nil {
		return nil, errors.New("Tên đăng nhập hoặc email đã tồn tại")
	}
	code, err := NewOTP()
	if err != nil {
		return nil, err
	}
	otpHash, _ := bcrypt.GenerateFromPassword([]byte(code), bcrypt.DefaultCost)
	if err = s.userRepo.SaveOTP(&entity.EmailOTP{UserID: user.ID, Purpose: "registration", CodeHash: string(otpHash), ExpiresAt: time.Now().Add(10 * time.Minute)}); err != nil {
		return nil, err
	}
	if err = SendOTP(*user.Email, code); err != nil {
		return user, err
	}
	return user, nil
}
func (s *AuthService) VerifyOTP(email, code string) error {
	user, err := s.userRepo.FindByEmail(email)
	if err != nil {
		return errors.New("Email không tồn tại")
	}
	if user.Status == "active" {
		return errors.New("Email đã được xác minh")
	}
	otp, err := s.userRepo.LatestOTP(user.ID, "registration")
	if err != nil || time.Now().After(otp.ExpiresAt) {
		return errors.New("Mã OTP không hợp lệ hoặc đã hết hạn")
	}
	if otp.Attempts >= maxOTPAttempts {
		return errors.New("Mã OTP đã nhập sai quá nhiều lần, hãy gửi lại mã mới")
	}
	if bcrypt.CompareHashAndPassword([]byte(otp.CodeHash), []byte(code)) != nil {
		_ = s.userRepo.IncrementOTPAttempts(otp.ID)
		return errors.New("Mã OTP không hợp lệ hoặc đã hết hạn")
	}
	_ = s.userRepo.ExpireOTP(otp.ID)
	user.Status = "active"
	return s.userRepo.Update(user)
}
func (s *AuthService) ResendOTP(email string) error {
	user, err := s.userRepo.FindByEmail(email)
	if err != nil {
		return errors.New("Email không tồn tại")
	}
	if user.Status == "active" {
		return errors.New("Email đã được xác minh")
	}
	if err := s.enforceOTPCooldown(user.ID, "registration"); err != nil {
		return err
	}
	code, err := NewOTP()
	if err != nil {
		return err
	}
	hash, _ := bcrypt.GenerateFromPassword([]byte(code), bcrypt.DefaultCost)
	if err = s.userRepo.SaveOTP(&entity.EmailOTP{UserID: user.ID, Purpose: "registration", CodeHash: string(hash), ExpiresAt: time.Now().Add(10 * time.Minute)}); err != nil {
		return err
	}
	return SendOTP(email, code)
}
func (s *AuthService) SendPasswordResetOTP(email string) error {
	user, err := s.userRepo.FindByEmail(email)
	if err != nil {
		return errors.New("Email không tồn tại")
	}
	if user.Status != "active" {
		return errors.New("Tài khoản chưa xác minh email")
	}
	if err := s.enforceOTPCooldown(user.ID, "password_reset"); err != nil {
		return err
	}
	code, err := NewOTP()
	if err != nil {
		return err
	}
	hash, _ := bcrypt.GenerateFromPassword([]byte(code), bcrypt.DefaultCost)
	if err = s.userRepo.SaveOTP(&entity.EmailOTP{UserID: user.ID, Purpose: "password_reset", CodeHash: string(hash), ExpiresAt: time.Now().Add(10 * time.Minute)}); err != nil {
		return err
	}
	return SendOTP(email, code)
}
func (s *AuthService) RequestPasswordReset(in dto.ForgotPasswordInput) error {
	user, err := s.userRepo.FindByEmail(in.Email)
	if err != nil {
		return errors.New("Email không tồn tại")
	}
	if user.Status != "active" {
		return errors.New("Tài khoản chưa xác minh email")
	}
	hasPending, err := s.userRepo.HasPendingResetRequest(user.ID)
	if err != nil {
		return err
	}
	if hasPending {
		return errors.New("Yêu cầu cấp lại mật khẩu đang chờ Admin duyệt")
	}
	otp, err := s.userRepo.LatestOTP(user.ID, "password_reset")
	if err != nil || time.Now().After(otp.ExpiresAt) {
		return errors.New("OTP không hợp lệ")
	}
	if otp.Attempts >= maxOTPAttempts {
		return errors.New("OTP đã nhập sai quá nhiều lần, hãy gửi lại mã mới")
	}
	if bcrypt.CompareHashAndPassword([]byte(otp.CodeHash), []byte(in.Code)) != nil {
		_ = s.userRepo.IncrementOTPAttempts(otp.ID)
		return errors.New("OTP không hợp lệ")
	}
	_ = s.userRepo.ExpireOTP(otp.ID)
	return s.userRepo.CreateResetRequest(&entity.PasswordResetRequest{UserID: user.ID, Status: "pending"})
}

func (s *AuthService) enforceOTPCooldown(userID uint, purpose string) error {
	otp, err := s.userRepo.LatestOTP(userID, purpose)
	if err != nil || time.Now().After(otp.ExpiresAt) {
		return nil
	}
	issuedAt := otp.ExpiresAt.Add(-10 * time.Minute)
	if time.Since(issuedAt) < otpResendCooldown {
		return errors.New("Vui lòng đợi ít nhất 1 phút trước khi gửi lại OTP")
	}
	return nil
}
func (s *AuthService) ChangePassword(userID uint, in dto.ChangePasswordInput) error {
	user, err := s.userRepo.FindByID(fmt.Sprint(userID))
	if err != nil || bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(in.CurrentPassword)) != nil {
		return errors.New("Mật khẩu hiện tại không đúng")
	}
	hash, err := bcrypt.GenerateFromPassword([]byte(in.NewPassword), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	user.PasswordHash = string(hash)
	user.MustChangePassword = false
	return s.userRepo.Update(user)
}
func (s *AuthService) PendingResetRequests() ([]entity.PasswordResetRequest, error) {
	return s.userRepo.PendingResetRequests()
}
func (s *AuthService) PendingResetRequestsPaged(limit, offset int) ([]entity.PasswordResetRequest, int64, error) {
	return s.userRepo.PendingResetRequestsPaged(limit, offset)
}
func (s *AuthService) ApproveResetRequest(id string) error {
	request, err := s.userRepo.FindResetRequest(id)
	if err != nil || request.Status != "pending" {
		return errors.New("Yêu cầu không hợp lệ")
	}
	user, err := s.userRepo.FindByID(fmt.Sprint(request.UserID))
	if err != nil || user.Email == nil {
		return errors.New("Không tìm thấy email tài khoản")
	}
	temporary, err := NewTemporaryPassword()
	if err != nil {
		return err
	}
	hash, _ := bcrypt.GenerateFromPassword([]byte(temporary), bcrypt.DefaultCost)
	user.PasswordHash = string(hash)
	user.MustChangePassword = true
	if err = s.userRepo.Update(user); err != nil {
		return err
	}
	now := time.Now()
	request.Status = "approved"
	request.ApprovedAt = &now
	if err = s.userRepo.UpdateResetRequest(request); err != nil {
		return err
	}
	return SendTemporaryPassword(*user.Email, temporary)
}

// Login: trả token + user nếu đúng
func (s *AuthService) Login(in dto.LoginInput) (string, *entity.User, error) {
	user, err := s.userRepo.FindByUsername(in.Username)
	if err != nil {
		return "", nil, errors.New("Sai tài khoản hoặc mật khẩu")
	}
	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(in.Password)); err != nil {
		return "", nil, errors.New("Sai tài khoản hoặc mật khẩu")
	}
	// tài khoản bị tạm khóa -> từ chối, báo lý do
	if user.Status == "locked" {
		msg := "Tai khoan da bi tam khoa"
		if user.LockReason != "" {
			msg += ": " + user.LockReason
		}
		return "", nil, errors.New(msg)
	}
	if user.Status != "active" {
		return "", nil, errors.New("Tài khoản chưa xác minh email. Hãy nhập mã OTP đã gửi qua Gmail")
	}
	token, err := pkg.GenerateToken(user.ID, user.Username, user.Role)
	if err != nil {
		return "", nil, errors.New("Không tạo được token")
	}
	return token, user, nil
}
