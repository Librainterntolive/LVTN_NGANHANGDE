package config

import (
	"fmt"
	"log"
	"os"

	"quiz-backend/internal/entity"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

// DB là kết nối CSDL dùng chung
var DB *gorm.DB

// ConnectDatabase mở kết nối MySQL và tự động tạo bảng
func ConnectDatabase() {
	dsn := fmt.Sprintf(
		"%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWORD"),
		os.Getenv("DB_HOST"),
		os.Getenv("DB_PORT"),
		os.Getenv("DB_NAME"),
	)

	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Khong ket noi duoc CSDL: ", err)
	}

	if err := db.AutoMigrate(entity.AllModels()...); err != nil {
		log.Fatal("AutoMigrate that bai: ", err)
	}

	DB = db
	log.Println("Da ket noi CSDL va migrate xong.")
}
