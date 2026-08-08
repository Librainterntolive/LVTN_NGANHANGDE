package service

import (
	"crypto/rand"
	"errors"
	"fmt"
	"log"
	"mime"
	"net/smtp"
	"os"
	"strings"
)

// ErrEmailNotSent la thong bao duy nhat ma nguoi dung cuoi nhin thay khi he
// thong khong gui duoc thu. Moi chi tiet ky thuat deu nam trong log.
var ErrEmailNotSent = errors.New("Hệ thống chưa gửi được email. Hãy thử lại sau ít phút hoặc liên hệ quản trị viên.")

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

// otpEmailContent tach rieng de vua dung khi gui that, vua dung khi xem truoc.
func otpEmailContent(code string) (textBody, htmlBody string) {
	return buildEmail(
		"Xác minh địa chỉ email",
		[]emailBlock{
			{Text: "Nhập mã dưới đây để hoàn tất việc xác minh tài khoản của bạn."},
			{Code: code},
			{Text: "Mã có hiệu lực trong 10 phút kể từ khi email này được gửi."},
			{Note: "Không chia sẻ mã này cho bất kỳ ai, kể cả người tự xưng là quản trị viên. Nếu bạn không yêu cầu mã, hãy bỏ qua email này — tài khoản của bạn vẫn an toàn."},
		},
		"Bạn nhận được email này vì địa chỉ này được dùng để đăng ký tài khoản.",
	)
}

func SendOTP(to, code string) error {
	text, htmlBody := otpEmailContent(code)
	return sendRichEmail(to, "Mã xác minh "+brandName, text, htmlBody)
}

func SendTemporaryPassword(to, password string) error {
	text, htmlBody := buildEmail(
		"Mật khẩu tạm thời",
		[]emailBlock{
			{Text: "Quản trị viên đã duyệt yêu cầu cấp lại mật khẩu của bạn. Dùng mật khẩu tạm dưới đây để đăng nhập."},
			{Code: password},
			{Text: "Hãy đổi mật khẩu ngay sau khi đăng nhập."},
			{Note: "Không chia sẻ mật khẩu này cho bất kỳ ai. Nếu bạn không yêu cầu cấp lại mật khẩu, hãy liên hệ quản trị viên ngay."},
		},
		"Bạn nhận được email này vì có yêu cầu cấp lại mật khẩu cho tài khoản dùng địa chỉ này.",
	)
	return sendRichEmail(to, "Mật khẩu tạm "+brandName, text, htmlBody)
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
	return sendEmail(to, "Sinh viên đã nộp bài: "+assignmentTitle, "Sinh viên "+studentName+" vừa nộp bài tập: "+assignmentTitle+"\r\nTrạng thái: "+submissionStatus+".\r\nĐăng nhập QuizBank để xem tệp nộp và chấm điểm.")
}

func SendAssignmentGraded(to, assignmentTitle, score, feedback string) error {
	body := "Giảng viên đã chấm bài tập: " + assignmentTitle + "\r\nĐiểm: " + score
	if strings.TrimSpace(feedback) != "" {
		body += "\r\nNhận xét: " + feedback
	}
	body += "\r\nĐăng nhập QuizBank để xem kết quả chi tiết."
	return sendEmail(to, "Đã có điểm bài tập: "+assignmentTitle, body)
}

func SendClassPostPublished(to, className, authorName, content string) error {
	preview := strings.TrimSpace(content)
	if len([]rune(preview)) > 220 {
		preview = string([]rune(preview)[:220]) + "..."
	}
	return sendEmail(to, "Thông báo mới từ lớp "+className, authorName+" vừa đăng thông báo mới trong lớp "+className+":\r\n\r\n"+preview+"\r\n\r\nĐăng nhập QuizBank để xem đầy đủ.")
}

