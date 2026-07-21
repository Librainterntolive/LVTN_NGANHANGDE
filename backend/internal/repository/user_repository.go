package repository

import (
	"quiz-backend/internal/entity"

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

func (r *UserRepository) Create(u *entity.User) error {
	return r.db.Create(u).Error
}

func (r *UserRepository) Update(u *entity.User) error {
	return r.db.Save(u).Error
}

func (r *UserRepository) Delete(id string) error {
	return r.db.Delete(&entity.User{}, id).Error
}
