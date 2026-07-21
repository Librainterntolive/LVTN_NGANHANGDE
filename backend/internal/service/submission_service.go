package service

import (
	"errors"
	"math"
	"math/rand"
	"time"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/entity"
	"quiz-backend/internal/repository"
)

type SubmissionService struct {
	subRepo  *repository.SubmissionRepository
	examRepo *repository.ExamRepository
	qRepo    *repository.QuestionRepository
}

func NewSubmissionService(
	subRepo *repository.SubmissionRepository,
	examRepo *repository.ExamRepository,
	qRepo *repository.QuestionRepository,
) *SubmissionService {
	return &SubmissionService{subRepo: subRepo, examRepo: examRepo, qRepo: qRepo}
}

func (s *SubmissionService) GetMyExams(studentID interface{}) ([]entity.Exam, error) {
	return s.examRepo.FindAvailableForStudent(studentID)
}

// graceSubmit: khoảng nới thêm khi nộp bài, tránh trượt oan do mạng chậm
// hoặc lệch giờ nhẹ giữa máy sinh viên và máy chủ.
const graceSubmit = 60 * time.Second

// TakeSession: thông tin phiên làm bài do server cấp.
// RemainingSeconds = -1 nghĩa là đề không giới hạn thời gian.
type TakeSession struct {
	SubmissionID     uint `json:"submission_id"`
	RemainingSeconds int  `json:"remaining_seconds"`
}

// canAccess: kiểm tra đề có đang mở và người này có quyền làm không.
// Thứ tự kiểm tra: trạng thái -> khung giờ -> phạm vi (public / lớp được giao).
func (s *SubmissionService) canAccess(exam *entity.Exam, userID *uint) error {
	if exam.Status != "published" {
		return errors.New("de thi chua mo")
	}

	now := time.Now()
	if !exam.StartTime.IsZero() && now.Before(exam.StartTime) {
		return errors.New("chua den gio mo de thi")
	}
	if !exam.EndTime.IsZero() && now.After(exam.EndTime) {
		return errors.New("de thi da dong")
	}

	if exam.AccessType == "public" {
		return nil
	}
	// đề riêng: bắt buộc đăng nhập
	if userID == nil {
		return errors.New("de thi rieng, can dang nhap de lam bai")
	}
	// người tạo đề luôn xem/thử được đề của mình
	if exam.CreatedBy == *userID {
		return nil
	}
	if !s.examRepo.IsAssignedToStudent(exam.ID, *userID) {
		return errors.New("ban khong thuoc lop duoc giao de thi nay")
	}
	return nil
}

// Take: mở phiên làm bài rồi trả đề + câu hỏi đã ẩn đáp án đúng.
// Với sinh viên, giờ bắt đầu được ghi xuống CSDL (status=in_progress) nên
// tải lại trang hay tắt trình duyệt cũng không làm mới đồng hồ.
func (s *SubmissionService) Take(examID string, userID *uint) (*entity.Exam, []dto.TakeQuestion, *TakeSession, error) {
	exam, err := s.examRepo.FindByID(examID)
	if err != nil {
		return nil, nil, nil, errors.New("khong tim thay de thi")
	}
	if err := s.canAccess(exam, userID); err != nil {
		return nil, nil, nil, err
	}

	// Phiên làm bài (chỉ áp dụng cho người đã đăng nhập - khách không định danh được)
	var session *TakeSession
	if userID != nil {
		sub := s.subRepo.FindInProgress(exam.ID, *userID)
		if sub == nil {
			// chưa có bài dở -> đây là một lượt làm mới, kiểm tra số lượt còn lại
			if exam.MaxAttempts > 0 &&
				s.subRepo.CountAttempts(exam.ID, *userID) >= int64(exam.MaxAttempts) {
				return nil, nil, nil, errors.New("ban da het so lan lam de thi nay")
			}
			sub = &entity.Submission{
				ExamID:    exam.ID,
				UserID:    userID,
				StartTime: time.Now(),
				Status:    "in_progress",
			}
			if err := s.subRepo.Create(sub); err != nil {
				return nil, nil, nil, err
			}
		}
		session = &TakeSession{SubmissionID: sub.ID, RemainingSeconds: remainingSeconds(exam, sub)}
		if session.RemainingSeconds == 0 {
			return nil, nil, nil, errors.New("da het thoi gian lam bai")
		}
	}

	qids := s.examRepo.GetQuestionIDs(exam.ID)
	questions, _ := s.qRepo.FindByIDs(qids)

	// giữ đúng thứ tự câu hỏi theo qids (FindByIDs có thể trả khác thứ tự)
	byID := map[uint]entity.Question{}
	for _, q := range questions {
		byID[q.ID] = q
	}
	ordered := make([]entity.Question, 0, len(qids))
	for _, id := range qids {
		if q, ok := byID[id]; ok {
			ordered = append(ordered, q)
		}
	}

	// Nguồn ngẫu nhiên:
	//   fixed       = seed theo exam.ID  -> mọi sinh viên thấy cùng một thứ tự
	//   per_student = seed theo mã bài làm -> mỗi người một thứ tự riêng, nhưng
	//                 tải lại trang vẫn giữ nguyên thứ tự cũ (cùng seed).
	seed := time.Now().UnixNano()
	if exam.ShuffleMode == "fixed" {
		seed = int64(exam.ID)
	} else if session != nil {
		seed = int64(session.SubmissionID)
	}
	rnd := rand.New(rand.NewSource(seed))

	if exam.Shuffle { // xáo thứ tự câu hỏi
		rnd.Shuffle(len(ordered), func(i, j int) { ordered[i], ordered[j] = ordered[j], ordered[i] })
	}

	out := make([]dto.TakeQuestion, 0, len(ordered))
	for _, q := range ordered {
		answers := make([]entity.Answer, len(q.Answers))
		copy(answers, q.Answers)
		if exam.ShuffleAnswers { // xáo thứ tự đáp án
			rnd.Shuffle(len(answers), func(i, j int) { answers[i], answers[j] = answers[j], answers[i] })
		}
		tq := dto.TakeQuestion{ID: q.ID, Content: q.Content}
		for _, a := range answers {
			tq.Answers = append(tq.Answers, dto.TakeAnswer{ID: a.ID, Label: a.Label, Content: a.Content})
		}
		out = append(out, tq)
	}
	return exam, out, session, nil
}

