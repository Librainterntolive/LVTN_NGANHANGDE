package entity

import "time"

// USERS
type User struct {
	ID           uint      `gorm:"primaryKey" json:"id"`
	Username     string    `gorm:"size:100;uniqueIndex;not null" json:"username"`
	// Con trỏ để email bỏ trống lưu thành NULL. Nếu lưu chuỗi rỗng thì chỉ mục
	// duy nhất chỉ cho phép ĐÚNG MỘT tài khoản không có email.
	Email        *string   `gorm:"size:150;uniqueIndex" json:"email"`
	PasswordHash string    `gorm:"size:255;not null" json:"-"`
	FullName     string    `gorm:"size:150" json:"full_name"`
	Role         string    `gorm:"size:20;not null;default:Student" json:"role"`
	Status       string    `gorm:"size:20;default:active" json:"status"`
	LockReason   string    `gorm:"size:255" json:"lock_reason"` // lý do tạm khóa (nếu status=locked)
	CreatedAt    time.Time `json:"created_at"`
}

// SUBJECTS
type Subject struct {
	ID          uint      `gorm:"primaryKey" json:"id"`
	Name        string    `gorm:"size:150;not null" json:"name"`
	Level       string    `gorm:"size:50;default:Khác" json:"level"` // Khối 10/11/12, Đại học, Khác
	Description string    `gorm:"size:255" json:"description"`
	CreatedAt   time.Time `json:"created_at"`
}

// CLASSES
type Class struct {
	ID          uint      `gorm:"primaryKey" json:"id"`
	CreatedBy   uint      `json:"created_by"`
	Code        string    `gorm:"size:20;uniqueIndex" json:"code"` // mã tham gia lớp
	Name        string    `gorm:"size:150;not null" json:"name"`
	Description string    `gorm:"size:255" json:"description"`
	IsPublic     bool      `json:"is_public"` // lớp dùng chung: mọi GV đều giao đề được
	CreatedAt    time.Time `json:"created_at"`
	CreatorName  string    `gorm:"-" json:"creator_name"`  // tên GV tạo (không lưu DB)
	StudentCount int64     `gorm:"-" json:"student_count"` // số SV trong lớp (không lưu DB)
	ExamCount    int64     `gorm:"-" json:"exam_count"`    // số đề đã giao cho lớp (không lưu DB)
}

// CLASS_STUDENTS
type ClassStudent struct {
	ClassID   uint      `gorm:"primaryKey" json:"class_id"`
	StudentID uint      `gorm:"primaryKey" json:"student_id"`
	JoinedAt  time.Time `json:"joined_at"`
}

// CHAPTERS: chương/chủ đề trong một môn học (phục vụ phân loại kho + ma trận đề)
type Chapter struct {
	ID            uint      `gorm:"primaryKey" json:"id"`
	SubjectID     uint      `gorm:"index" json:"subject_id"`
	Name          string    `gorm:"size:150;not null" json:"name"`
	OrderIndex    int       `json:"order_index"`
	CreatedAt     time.Time `json:"created_at"`
	QuestionCount int64     `gorm:"-" json:"question_count"` // số câu trong chương (không lưu DB)
}

// QUESTION_MAIN
type Question struct {
	ID           uint      `gorm:"primaryKey" json:"id"`
	SubjectID    uint      `json:"subject_id"`
	ChapterID    *uint     `json:"chapter_id"` // null = chưa phân chương
	CreatedBy    uint      `json:"created_by"`
	Content      string    `gorm:"type:text;not null" json:"content"`
	QuestionType string    `gorm:"size:20;default:single" json:"question_type"`
	Difficulty   string    `gorm:"size:20;default:medium" json:"difficulty"`
	Status       string    `gorm:"size:20;default:active" json:"status"` // draft (nháp) / active (chính thức)
	CreatedAt    time.Time `json:"created_at"`
	Answers      []Answer  `gorm:"foreignKey:QuestionID" json:"answers,omitempty"`
	CreatorName  string    `gorm:"-" json:"creator_name"` // tên người soạn (không lưu DB, điền khi đọc)
	UsedCount    int64     `gorm:"-" json:"used_count"`   // số đề thi đang dùng câu này (không lưu DB)
}

// ANSWERS
type Answer struct {
	ID         uint   `gorm:"primaryKey" json:"id"`
	QuestionID uint   `json:"question_id"`
	Label      string `gorm:"size:5" json:"label"`
	Content    string `gorm:"type:text" json:"content"`
	IsCorrect  bool   `json:"is_correct"`
	OrderIndex int    `json:"order_index"`
}

