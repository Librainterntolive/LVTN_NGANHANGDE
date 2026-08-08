package service

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/base64"
	"encoding/hex"
	"errors"
	"io"
	"log"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/entity"
	"quiz-backend/internal/repository"
)

const uploadChunkSize int64 = 1024 * 1024
const maxActiveUploadSessions = 3

type AssignmentService struct {
	repo      *repository.AssignmentRepository
	classRepo *repository.ClassRepository
	userRepo  *repository.UserRepository
}

func NewAssignmentService(repo *repository.AssignmentRepository, classRepo *repository.ClassRepository, userRepo *repository.UserRepository) *AssignmentService {
	return &AssignmentService{repo: repo, classRepo: classRepo, userRepo: userRepo}
}

func (s *AssignmentService) canManage(classID, userID uint, role string) bool {
	if role == "Admin" {
		return true
	}
	class, err := s.classRepo.FindByID(strconv.FormatUint(uint64(classID), 10))
	return err == nil && class.CreatedBy == userID
}

func parseAssignmentTime(value string) (time.Time, error) {
	for _, layout := range []string{time.RFC3339, "2006-01-02T15:04"} {
		if value, err := time.ParseInLocation(layout, value, time.Local); err == nil {
			return value, nil
		}
	}
	return time.Time{}, errors.New("Thời gian không hợp lệ")
}

func (s *AssignmentService) Create(input dto.AssignmentInput, userID uint, role string) (*entity.Assignment, error) {
	if !s.canManage(input.ClassID, userID, role) {
		return nil, ErrNotOwner
	}
	dueAt, err := parseAssignmentTime(input.DueAt)
	if err != nil {
		return nil, err
	}
	var lateUntil *time.Time
	if strings.TrimSpace(input.LateUntil) != "" {
		late, err := parseAssignmentTime(input.LateUntil)
		if err != nil {
			return nil, err
		}
		if !late.After(dueAt) {
			return nil, errors.New("Hạn nộp muộn phải sau hạn nộp")
		}
		lateUntil = &late
	}
	maxScore := input.MaxScore
	if maxScore <= 0 {
		maxScore = 10
	}
	item := &entity.Assignment{ClassID: input.ClassID, CreatedBy: userID, Title: strings.TrimSpace(input.Title), Description: input.Description, DueAt: dueAt, LateUntil: lateUntil, MaxScore: maxScore, Status: "published"}
	if err := s.repo.Create(item); err != nil {
		return nil, err
	}
	go s.notifyAssignmentPublished(item)
	return item, nil
}

func (s *AssignmentService) notifyAssignmentPublished(item *entity.Assignment) {
	class, err := s.classRepo.FindByID(strconv.FormatUint(uint64(item.ClassID), 10))
	if err != nil {
		return
	}
	students, err := s.classRepo.FindStudents(strconv.FormatUint(uint64(item.ClassID), 10))
	if err != nil {
		return
	}
	dueAt := item.DueAt.Format("02/01/2006 15:04")
	for _, student := range students {
		if student.Email == nil || *student.Email == "" {
			continue
		}
		if err := SendAssignmentPublished(*student.Email, class.Name, item.Title, dueAt); err != nil {
			log.Printf("gửi email bài tập mới thất bại: %v", err)
		}
	}
}

func (s *AssignmentService) List(classID uint, userID uint, role string, limit, offset int) ([]entity.Assignment, int64, error) {
	if role == "Student" {
		if !s.classRepo.IsStudentIn(classID, userID) {
			return nil, 0, ErrNotOwner
		}
		return s.repo.ListClassForStudent(classID, userID, limit, offset)
	}
	if role != "Student" && !s.canManage(classID, userID, role) {
		return nil, 0, ErrNotOwner
	}
	return s.repo.ListClass(classID, limit, offset)
}

func (s *AssignmentService) Update(id, userID uint, role string, input dto.AssignmentInput) (*entity.Assignment, error) {
	item, err := s.repo.FindByID(id)
	if err != nil {
		return nil, errors.New("Không tìm thấy bài tập")
	}
	if !s.canManage(item.ClassID, userID, role) {
		return nil, ErrNotOwner
	}
	dueAt, err := parseAssignmentTime(input.DueAt)
	if err != nil {
		return nil, err
	}
	var lateUntil *time.Time
	if strings.TrimSpace(input.LateUntil) != "" {
		late, err := parseAssignmentTime(input.LateUntil)
		if err != nil {
			return nil, err
		}
		if !late.After(dueAt) {
			return nil, errors.New("Hạn nộp muộn phải sau hạn nộp")
		}
		lateUntil = &late
	}
	item.Title, item.Description, item.DueAt, item.LateUntil = strings.TrimSpace(input.Title), input.Description, dueAt, lateUntil
	if input.MaxScore > 0 {
		item.MaxScore = input.MaxScore
	}
	if input.Status != "" {
		item.Status = input.Status
	}
	return item, s.repo.Save(item)
}

