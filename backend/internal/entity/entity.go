package entity

import "time"

// USERS
type User struct {
	ID       uint   `gorm:"primaryKey" json:"id"`
	Username string `gorm:"size:100;uniqueIndex;not null" json:"username"`
	// Con trỏ để email bỏ trống lưu thành NULL. Nếu lưu chuỗi rỗng thì chỉ mục
	// duy nhất chỉ cho phép ĐÚNG MỘT tài khoản không có email.
	Email              *string   `gorm:"size:150;uniqueIndex" json:"email"`
	PasswordHash       string    `gorm:"size:255;not null" json:"-"`
	FullName           string    `gorm:"size:150" json:"full_name"`
	Role               string    `gorm:"size:20;not null;default:Student" json:"role"`
	Status             string    `gorm:"size:20;default:active" json:"status"`
	MustChangePassword bool      `gorm:"default:false" json:"must_change_password"`
	LockReason         string    `gorm:"size:255" json:"lock_reason"` // lý do tạm khóa (nếu status=locked)
	CreatedAt          time.Time `json:"created_at"`
}

type EmailOTP struct {
	ID        uint      `gorm:"primaryKey"`
	UserID    uint      `gorm:"index"`
	Purpose   string    `gorm:"size:30;index;not null"`
	CodeHash  string    `gorm:"size:255"`
	ExpiresAt time.Time `gorm:"index"`
	Attempts  int
}

type PasswordResetRequest struct {
	ID         uint   `gorm:"primaryKey"`
	UserID     uint   `gorm:"index"`
	Status     string `gorm:"size:20;default:pending"`
	CreatedAt  time.Time
	ApprovedAt *time.Time
}

// AUDIT_LOGS: dấu vết các thao tác quản trị quan trọng, không lưu mật khẩu hay OTP.
type AuditLog struct {
	ID          uint      `gorm:"primaryKey" json:"id"`
	ActorUserID uint      `gorm:"index;not null" json:"actor_user_id"`
	Action      string    `gorm:"size:80;index;not null" json:"action"`
	EntityType  string    `gorm:"size:50;index;not null" json:"entity_type"`
	EntityID    uint      `gorm:"index" json:"entity_id"`
	Description string    `gorm:"size:500" json:"description"`
	CreatedAt   time.Time `gorm:"index" json:"created_at"`
	ActorName   string    `gorm:"-" json:"actor_name"`
}

// SUBJECTS
type Subject struct {
	ID          uint      `gorm:"primaryKey" json:"id"`
	Name        string    `gorm:"size:150;not null" json:"name"`
	Level       string    `gorm:"size:50;default:Khác" json:"level"` // Khối 10/11/12, Đại học, Khác
	Description string    `gorm:"size:255" json:"description"`
	Hidden      bool      `gorm:"default:false" json:"hidden"` // true = tạm ẩn, không hiện trong danh sách chọn môn
	CreatedAt   time.Time `json:"created_at"`
}