// EXAMS
type Exam struct {
	ID          uint      `gorm:"primaryKey" json:"id"`
	SubjectID   uint      `json:"subject_id"`
	CreatedBy   uint      `json:"created_by"`
	Title       string    `gorm:"size:200;not null" json:"title"`
	Description string    `gorm:"size:500" json:"description"`
	StartTime   time.Time `json:"start_time"`
	EndTime     time.Time `json:"end_time"`
	Duration       int     `json:"duration"`
	PassScore      float64 `json:"pass_score"`
	Shuffle        bool    `json:"shuffle"`                                        // xáo thứ tự câu hỏi
	ShuffleAnswers bool    `json:"shuffle_answers"`                                // xáo thứ tự đáp án
	ShuffleMode    string  `gorm:"size:20;default:per_student" json:"shuffle_mode"` // per_student / fixed
	AccessType     string  `gorm:"size:20;default:private" json:"access_type"`
	MaxAttempts    int     `gorm:"default:0" json:"max_attempts"` // số lần được làm; 0 = không giới hạn
	Status      string    `gorm:"size:20;default:draft" json:"status"`
	CreatedAt   time.Time `json:"created_at"`
}

// EXAM_QUESTIONS
type ExamQuestion struct {
	ExamID     uint    `gorm:"primaryKey" json:"exam_id"`
	QuestionID uint    `gorm:"primaryKey" json:"question_id"`
	OrderIndex int     `json:"order_index"`
	Points     float64 `gorm:"default:1" json:"points"`
}

// EXAM_CLASSES
type ExamClass struct {
	ExamID  uint `gorm:"primaryKey" json:"exam_id"`
	ClassID uint `gorm:"primaryKey" json:"class_id"`
}

// SUBMISSIONS
type Submission struct {
	ID         uint      `gorm:"primaryKey" json:"id"`
	UserID     *uint     `json:"user_id"`
	GuestName  string    `gorm:"size:150" json:"guest_name"`
	ExamID     uint      `json:"exam_id"`
	StartTime  time.Time `json:"start_time"`
	SubmitTime time.Time `json:"submit_time"`
	TotalScore float64   `json:"total_score"`
	Status     string    `gorm:"size:20;default:in_progress" json:"status"`
	IsPassed   bool      `json:"is_passed"`
}

// SUBMISSION_DETAILS
type SubmissionDetail struct {
	ID               uint `gorm:"primaryKey" json:"id"`
	SubmissionID     uint `json:"submission_id"`
	QuestionID       uint `json:"question_id"`
	SelectedAnswerID uint `json:"selected_answer_id"`
	IsCorrect        bool `json:"is_correct"`
}

// FOLDERS: thư mục trong kho cá nhân (dạng cây)
type Folder struct {
	ID        uint      `gorm:"primaryKey" json:"id"`
	UserID    uint      `gorm:"index" json:"user_id"`
	Name      string    `gorm:"size:150;not null" json:"name"`
	ParentID  *uint     `json:"parent_id"` // null = thư mục gốc
	CreatedAt time.Time `json:"created_at"`
}

// FOLDER_EXAMS: đề thi đã lưu vào 1 thư mục (tham chiếu)
type FolderExam struct {
	ID       uint   `gorm:"primaryKey" json:"id"`
	UserID   uint   `gorm:"index" json:"user_id"`
	FolderID uint   `gorm:"index" json:"folder_id"`
	ExamID   uint   `json:"exam_id"`
	Note     string `gorm:"size:255" json:"note"` // ghi chú cá nhân ("đề khó, ôn chương 3"...)
}

// PRACTICE_ANSWERS: log trả lời khi "luyện lại câu sai" (ngoài bài thi chính thức)
type PracticeAnswer struct {
	ID         uint      `gorm:"primaryKey" json:"id"`
	UserID     uint      `gorm:"index" json:"user_id"`
	QuestionID uint      `gorm:"index" json:"question_id"`
	IsCorrect  bool      `json:"is_correct"`
	CreatedAt  time.Time `json:"created_at"`
}

// AllModels: dùng cho AutoMigrate
func AllModels() []interface{} {
	return []interface{}{
		&User{}, &Subject{}, &Chapter{}, &Class{}, &ClassStudent{},
		&Question{}, &Answer{}, &Exam{}, &ExamQuestion{},
		&ExamClass{}, &Submission{}, &SubmissionDetail{},
		&Folder{}, &FolderExam{}, &PracticeAnswer{},
	}
}