// buildMessage dung thu theo chuan MIME. Neu co ban HTML thi gui kem ca ban
// van ban thuan (multipart/alternative): ung dung mail nao khong hien duoc
// HTML se roi ve ban van ban, va bo loc thu rac danh gia cao thu co du hai ban.
func buildMessage(to, from, subject, textBody, htmlBody string) string {
	head := "To: " + to + "\r\nFrom: " + from + "\r\nSubject: " + subject + "\r\nMIME-Version: 1.0\r\n"
	if htmlBody == "" {
		return head + "Content-Type: text/plain; charset=UTF-8\r\n\r\n" + textBody + "\r\n"
	}
	// Ranh gioi phai la chuoi khong the xuat hien trong noi dung thu.
	const boundary = "quizbank-boundary-8f4c1d92e7"
	return head +
		"Content-Type: multipart/alternative; boundary=\"" + boundary + "\"\r\n\r\n" +
		"--" + boundary + "\r\nContent-Type: text/plain; charset=UTF-8\r\n\r\n" + textBody + "\r\n" +
		"--" + boundary + "\r\nContent-Type: text/html; charset=UTF-8\r\n\r\n" + htmlBody + "\r\n" +
		"--" + boundary + "--\r\n"
}

func sendEmail(to, subject, body string) error {
	return sendMail(to, subject, body, "")
}

// sendRichEmail gui thu co ca ban HTML va ban van ban thuan.
func sendRichEmail(to, subject, textBody, htmlBody string) error {
	return sendMail(to, subject, textBody, htmlBody)
}

func sendMail(to, subject, body, htmlBody string) error {
	host := strings.TrimSpace(os.Getenv("SMTP_HOST"))
	username := strings.TrimSpace(os.Getenv("SMTP_USERNAME"))
	// Google hien thi mat khau ung dung theo dang "abcd efgh ijkl mnop".
	// Nguoi dung thuong dan y nguyen ca khoang trang, trong khi giao thuc SMTP
	// gui chuoi nguyen van nen may chu se tu choi voi ma 535. Bo moi khoang
	// trang de dan kieu nao cung chay.
	password := strings.Join(strings.Fields(os.Getenv("SMTP_PASSWORD")), "")
	port := strings.TrimSpace(os.Getenv("SMTP_PORT"))
	from := strings.TrimSpace(os.Getenv("SMTP_FROM"))
	if host == "" || username == "" || password == "" {
		log.Printf("gửi thư thất bại: chưa cấu hình SMTP_HOST/SMTP_USERNAME/SMTP_PASSWORD")
		return ErrEmailNotSent
	}
	if port == "" {
		port = "587"
	}
	if from == "" {
		from = username
	}
	to = sanitizeMailHeader(to)
	from = sanitizeMailHeader(from)
	subject = encodeMailSubject(subject)
	message := []byte(buildMessage(to, from, subject, body, htmlBody))
	if err := smtp.SendMail(host+":"+port, smtp.PlainAuth("", username, password, host), username, []string{to}, message); err != nil {
		// Chi tiet loi cua may chu thu (ma 535, duong dan ho tro cua Google...)
		// chi ghi vao log cho quan tri vien. Nguoi dung cuoi khong can biet, va
		// day cung la thong tin ve he thong thu ben trong, khong nen lo ra ngoai.
		log.Printf("gửi thư tới %s thất bại: %v", to, err)
		return ErrEmailNotSent
	}
	return nil
}

// encodeMailSubject chuan bi tieu de thu de dat vao header Subject.
// Header thu chi duoc chua ASCII (RFC 5322), nen tieu de tieng Viet co dau
// phai duoc ma hoa thanh encoded-word (RFC 2047); neu khong mot so ung dung
// mail se hien sai font. QEncoding tu giu nguyen chuoi da thuan ASCII.
func encodeMailSubject(subject string) string {
	return mime.QEncoding.Encode("UTF-8", sanitizeMailHeader(subject))
}

func sanitizeMailHeader(value string) string {
	return strings.ReplaceAll(strings.ReplaceAll(value, "\r", ""), "\n", "")
}