// CLASSES
type Class struct {
	ID           uint      `gorm:"primaryKey" json:"id"`
	CreatedBy    uint      `json:"created_by"`
	Code         string    `gorm:"size:20;uniqueIndex" json:"code"` // mã tham gia lớp
	Name         string    `gorm:"size:150;not null" json:"name"`
	Description  string    `gorm:"size:255" json:"description"`
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

// CLASS_POSTS: thông báo/bài đăng trên bảng tin của một lớp học.
type ClassPost struct {
	ID         uint      `gorm:"primaryKey" json:"id"`
	ClassID    uint      `gorm:"index;not null" json:"class_id"`
	CreatedBy  uint      `gorm:"index;not null" json:"created_by"`
	Content    string    `gorm:"type:text;not null" json:"content"`
	CreatedAt  time.Time `json:"created_at"`
	UpdatedAt  time.Time `json:"updated_at"`
	AuthorName string    `gorm:"-" json:"author_name"`
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

// SOURCES: tài liệu gốc để truy xuất nguồn của câu hỏi.
// Không lưu nội dung tài liệu có bản quyền, chỉ lưu metadata và đường dẫn tham chiếu.
type Source struct {
	ID                 uint       `gorm:"primaryKey" json:"id"`
	Title              string     `gorm:"size:255;not null" json:"title"`
	Publisher          string     `gorm:"size:255" json:"publisher"`
	URL                string     `gorm:"size:191;uniqueIndex;not null" json:"url"`
	PublishedYear      string     `gorm:"size:20" json:"published_year"`
	LicenseNote        string     `gorm:"size:500" json:"license_note"`
	VerificationStatus string     `gorm:"size:20;default:pending" json:"verification_status"`
	CreatedBy          uint       `gorm:"index" json:"created_by"`
	ReviewedBy         *uint      `gorm:"index" json:"reviewed_by,omitempty"`
	ReviewedAt         *time.Time `json:"reviewed_at,omitempty"`
	CreatedAt          time.Time  `json:"created_at"`
}

// QUESTION_MAIN
type Question struct {
	ID           uint       `gorm:"primaryKey" json:"id"`
	SubjectID    uint       `json:"subject_id"`
	ChapterID    *uint      `json:"chapter_id"` // null = chưa phân chương
	CreatedBy    uint       `json:"created_by"`
	Content      string     `gorm:"type:text;not null" json:"content"`
	ContentHash  string     `gorm:"size:64;column:content_hash" json:"-"`
	QuestionType string     `gorm:"size:20;default:single" json:"question_type"`
	Difficulty   string     `gorm:"size:20;default:medium" json:"difficulty"`
	Status       string     `gorm:"size:20;default:active" json:"status"` // draft (nháp) / active (chính thức)
	SourceID     *uint      `gorm:"index" json:"source_id"`
	SourceRef    string     `gorm:"size:500" json:"source_reference"`
	ReviewStatus string     `gorm:"size:20;default:draft;index" json:"review_status"` // draft/pending/approved/rejected
	ReviewNote   string     `gorm:"size:500" json:"review_note"`
	ReviewedBy   *uint      `json:"reviewed_by"`
	ReviewedAt   *time.Time `json:"reviewed_at"`
	CreatedAt    time.Time  `json:"created_at"`
	Answers      []Answer   `gorm:"foreignKey:QuestionID" json:"answers,omitempty"`
	Source       *Source    `gorm:"foreignKey:SourceID" json:"source,omitempty"`
	CreatorName  string     `gorm:"-" json:"creator_name"` // tên người soạn (không lưu DB, điền khi đọc)
	UsedCount    int64      `gorm:"-" json:"used_count"`   // số đề thi đang dùng câu này (không lưu DB)
	AttemptCount int64      `gorm:"-" json:"attempt_count"`
	CorrectRate  float64    `gorm:"-" json:"correct_rate"`
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
	ID             uint      `gorm:"primaryKey" json:"id"`
	SubjectID      uint      `json:"subject_id"`
	CreatedBy      uint      `json:"created_by"`
	Title          string    `gorm:"size:200;not null" json:"title"`
	Description    string    `gorm:"size:500" json:"description"`
	StartTime      time.Time `json:"start_time"`
	EndTime        time.Time `json:"end_time"`
	Duration       int       `json:"duration"`
	PassScore      float64   `json:"pass_score"`
	Shuffle        bool      `json:"shuffle"`                                         // xáo thứ tự câu hỏi
	ShuffleAnswers bool      `json:"shuffle_answers"`                                 // xáo thứ tự đáp án
	ShuffleMode    string    `gorm:"size:20;default:per_student" json:"shuffle_mode"` // per_student / fixed
	AccessType     string    `gorm:"size:20;default:private" json:"access_type"`
	MaxAttempts    int       `gorm:"default:0" json:"max_attempts"` // số lần được làm; 0 = không giới hạn
	Status         string    `gorm:"size:20;default:draft" json:"status"`
	CreatedAt      time.Time `json:"created_at"`
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

// ASSIGNMENTS: bài tập nộp file theo từng lớp học.
type Assignment struct {
	ID           uint                  `gorm:"primaryKey" json:"id"`
	ClassID      uint                  `gorm:"index;not null" json:"class_id"`
	CreatedBy    uint                  `gorm:"index;not null" json:"created_by"`
	Title        string                `gorm:"size:200;not null" json:"title"`
	Description  string                `gorm:"type:text" json:"description"`
	DueAt        time.Time             `gorm:"index" json:"due_at"`
	LateUntil    *time.Time            `gorm:"index" json:"late_until"`
	MaxScore     float64               `gorm:"default:10" json:"max_score"`
	Status       string                `gorm:"size:20;default:published" json:"status"`
	CreatedAt    time.Time             `json:"created_at"`
	UpdatedAt    time.Time             `json:"updated_at"`
	MySubmission *AssignmentSubmission `gorm:"-" json:"my_submission,omitempty"`
}

type AssignmentSubmission struct {
	ID              uint       `gorm:"primaryKey" json:"id"`
	AssignmentID    uint       `gorm:"uniqueIndex:idx_assignment_student;not null" json:"assignment_id"`
	StudentID       uint       `gorm:"uniqueIndex:idx_assignment_student;not null" json:"student_id"`
	StoredName      string     `gorm:"size:100;not null" json:"-"`
	OriginalName    string     `gorm:"size:255;not null" json:"original_name"`
	MimeType        string     `gorm:"size:120;not null" json:"mime_type"`
	Size            int64      `json:"size"`
	Status          string     `gorm:"size:20;not null" json:"status"` // on_time / late
	StudentName     string     `gorm:"-" json:"student_name"`
	StudentUsername string     `gorm:"-" json:"student_username"`
	SubmittedAt     time.Time  `json:"submitted_at"`
	Score           *float64   `json:"score"`
	Feedback        string     `gorm:"type:text" json:"feedback"`
	GradedAt        *time.Time `json:"graded_at"`
}

// UploadSession stores resumable upload metadata; completed chunks live outside public folders.
type UploadSession struct {
	ID           string    `gorm:"primaryKey;size:64" json:"id"`
	AssignmentID uint      `gorm:"index;not null" json:"assignment_id"`
	StudentID    uint      `gorm:"index;not null" json:"student_id"`
	OriginalName string    `gorm:"size:255;not null" json:"original_name"`
	MimeType     string    `gorm:"size:120" json:"mime_type"`
	TotalSize    int64     `json:"total_size"`
	ChunkSize    int64     `json:"chunk_size"`
	TotalChunks  int       `json:"total_chunks"`
	ExpiresAt    time.Time `gorm:"index" json:"expires_at"`
	CreatedAt    time.Time `json:"created_at"`
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
		&User{}, &EmailOTP{}, &PasswordResetRequest{}, &AuditLog{}, &Subject{}, &Chapter{}, &Source{}, &Class{}, &ClassStudent{}, &ClassPost{},
		&Question{}, &Answer{}, &Exam{}, &ExamQuestion{},
		&ExamClass{}, &Submission{}, &SubmissionDetail{},
		&Assignment{}, &AssignmentSubmission{}, &UploadSession{},
		&Folder{}, &FolderExam{}, &PracticeAnswer{},
	}
}
