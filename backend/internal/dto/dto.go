package dto

// ===== Auth =====
type RegisterInput struct {
	Username string `json:"username" binding:"required"`
	Email    string `json:"email"`
	Password string `json:"password" binding:"required,min=4"`
	FullName string `json:"full_name"`
	Role     string `json:"role"`
}

type LoginInput struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
}
type VerifyOTPInput struct {
	Email string `json:"email" binding:"required,email"`
	Code  string `json:"code" binding:"required,len=6"`
}
type ResendOTPInput struct {
	Email string `json:"email" binding:"required,email"`
}
type ForgotPasswordInput struct {
	Email string `json:"email" binding:"required,email"`
	Code  string `json:"code" binding:"required,len=6"`
}
type ChangePasswordInput struct {
	CurrentPassword string `json:"current_password" binding:"required"`
	NewPassword     string `json:"new_password" binding:"required,min=6,max=72"`
}

// ===== User (Admin quản lý) =====
type UserInput struct {
	Username   string `json:"username" binding:"required"`
	Email      string `json:"email"`
	Password   string `json:"password"`
	FullName   string `json:"full_name"`
	Role       string `json:"role"`
	Status     string `json:"status"`
	LockReason string `json:"lock_reason"`
}

// ===== Subject =====
type SubjectInput struct {
	Name        string `json:"name" binding:"required"`
	Level       string `json:"level"`
	Description string `json:"description"`
	Hidden      bool   `json:"hidden"` // true = tạm ẩn khỏi danh sách chọn môn
}

// ===== Question =====
type AnswerInput struct {
	Label      string `json:"label"`
	Content    string `json:"content"`
	IsCorrect  bool   `json:"is_correct"`
	OrderIndex int    `json:"order_index"`
}

type QuestionInput struct {
	SubjectID       uint          `json:"subject_id" binding:"required"`
	ChapterID       *uint         `json:"chapter_id"` // null = chưa phân chương
	Content         string        `json:"content" binding:"required"`
	QuestionType    string        `json:"question_type"`
	Difficulty      string        `json:"difficulty"`
	Status          string        `json:"status"` // draft / active
	SourceID        *uint         `json:"source_id"`
	SourceReference string        `json:"source_reference"`
	SubmitForReview bool          `json:"submit_for_review"`
	Answers         []AnswerInput `json:"answers" binding:"required"`
}

// ===== Source (nguồn tài liệu) =====
type SourceInput struct {
	Title         string `json:"title" binding:"required"`
	Publisher     string `json:"publisher"`
	URL           string `json:"url" binding:"required,url"`
	PublishedYear string `json:"published_year"`
	LicenseNote   string `json:"license_note"`
}
type SourceReviewInput struct {
	Status string `json:"status" binding:"required,oneof=verified rejected"`
}

type ReviewInput struct {
	Status string `json:"status" binding:"required,oneof=approved rejected"`
	Note   string `json:"note"`
}

// ===== Chapter (chương/chủ đề của môn) =====
type ChapterInput struct {
	SubjectID  uint   `json:"subject_id" binding:"required"`
	Name       string `json:"name" binding:"required"`
	OrderIndex int    `json:"order_index"`
}

// ===== Class =====
type ClassInput struct {
	Name        string `json:"name" binding:"required"`
	Description string `json:"description"`
	IsPublic    bool   `json:"is_public"`
}

type AddStudentInput struct {
	StudentID uint `json:"student_id" binding:"required"`
}

type JoinClassInput struct {
	Code string `json:"code" binding:"required"`
}

type ClassPostInput struct {
	Content string `json:"content" binding:"required,max=2000"`
}

// ===== Assignment =====
type AssignmentInput struct {
	ClassID     uint    `json:"class_id" binding:"required"`
	Title       string  `json:"title" binding:"required,max=200"`
	Description string  `json:"description"`
	DueAt       string  `json:"due_at" binding:"required"`
	LateUntil   string  `json:"late_until"`
	MaxScore    float64 `json:"max_score"`
	Status      string  `json:"status"`
}

type GradeAssignmentInput struct {
	Score    float64 `json:"score" binding:"required,min=0"`
	Feedback string  `json:"feedback"`
}

type StartUploadInput struct {
	Filename string `json:"filename" binding:"required,max=255"`
	MimeType string `json:"mime_type" binding:"required,max=120"`
	Size     int64  `json:"size" binding:"required,min=1"`
}

// ===== Kho cá nhân (thư mục) =====
type FolderInput struct {
	Name     string `json:"name" binding:"required"`
	ParentID *uint  `json:"parent_id"`
}

type RenameInput struct {
	Name string `json:"name" binding:"required"`
}

type SaveExamInput struct {
	ExamID uint `json:"exam_id" binding:"required"`
}

type NoteInput struct {
	Note string `json:"note"` // rỗng = xóa ghi chú
}

// ===== Exam =====
type ExamInput struct {
	SubjectID      uint    `json:"subject_id" binding:"required"`
	Title          string  `json:"title" binding:"required"`
	Description    string  `json:"description"`
	StartTime      string  `json:"start_time"`
	EndTime        string  `json:"end_time"`
	Duration       int     `json:"duration"`
	PassScore      float64 `json:"pass_score"`
	Shuffle        bool    `json:"shuffle"`
	ShuffleAnswers bool    `json:"shuffle_answers"`
	ShuffleMode    string  `json:"shuffle_mode"`
	AccessType     string  `json:"access_type"`
	MaxAttempts    int     `json:"max_attempts"` // 0 = không giới hạn số lần làm
	Status         string  `json:"status"`
	QuestionIDs    []uint  `json:"question_ids"`
	ClassIDs       []uint  `json:"class_ids"`
}

// ===== Ma trận đề (sinh đề tự động) =====
// 1 dòng ma trận: lấy Count câu thuộc chương + độ khó chỉ định
type MatrixRule struct {
	Chapter    string `json:"chapter"`    // "any" = mọi chương, "none" = chưa phân chương, khác = id chương
	Difficulty string `json:"difficulty"` // "any" hoặc easy/medium/hard
	Count      int    `json:"count"`
}

type GenerateExamInput struct {
	ExamInput
	Rules []MatrixRule `json:"rules" binding:"required"`
}

// ===== Submission (làm bài) =====
type SubmitAnswer struct {
	QuestionID       uint `json:"question_id"`
	SelectedAnswerID uint `json:"selected_answer_id"`
}

type SubmitInput struct {
	GuestName string         `json:"guest_name"`
	Answers   []SubmitAnswer `json:"answers"`
}

// ===== Response: lấy đề để làm (ẩn đáp án đúng) =====
type TakeAnswer struct {
	ID      uint   `json:"id"`
	Label   string `json:"label"`
	Content string `json:"content"`
}

type TakeQuestion struct {
	ID      uint         `json:"id"`
	Content string       `json:"content"`
	Answers []TakeAnswer `json:"answers"`
}