// remainingSeconds: số giây còn lại của phiên làm bài, tính từ giờ bắt đầu
// lưu ở server. Trả -1 nếu đề không giới hạn thời gian, 0 nếu đã hết giờ.
func remainingSeconds(exam *entity.Exam, sub *entity.Submission) int {
	if exam.Duration <= 0 {
		return -1
	}
	deadline := sub.StartTime.Add(time.Duration(exam.Duration) * time.Minute)
	left := int(time.Until(deadline).Seconds())
	if left < 0 {
		return 0
	}
	return left
}

// SubmitResult: kết quả chấm bài
type SubmitResult struct {
	SubmissionID uint    `json:"submission_id"`
	Total        int64   `json:"total"`
	Correct      int     `json:"correct"`
	Score        float64 `json:"score"`
	IsPassed     bool    `json:"is_passed"`
}

// Submit: chấm điểm tự động (thang 10). userID nil = khách.
func (s *SubmissionService) Submit(examID string, in dto.SubmitInput, userID *uint) (*SubmitResult, error) {
	exam, err := s.examRepo.FindByID(examID)
	if err != nil {
		return nil, errors.New("khong tim thay de thi")
	}
	total := s.examRepo.CountQuestions(exam.ID)
	if total == 0 {
		return nil, errors.New("de thi chua co cau hoi")
	}

	now := time.Now()
	var sub *entity.Submission

	if userID != nil {
		// Sinh viên: phải có phiên do Take mở ra. Nhờ vậy giờ bắt đầu là giờ
		// server ghi nhận, không phải giờ client tự khai.
		sub = s.subRepo.FindInProgress(exam.ID, *userID)
		if sub == nil {
			return nil, errors.New("chua bat dau lam bai hoac bai nay da nop roi")
		}
		if exam.Duration > 0 {
			deadline := sub.StartTime.Add(time.Duration(exam.Duration)*time.Minute + graceSubmit)
			if now.After(deadline) {
				return nil, errors.New("da qua thoi gian lam bai, khong the nop")
			}
		}
	} else {
		// Khách: chỉ được làm đề công khai, mỗi lần nộp là một bài mới.
		if err := s.canAccess(exam, nil); err != nil {
			return nil, err
		}
		sub = &entity.Submission{ExamID: exam.ID, StartTime: now, GuestName: in.GuestName}
	}

	// Đề đã đóng thì không nhận bài nữa (nới thêm graceSubmit cho mạng chậm).
	if !exam.EndTime.IsZero() && now.After(exam.EndTime.Add(graceSubmit)) {
		return nil, errors.New("de thi da dong, khong the nop bai")
	}

	correct := 0
	details := make([]entity.SubmissionDetail, 0, len(in.Answers))
	for _, a := range in.Answers {
		isRight := false
		if a.SelectedAnswerID != 0 {
			if ans, e := s.subRepo.FindAnswer(a.SelectedAnswerID); e == nil {
				// so cả QuestionID để client không gửi đáp án của câu khác
				isRight = ans.IsCorrect && ans.QuestionID == a.QuestionID
			}
		}
		if isRight {
			correct++
		}
		details = append(details, entity.SubmissionDetail{
			QuestionID:       a.QuestionID,
			SelectedAnswerID: a.SelectedAnswerID,
			IsCorrect:        isRight,
		})
	}

	score := float64(correct) / float64(total) * 10.0
	score = math.Round(score*100) / 100 // làm tròn 2 chữ số
	passed := score >= exam.PassScore

	sub.SubmitTime = now
	sub.Status = "graded"
	sub.TotalScore = score
	sub.IsPassed = passed
	if err := s.subRepo.SubmitTx(sub, details); err != nil {
		return nil, err
	}

	return &SubmitResult{
		SubmissionID: sub.ID,
		Total:        total,
		Correct:      correct,
		Score:        score,
		IsPassed:     passed,
	}, nil
}

func (s *SubmissionService) GetMySubmissions(userID interface{}) ([]repository.SubmissionRow, error) {
	return s.subRepo.FindByUser(userID)
}
