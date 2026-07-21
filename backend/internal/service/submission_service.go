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

// Take: trả đề + câu hỏi đã ẩn đáp án đúng
func (s *SubmissionService) Take(examID string) (*entity.Exam, []dto.TakeQuestion, error) {
	exam, err := s.examRepo.FindByID(examID)
	if err != nil {
		return nil, nil, errors.New("khong tim thay de thi")
	}
	if exam.Status != "published" {
		return nil, nil, errors.New("de thi chua mo")
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

	// nguồn ngẫu nhiên: fixed = giống nhau mọi học sinh (seed theo exam.ID),
	// per_student = mỗi lần vào làm một thứ tự khác
	rnd := rand.New(rand.NewSource(time.Now().UnixNano()))
	if exam.ShuffleMode == "fixed" {
		rnd = rand.New(rand.NewSource(int64(exam.ID)))
	}

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
	return exam, out, nil
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

	sub := &entity.Submission{
		ExamID:     exam.ID,
		StartTime:  time.Now(),
		SubmitTime: time.Now(),
		Status:     "graded",
		UserID:     userID,
		GuestName:  in.GuestName,
	}
	if err := s.subRepo.Create(sub); err != nil {
		return nil, err
	}

	correct := 0
	for _, a := range in.Answers {
		isRight := false
		if a.SelectedAnswerID != 0 {
			if ans, e := s.subRepo.FindAnswer(a.SelectedAnswerID); e == nil {
				isRight = ans.IsCorrect && ans.QuestionID == a.QuestionID
			}
		}
		if isRight {
			correct++
		}
		s.subRepo.CreateDetail(&entity.SubmissionDetail{
			SubmissionID:     sub.ID,
			QuestionID:       a.QuestionID,
			SelectedAnswerID: a.SelectedAnswerID,
			IsCorrect:        isRight,
		})
	}

	score := float64(correct) / float64(total) * 10.0
	score = math.Round(score*100) / 100 // làm tròn 2 chữ số
	passed := score >= exam.PassScore
	sub.TotalScore = score
	sub.IsPassed = passed
	s.subRepo.Update(sub)

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
