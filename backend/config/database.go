package config

import (
	"fmt"
	"log"
	"os"
	"strings"
	"time"

	"quiz-backend/internal/entity"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

// DB là kết nối CSDL dùng chung
var DB *gorm.DB

// ConnectDatabase mở kết nối MySQL.
//
// AutoMigrate (đối chiếu 15 bảng với information_schema) là bước chậm nhất khi
// khởi động, mà cấu trúc bảng thì rất ít khi đổi. Vì vậy nó chỉ chạy khi đặt
// AUTO_MIGRATE=true trong .env - tức là sau khi sửa file entity.
func ConnectDatabase() {
	dsn := fmt.Sprintf(
		"%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWORD"),
		os.Getenv("DB_HOST"),
		os.Getenv("DB_PORT"),
		os.Getenv("DB_NAME"),
	)

	start := time.Now()
	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{
		// Mặc định GORM in ra MỌI câu SQL - rất chậm trên console Windows.
		// Mức Warn chỉ in cảnh báo và truy vấn chậm.
		Logger: logger.Default.LogMode(logger.Warn),
		// Không bọc mỗi lệnh ghi trong một transaction riêng (tăng tốc ghi).
		// Chỗ nào cần transaction thì gọi db.Transaction() tường minh.
		SkipDefaultTransaction: true,
		// Nhớ sẵn câu lệnh đã biên dịch, dùng lại cho các lần sau.
		PrepareStmt: true,
	})
	if err != nil {
		log.Fatal("Khong ket noi duoc CSDL: ", err)
	}

	// Bể kết nối: giữ sẵn vài kết nối để request sau không phải bắt tay lại.
	if sqlDB, err := db.DB(); err == nil {
		sqlDB.SetMaxIdleConns(10)
		sqlDB.SetMaxOpenConns(50)
		sqlDB.SetConnMaxLifetime(time.Hour)
	}
	log.Printf("Ket noi CSDL xong (%v).", time.Since(start).Round(time.Millisecond))

	if strings.EqualFold(os.Getenv("AUTO_MIGRATE"), "true") {
		start = time.Now()
		if err := db.AutoMigrate(entity.AllModels()...); err != nil {
			log.Fatal("AutoMigrate thất bại: ", err)
		}
		log.Printf("AutoMigrate xong (%v). Doi cau truc bang xong roi thi dat lai AUTO_MIGRATE=false cho khoi dong nhanh.",
			time.Since(start).Round(time.Millisecond))
	} else {
		log.Println("Bo qua AutoMigrate (dat AUTO_MIGRATE=true trong .env khi vua sua file entity).")
	}

	DB = db
}