func (s *AssignmentService) Delete(id, userID uint, role string) error {
	item, err := s.repo.FindByID(id)
	if err != nil {
		return errors.New("Không tìm thấy bài tập")
	}
	if !s.canManage(item.ClassID, userID, role) {
		return ErrNotOwner
	}
	return s.repo.Delete(id)
}

func (s *AssignmentService) ListSubmissions(assignmentID, userID uint, role string) ([]entity.AssignmentSubmission, error) {
	item, err := s.repo.FindByID(assignmentID)
	if err != nil {
		return nil, errors.New("Không tìm thấy bài tập")
	}
	if !s.canManage(item.ClassID, userID, role) {
		return nil, ErrNotOwner
	}
	list, err := s.repo.ListSubmissions(assignmentID)
	if err != nil {
		return nil, err
	}
	s.fillStudentNames(list)
	return list, nil
}

// fillStudentNames điền tên và tên đăng nhập của sinh viên vào từng bài nộp.
// Hai trường này không lưu trong bảng bài nộp; nếu để trống thì màn hình chấm
// bài chỉ hiện "Sinh viên #23" và giảng viên không biết đang chấm bài của ai.
func (s *AssignmentService) fillStudentNames(list []entity.AssignmentSubmission) {
	for i := range list {
		student, err := s.userRepo.FindByID(strconv.FormatUint(uint64(list[i].StudentID), 10))
		if err != nil {
			continue
		}
		list[i].StudentName = student.FullName
		list[i].StudentUsername = student.Username
	}
}

func (s *AssignmentService) ListSubmissionsPaged(assignmentID, userID uint, role string, limit, offset int) ([]entity.AssignmentSubmission, int64, error) {
	item, err := s.repo.FindByID(assignmentID)
	if err != nil {
		return nil, 0, errors.New("Không tìm thấy bài tập")
	}
	if !s.canManage(item.ClassID, userID, role) {
		return nil, 0, ErrNotOwner
	}
	list, total, err := s.repo.ListSubmissionsPaged(assignmentID, limit, offset)
	if err != nil {
		return nil, 0, err
	}
	s.fillStudentNames(list)
	return list, total, nil
}
func (s *AssignmentService) ClassStats(classID, userID uint, role string) ([]repository.ClassSubmissionStat, error) {
	if !s.canManage(classID, userID, role) {
		return nil, ErrNotOwner
	}
	return s.repo.ClassStats(classID)
}

func (s *AssignmentService) ClassStatsPaged(classID, userID uint, role string, limit, offset int) ([]repository.ClassSubmissionStat, int64, repository.ClassSubmissionSummary, error) {
	if !s.canManage(classID, userID, role) {
		return nil, 0, repository.ClassSubmissionSummary{}, ErrNotOwner
	}
	return s.repo.ClassStatsPaged(classID, limit, offset)
}

func (s *AssignmentService) Grade(submissionID, userID uint, role string, score float64, feedback string) (*entity.AssignmentSubmission, error) {
	item, err := s.repo.FindSubmissionByID(submissionID)
	if err != nil {
		return nil, errors.New("Không tìm thấy bài nộp")
	}
	assignment, err := s.repo.FindByID(item.AssignmentID)
	if err != nil || !s.canManage(assignment.ClassID, userID, role) {
		return nil, ErrNotOwner
	}
	if score > assignment.MaxScore {
		return nil, errors.New("Điểm vượt quá điểm tối đa")
	}
	now := time.Now()
	item.Score, item.Feedback, item.GradedAt = &score, feedback, &now
	if err := s.repo.SaveSubmission(item); err != nil {
		return nil, err
	}
	go s.notifyAssignmentGraded(item, assignment)
	return item, nil
}

