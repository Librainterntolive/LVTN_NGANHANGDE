package service

import (
	"crypto/rand"
	"fmt"
	"net/smtp"
	"os"
	"strings"
)

func NewOTP() (string, error) {
	bytes := make([]byte, 3)
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	return fmt.Sprintf("%06d", (int(bytes[0])<<16|int(bytes[1])<<8|int(bytes[2]))%1_000_000), nil
}

func NewTemporaryPassword() (string, error) {
	const alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789!@#$%"
	bytes := make([]byte, 14)
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	for index, value := range bytes {
		bytes[index] = alphabet[int(value)%len(alphabet)]
	}
	return string(bytes), nil
}

func SendOTP(to, code string) error {
	return sendEmail(to, "Mã xác minh QuizBank", "Mã OTP của bạn: "+code+"\r\nMã có hiệu lực trong 10 phút.")
}

func SendTemporaryPassword(to, password string) error {
	return sendEmail(to, "Mật khẩu tạm QuizBank", "Mật khẩu tạm của bạn: "+password+"\r\nHãy đăng nhập và đổi mật khẩu ngay.")
}

func SendClassJoined(to, className, classCode string) error {
	return sendEmail(to, "Bạn đã tham gia lớp học", "Bạn đã được thêm vào lớp: "+className+"\r\nMã lớp: "+classCode+"\r\nĐăng nhập QuizBank để xem bài tập và đề thi được giao.")
}

func SendClassRemoved(to, className string) error {
	return sendEmail(to, "Cập nhật lớp học", "Bạn đã được xóa khỏi lớp: "+className+".\r\nNếu bạn cho rằng đây là nhầm lẫn, hãy liên hệ giảng viên phụ trách lớp.")
}

func SendAssignmentPublished(to, className, assignmentTitle, dueAt string) error {
	return sendEmail(to, "Có bài tập mới trong lớp "+className, "Giảng viên vừa giao bài tập: "+assignmentTitle+"\r\nHạn nộp: "+dueAt+"\r\nVui lòng đăng nhập QuizBank để xem hướng dẫn và nộp bài.")
}

func SendAssignmentSubmitted(to, assignmentTitle, studentName, submissionStatus string) error {
	return sendEmail(to, "Sinh vien da nop bai: "+assignmentTitle, "Sinh vien "+studentName+" vua nop bai tap: "+assignmentTitle+"\r\nTrang thai: "+submissionStatus+".\r\nDang nhap QuizBank de xem tep nop va cham diem.")
}

func SendAssignmentGraded(to, assignmentTitle, score, feedback string) error {
	body := "Giang vien da cham bai tap: " + assignmentTitle + "\r\nDiem: " + score
	if strings.TrimSpace(feedback) != "" {
		body += "\r\nNhan xet: " + feedback
	}
	body += "\r\nDang nhap QuizBank de xem ket qua chi tiet."
	return sendEmail(to, "Da co diem bai tap: "+assignmentTitle, body)
}

func SendClassPostPublished(to, className, authorName, content string) error {
	preview := strings.TrimSpace(content)
	if len([]rune(preview)) > 220 {
		preview = string([]rune(preview)[:220]) + "..."
	}
	return sendEmail(to, "Thong bao moi tu lop "+className, authorName+" vua dang thong bao moi trong lop "+className+":\r\n\r\n"+preview+"\r\n\r\nDang nhap QuizBank de xem day du.")
}

func sendEmail(to, subject, body string) error {
	host := os.Getenv("SMTP_HOST")
	username := os.Getenv("SMTP_USERNAME")
	password := os.Getenv("SMTP_PASSWORD")
	port := os.Getenv("SMTP_PORT")
	from := os.Getenv("SMTP_FROM")
	if host == "" || username == "" || password == "" {
		return fmt.Errorf("SMTP chưa được cấu hình")
	}
	if port == "" {
		port = "587"
	}
	if from == "" {
		from = username
	}
	to = sanitizeMailHeader(to)
	from = sanitizeMailHeader(from)
	subject = sanitizeMailHeader(subject)
	message := []byte("To: " + to + "\r\nFrom: " + from + "\r\nSubject: " + subject + "\r\nMIME-Version: 1.0\r\nContent-Type: text/plain; charset=UTF-8\r\n\r\n" + body + "\r\n")
	return smtp.SendMail(host+":"+port, smtp.PlainAuth("", username, password, host), username, []string{to}, message)
}

func sanitizeMailHeader(value string) string {
	return strings.ReplaceAll(strings.ReplaceAll(value, "\r", ""), "\n", "")
}
