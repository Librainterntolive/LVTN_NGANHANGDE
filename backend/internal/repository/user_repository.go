package repository

import (
	"quiz-backend/internal/entity"
	"time"

	"gorm.io/gorm"
)

type UserRepository struct {
	db *gorm.DB
}

func NewUserRepository(db *gorm.DB) *UserRepository {
	return &UserRepository{db: db}
}

func (r *UserRepository) FindAll() ([]entity.User, error) {
	var users []entity.User
	err := r.db.Order("id asc").Find(&users).Error
	return users, err
}
func (r *UserRepository) FindNameMap(userIDs []uint) (map[uint]string, error) {
	names := make(map[uint]string, len(userIDs))
	if len(userIDs) == 0 {
		return names, nil
	}
	var users []entity.User
	if err := r.db.Select("id", "full_name", "username").Where("id IN ?", userIDs).Find(&users).Error; err != nil {
		return nil, err
	}
	for _, user := range users {
		name := user.FullName
		if name == "" {
			name = user.Username
		}
		names[user.ID] = name
	}
	return names, nil
}
func (r *UserRepository) FindPaged(keyword string, limit, offset int) ([]entity.User, int64, error) {
	var users []entity.User
	var total int64
	query := r.db.Model(&entity.User{})
	if keyword != "" {
		pattern := "%" + keyword + "%"
		query = query.Where("username LIKE ? OR full_name LIKE ? OR email LIKE ?", pattern, pattern, pattern)
	}
	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	err := query.Order("id desc").Limit(limit).Offset(offset).Find(&users).Error
	return users, total, err
}

func (r *UserRepository) FindByID(id string) (*entity.User, error) {
	var user entity.User
	err := r.db.First(&user, id).Error
	return &user, err
}

func (r *UserRepository) FindByUsername(username string) (*entity.User, error) {
	var user entity.User
	err := r.db.Where("username = ?", username).First(&user).Error
	return &user, err
}
func (r *UserRepository) FindByEmail(email string) (*entity.User, error) {
	var user entity.User
	err := r.db.Where("email = ?", email).First(&user).Error
	return &user, err
}
func (r *UserRepository) FindStudentsByKeyword(keyword string, limit int) ([]entity.User, error) {
	var users []entity.User
	pattern := "%" + keyword + "%"
	err := r.db.Where("role = ? AND status = ? AND (username LIKE ? OR full_name LIKE ? OR email LIKE ?)", "Student", "active", pattern, pattern, pattern).
		Order("full_name asc, username asc").Limit(limit).Find(&users).Error
	return users, err
}
func (r *UserRepository) SaveOTP(otp *entity.EmailOTP) error { return r.db.Create(otp).Error }
func (r *UserRepository) LatestOTP(userID uint, purpose string) (*entity.EmailOTP, error) {
	var otp entity.EmailOTP
	err := r.db.Where("user_id = ? AND purpose = ?", userID, purpose).Order("id desc").First(&otp).Error
	return &otp, err
}
func (r *UserRepository) IncrementOTPAttempts(id uint) error {
	return r.db.Model(&entity.EmailOTP{}).Where("id = ?", id).UpdateColumn("attempts", gorm.Expr("attempts + ?", 1)).Error
}
func (r *UserRepository) ExpireOTP(id uint) error {
	return r.db.Model(&entity.EmailOTP{}).Where("id = ?", id).UpdateColumn("expires_at", time.Now()).Error
}
func (r *UserRepository) CreateResetRequest(item *entity.PasswordResetRequest) error {
	return r.db.Create(item).Error
}
func (r *UserRepository) HasPendingResetRequest(userID uint) (bool, error) {
	var total int64
	err := r.db.Model(&entity.PasswordResetRequest{}).Where("user_id = ? AND status = ?", userID, "pending").Count(&total).Error
	return total > 0, err
}
func (r *UserRepository) PendingResetRequests() ([]entity.PasswordResetRequest, error) {
	var rows []entity.PasswordResetRequest
	err := r.db.Where("status = ?", "pending").Order("created_at desc").Find(&rows).Error
	return rows, err
}
func (r *UserRepository) PendingResetRequestsPaged(limit, offset int) ([]entity.PasswordResetRequest, int64, error) {
	var rows []entity.PasswordResetRequest
	var total int64
	query := r.db.Model(&entity.PasswordResetRequest{}).Where("status = ?", "pending")
	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	err := query.Order("created_at desc").Limit(limit).Offset(offset).Find(&rows).Error
	return rows, total, err
}
func (r *UserRepository) FindResetRequest(id string) (*entity.PasswordResetRequest, error) {
	var row entity.PasswordResetRequest
	err := r.db.First(&row, id).Error
	return &row, err
}
func (r *UserRepository) UpdateResetRequest(item *entity.PasswordResetRequest) error {
	return r.db.Save(item).Error
}

func (r *UserRepository) Create(u *entity.User) error {
	return r.db.Create(u).Error
}

func (r *UserRepository) Update(u *entity.User) error {
	return r.db.Save(u).Error
}

func (r *UserRepository) Delete(id string) error {
	return r.db.Delete(&entity.User{}, id).Error
}