func (s *AssignmentService) notifyAssignmentSubmitted(submission *entity.AssignmentSubmission, assignment *entity.Assignment) {
	teacher, err := s.userRepo.FindByID(strconv.FormatUint(uint64(assignment.CreatedBy), 10))
	if err != nil || teacher.Email == nil || *teacher.Email == "" {
		return
	}
	student, err := s.userRepo.FindByID(strconv.FormatUint(uint64(submission.StudentID), 10))
	if err != nil {
		return
	}
	studentName := student.FullName
	if studentName == "" {
		studentName = student.Username
	}
	status := "Dung han"
	if submission.Status == "late" {
		status = "Nop muon"
	}
	if err := SendAssignmentSubmitted(*teacher.Email, assignment.Title, studentName, status); err != nil {
		log.Printf("gui email sinh vien nop bai that bai: %v", err)
	}
}

func (s *AssignmentService) notifyAssignmentGraded(submission *entity.AssignmentSubmission, assignment *entity.Assignment) {
	student, err := s.userRepo.FindByID(strconv.FormatUint(uint64(submission.StudentID), 10))
	if err != nil || student.Email == nil || *student.Email == "" || submission.Score == nil {
		return
	}
	score := strconv.FormatFloat(*submission.Score, 'f', -1, 64)
	if err := SendAssignmentGraded(*student.Email, assignment.Title, score, submission.Feedback); err != nil {
		log.Printf("gửi email chấm bài thất bại: %v", err)
	}
}

func (s *AssignmentService) StartUpload(assignmentID, studentID uint, input dto.StartUploadInput) (*entity.UploadSession, error) {
	s.cleanupExpiredUploads()
	assignment, err := s.repo.FindByID(assignmentID)
	if err != nil {
		return nil, errors.New("Không tìm thấy bài tập")
	}
	if !s.classRepo.IsStudentIn(assignment.ClassID, studentID) {
		return nil, ErrNotOwner
	}
	if SubmissionWindow(time.Now(), assignment.DueAt, valueOrZero(assignment.LateUntil)) == "closed" {
		return nil, errors.New("Bài tập đã đóng nộp")
	}
	if err := ValidateUploadSpec(input.Filename, input.Size, input.MimeType); err != nil {
		return nil, err
	}
	activeSessions, err := s.repo.CountActiveSessions(studentID, time.Now())
	if err != nil {
		return nil, err
	}
	if activeSessions >= maxActiveUploadSessions {
		return nil, errors.New("Bạn đang có quá nhiều phiên nộp bài chưa hoàn tất, hãy hoàn tất hoặc chờ phiên cũ hết hạn")
	}
	id, err := randomID()
	if err != nil {
		return nil, err
	}
	item := &entity.UploadSession{ID: id, AssignmentID: assignmentID, StudentID: studentID, OriginalName: filepath.Base(input.Filename), MimeType: input.MimeType, TotalSize: input.Size, ChunkSize: uploadChunkSize, TotalChunks: int((input.Size + uploadChunkSize - 1) / uploadChunkSize), ExpiresAt: time.Now().Add(24 * time.Hour)}
	if err := os.MkdirAll(sessionPath(id), 0700); err != nil {
		return nil, err
	}
	if err := s.repo.CreateSession(item); err != nil {
		_ = os.RemoveAll(sessionPath(id))
		return nil, err
	}
	return item, nil
}

func (s *AssignmentService) cleanupExpiredUploads() {
	sessions, err := s.repo.ExpiredSessions(time.Now())
	if err != nil {
		return
	}
	for _, session := range sessions {
		_ = os.RemoveAll(sessionPath(session.ID))
		_ = s.repo.DeleteSession(session.ID)
	}
}

func (s *AssignmentService) SaveChunk(sessionID string, studentID uint, index int, body io.Reader, size int64) (int, error) {
	session, err := s.repo.FindSession(sessionID)
	if err != nil || session.StudentID != studentID {
		return 0, errors.New("Phiên tải lên không hợp lệ")
	}
	if time.Now().After(session.ExpiresAt) {
		return 0, errors.New("Phiên tải lên đã hết hạn, hãy tạo lại")
	}
	if index < 0 || index >= session.TotalChunks || size <= 0 || size > session.ChunkSize {
		return 0, errors.New("Phần file không hợp lệ")
	}
	tmp := filepath.Join(sessionPath(sessionID), strconv.Itoa(index)+".tmp")
	final := filepath.Join(sessionPath(sessionID), strconv.Itoa(index)+".part")
	f, err := os.OpenFile(tmp, os.O_CREATE|os.O_TRUNC|os.O_WRONLY, 0600)
	if err != nil {
		return 0, err
	}
	written, copyErr := io.Copy(f, io.LimitReader(body, session.ChunkSize+1))
	closeErr := f.Close()
	if copyErr != nil || closeErr != nil || written != size || written > session.ChunkSize {
		_ = os.Remove(tmp)
		return 0, errors.New("Không ghi được phần file")
	}
	if err := os.Rename(tmp, final); err != nil {
		return 0, err
	}
	return chunkCount(sessionID), nil
}

