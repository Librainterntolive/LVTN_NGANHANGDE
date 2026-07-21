package main

import (
	"log"
	"os"

	"quiz-backend/config"
	"quiz-backend/internal/router"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	// Đọc .env (chạy từ thư mục backend: go run ./cmd)
	if err := godotenv.Load(); err != nil {
		log.Println("Khong tim thay file .env, dung bien moi truong he thong.")
	}

	// Kết nối CSDL
	config.ConnectDatabase()

	// Gin
	r := gin.Default()
	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"http://localhost:4200"},
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
		AllowCredentials: true,
	}))

	// Khai báo route (controller -> service -> repository)
	router.Setup(r, config.DB)

	port := os.Getenv("SERVER_PORT")
	if port == "" {
		port = "8081"
	}
	log.Println("Server chay tai http://localhost:" + port)
	r.Run(":" + port)
}