func (s *AssignmentService) UploadProgress(sessionID string, studentID uint) (*entity.UploadSession, []int, error) {
	session, err := s.repo.FindSession(sessionID)
	if err != nil || session.StudentID != studentID {
		return nil, nil, errors.New("Phiên tải lên không hợp lệ")
	}
	if time.Now().After(session.ExpiresAt) {
		return nil, nil, errors.New("Phiên tải lên đã hết hạn, hãy tạo lại")
	}
	return session, uploadedChunkIndexes(sessionID), nil
}

func (s *AssignmentService) CompleteUpload(sessionID string, studentID uint) (*entity.AssignmentSubmission, error) {
	session, err := s.repo.FindSession(sessionID)
	if err != nil || session.StudentID != studentID {
		return nil, errors.New("Phiên tải lên không hợp lệ")
	}
	assignment, err := s.repo.FindByID(session.AssignmentID)
	if err != nil {
		return nil, errors.New("Không tìm thấy bài tập")
	}
	status := SubmissionWindow(time.Now(), assignment.DueAt, valueOrZero(assignment.LateUntil))
	if status == "closed" {
		return nil, errors.New("Bài tập đã đóng nộp")
	}
	existing, findErr := s.repo.FindSubmission(session.AssignmentID, studentID)
	if findErr == nil && existing.Score != nil {
		return nil, errors.New("Bài đã được chấm điểm, không thể nộp lại")
	}
	if chunkCount(sessionID) != session.TotalChunks {
		return nil, errors.New("File chưa tải lên đầy đủ, hãy thử lại các phần còn thiếu")
	}
	plain, err := mergeChunks(session)
	if err != nil {
		return nil, err
	}
	if int64(len(plain)) != session.TotalSize {
		return nil, errors.New("Kích thước file không khớp")
	}
	if err := validateFileSignature(session.OriginalName, plain); err != nil {
		return nil, err
	}
	storedName, err := randomID()
	if err != nil {
		return nil, err
	}
	encrypted, err := encryptBytes(plain)
	if err != nil {
		return nil, err
	}
	if err := os.MkdirAll(storagePath(), 0700); err != nil {
		return nil, err
	}
	if err := os.WriteFile(filepath.Join(storagePath(), storedName+".bin"), encrypted, 0600); err != nil {
		return nil, err
	}
	previousStoredName := ""
	if findErr == nil {
		previousStoredName = existing.StoredName
		*existing = entity.AssignmentSubmission{ID: existing.ID, AssignmentID: session.AssignmentID, StudentID: studentID, StoredName: storedName, OriginalName: session.OriginalName, MimeType: session.MimeType, Size: session.TotalSize, Status: status, SubmittedAt: time.Now()}
	} else {
		existing = &entity.AssignmentSubmission{AssignmentID: session.AssignmentID, StudentID: studentID, StoredName: storedName, OriginalName: session.OriginalName, MimeType: session.MimeType, Size: session.TotalSize, Status: status, SubmittedAt: time.Now()}
	}
	if err := s.repo.SaveSubmission(existing); err != nil {
		_ = os.Remove(filepath.Join(storagePath(), storedName+".bin"))
		return nil, err
	}
	go s.notifyAssignmentSubmitted(existing, assignment)
	if previousStoredName != "" && previousStoredName != storedName {
		_ = os.Remove(filepath.Join(storagePath(), previousStoredName+".bin"))
	}
	_ = os.RemoveAll(sessionPath(sessionID))
	_ = s.repo.DeleteSession(sessionID)
	return existing, nil
}

func (s *AssignmentService) Download(submissionID, userID uint, role string) (*entity.AssignmentSubmission, []byte, error) {
	item, err := s.repo.FindSubmissionByID(submissionID)
	if err != nil {
		return nil, nil, errors.New("Không tìm thấy bài nộp")
	}
	assignment, err := s.repo.FindByID(item.AssignmentID)
	if err != nil {
		return nil, nil, errors.New("Không tìm thấy bài tập")
	}
	allowed := role == "Admin" || item.StudentID == userID || s.canManage(assignment.ClassID, userID, role)
	if !allowed {
		return nil, nil, ErrNotOwner
	}
	encrypted, err := os.ReadFile(filepath.Join(storagePath(), item.StoredName+".bin"))
	if err != nil {
		return nil, nil, errors.New("Không đọc được file bài nộp")
	}
	plain, err := decryptBytes(encrypted)
	if err != nil {
		return nil, nil, err
	}
	return item, plain, nil
}

func valueOrZero(value *time.Time) time.Time {
	if value == nil {
		return time.Time{}
	}
	return *value
}
func randomID() (string, error) {
	bytes := make([]byte, 24)
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	return hex.EncodeToString(bytes), nil
}
func uploadRoot() string {
	if value := os.Getenv("UPLOAD_DIR"); value != "" {
		return value
	}
	return filepath.Join("data", "uploads")
}
func storagePath() string          { return filepath.Join(uploadRoot(), "encrypted") }
func sessionPath(id string) string { return filepath.Join(uploadRoot(), "sessions", id) }
func chunkCount(id string) int {
	files, _ := filepath.Glob(filepath.Join(sessionPath(id), "*.part"))
	return len(files)
}
func uploadedChunkIndexes(id string) []int {
	files, _ := filepath.Glob(filepath.Join(sessionPath(id), "*.part"))
	indexes := make([]int, 0, len(files))
	for _, file := range files {
		index, err := strconv.Atoi(strings.TrimSuffix(filepath.Base(file), ".part"))
		if err == nil {
			indexes = append(indexes, index)
		}
	}
	return indexes
}
func mergeChunks(session *entity.UploadSession) ([]byte, error) {
	var out []byte
	for index := 0; index < session.TotalChunks; index++ {
		data, err := os.ReadFile(filepath.Join(sessionPath(session.ID), strconv.Itoa(index)+".part"))
		if err != nil {
			return nil, errors.New("Thiếu phần file")
		}
		out = append(out, data...)
	}
	return out, nil
}
func encryptionKey() ([]byte, error) {
	value := os.Getenv("FILE_ENCRYPTION_KEY")
	key, err := base64.StdEncoding.DecodeString(value)
	if err != nil || len(key) != 32 {
		return nil, errors.New("FILE_ENCRYPTION_KEY phải là khóa base64 32 byte")
	}
	return key, nil
}
func encryptBytes(plain []byte) ([]byte, error) {
	key, err := encryptionKey()
	if err != nil {
		return nil, err
	}
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}
	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return nil, err
	}
	nonce := make([]byte, gcm.NonceSize())
	if _, err = rand.Read(nonce); err != nil {
		return nil, err
	}
	return gcm.Seal(nonce, nonce, plain, nil), nil
}
func decryptBytes(encrypted []byte) ([]byte, error) {
	key, err := encryptionKey()
	if err != nil {
		return nil, err
	}
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}
	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return nil, err
	}
	if len(encrypted) < gcm.NonceSize() {
		return nil, errors.New("File mã hóa không hợp lệ")
	}
	return gcm.Open(nil, encrypted[:gcm.NonceSize()], encrypted[gcm.NonceSize():], nil)
}
func validateFileSignature(filename string, data []byte) error {
	ext := strings.ToLower(filepath.Ext(filename))
	if ext == ".pdf" && !strings.HasPrefix(string(data), "%PDF-") {
		return errors.New("Nội dung không phải PDF hợp lệ")
	}
	if ext == ".png" && (len(data) < 8 || string(data[:8]) != "\x89PNG\r\n\x1a\n") {
		return errors.New("Nội dung không phải PNG hợp lệ")
	}
	if (ext == ".jpg" || ext == ".jpeg") && (len(data) < 3 || data[0] != 0xff || data[1] != 0xd8 || data[2] != 0xff) {
		return errors.New("Nội dung không phải JPEG hợp lệ")
	}
	if (ext == ".zip" || ext == ".docx") && (len(data) < 4 || string(data[:2]) != "PK") {
		return errors.New("Nội dung không phải ZIP/DOCX hợp lệ")
	}
	if ext == ".doc" && (len(data) < 8 || string(data[:8]) != "\xd0\xcf\x11\xe0\xa1\xb1\x1a\xe1") {
		return errors.New("Nội dung không phải DOC hợp lệ")
	}
	return nil
}
