package service

import (
	"errors"
	"sort"
	"time"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/entity"
	"quiz-backend/internal/repository"
)

type PracticeService struct {
	repo       *repository.PracticeRepository
	qRepo      *repository.QuestionRepository
	folderRepo *repository.FolderRepository
}

func NewPracticeService(repo *repository.PracticeRepository, qRepo *repository.QuestionRepository, folderRepo *repository.FolderRepository) *PracticeService {
	return &PracticeService{repo: repo, qRepo: qRepo, folderRepo: folderRepo}
}

// WrongQuestion: 1 mục trong "sổ tay câu sai"
type WrongQuestion struct {
	QuestionID uint   `json:"question_id"`
	Content    string `json:"content"`
	SubjectID  uint   `json:"subject_id"`
	Difficulty string `json:"difficulty"`
	WrongCount int    `json:"wrong_count"` // tổng số lần trả lời sai
	NeedStreak int    `json:"need_streak"` // còn cần đúng liên tiếp mấy lần để rời sổ tay
}

const practiceQuestionLimit = 20

// notebookIDs: tính danh sách câu đang nằm trong sổ tay.
// Quy tắc: từng trả lời sai ít nhất 1 lần, và CHƯA đúng 2 lần liên tiếp gần nhất.
func (s *PracticeService) notebookState(userID uint) (map[uint]*WrongQuestion, error) {
	events, err := s.repo.AnswerEvents(userID)
	if err != nil {
		return nil, err
	}
	type state struct {
		wrong  int
		streak int // số lần đúng liên tiếp gần nhất
	}
	states := map[uint]*state{}
	for _, e := range events {
		st := states[e.QuestionID]
		if st == nil {
			st = &state{}
			states[e.QuestionID] = st
		}
		if e.IsCorrect {
			st.streak++
		} else {
			st.wrong++
			st.streak = 0
		}
	}
	out := map[uint]*WrongQuestion{}
	for qid, st := range states {
		if st.wrong > 0 && st.streak < 2 {
			out[qid] = &WrongQuestion{QuestionID: qid, WrongCount: st.wrong, NeedStreak: 2 - st.streak}
		}
	}
	return out, nil
}

// GetNotebook: danh sách câu sai kèm nội dung (câu đã bị xóa khỏi ngân hàng thì bỏ qua)
func (s *PracticeService) GetNotebook(userID uint) ([]WrongQuestion, error) {
	state, err := s.notebookState(userID)
	if err != nil {
		return nil, err
	}
	ids := make([]uint, 0, len(state))
	for qid := range state {
		ids = append(ids, qid)
	}
	questions, err := s.qRepo.FindByIDs(ids)
	if err != nil {
		return nil, err
	}
	out := make([]WrongQuestion, 0, len(questions))
	for _, q := range questions {
		w := state[q.ID]
		w.Content = q.Content
		w.SubjectID = q.SubjectID
		w.Difficulty = q.Difficulty
		out = append(out, *w)
	}
	// sai nhiều lên đầu
	for i := 1; i < len(out); i++ {
		for j := i; j > 0 && out[j].WrongCount > out[j-1].WrongCount; j-- {
			out[j], out[j-1] = out[j-1], out[j]
		}
	}
	return out, nil
}

func (s *PracticeService) notebookEntries(userID uint) ([]WrongQuestion, error) {
	state, err := s.notebookState(userID)
	if err != nil {
		return nil, err
	}
	items := make([]WrongQuestion, 0, len(state))
	for _, item := range state {
		items = append(items, *item)
	}
	sort.Slice(items, func(i, j int) bool {
		if items[i].WrongCount == items[j].WrongCount {
			return items[i].QuestionID < items[j].QuestionID
		}
		return items[i].WrongCount > items[j].WrongCount
	})
	return items, nil
}

func (s *PracticeService) hydrateNotebook(items []WrongQuestion) ([]WrongQuestion, error) {
	if len(items) == 0 {
		return []WrongQuestion{}, nil
	}
	ids := make([]uint, 0, len(items))
	for _, item := range items {
		ids = append(ids, item.QuestionID)
	}
	questions, err := s.qRepo.FindByIDs(ids)
	if err != nil {
		return nil, err
	}
	questionByID := make(map[uint]entity.Question, len(questions))
	for _, question := range questions {
		questionByID[question.ID] = question
	}
	hydrated := make([]WrongQuestion, 0, len(items))
	for _, item := range items {
		question, ok := questionByID[item.QuestionID]
		if !ok {
			continue
		}
		item.Content = question.Content
		item.SubjectID = question.SubjectID
		item.Difficulty = question.Difficulty
		hydrated = append(hydrated, item)
	}
	return hydrated, nil
}

func (s *PracticeService) GetNotebookPaged(userID uint, limit, offset int) ([]WrongQuestion, int, error) {
	items, err := s.notebookEntries(userID)
	if err != nil {
		return nil, 0, err
	}
	total := len(items)
	if offset >= total {
		return []WrongQuestion{}, total, nil
	}
	end := offset + limit
	if end > total {
		end = total
	}
	pageItems, err := s.hydrateNotebook(items[offset:end])
	if err != nil {
		return nil, 0, err
	}
	return pageItems, total, nil
}

func (s *PracticeService) practiceNotebook(userID uint) ([]WrongQuestion, error) {
	notebook, err := s.notebookEntries(userID)
	if err != nil {
		return nil, err
	}
	if len(notebook) > practiceQuestionLimit {
		notebook = notebook[:practiceQuestionLimit]
	}
	return notebook, nil
}

// GetPracticeSet: lấy bộ câu hỏi để luyện lại (ẩn đáp án đúng)
func (s *PracticeService) GetPracticeSet(userID uint) ([]dto.TakeQuestion, error) {
	notebook, err := s.practiceNotebook(userID)
	if err != nil {
		return nil, err
	}
	ids := make([]uint, 0, len(notebook))
	for _, item := range notebook {
		ids = append(ids, item.QuestionID)
	}
	if len(ids) == 0 {
		return []dto.TakeQuestion{}, nil
	}
	questions, err := s.qRepo.FindByIDs(ids)
	if err != nil {
		return nil, err
	}
	out := make([]dto.TakeQuestion, 0, len(questions))
	for _, q := range questions {
		tq := dto.TakeQuestion{ID: q.ID, Content: q.Content}
		for _, a := range q.Answers {
			tq.Answers = append(tq.Answers, dto.TakeAnswer{ID: a.ID, Label: a.Label, Content: a.Content})
		}
		out = append(out, tq)
	}
	return out, nil
}

// PracticeResult: kết quả chấm 1 câu khi luyện
type PracticeResult struct {
	QuestionID      uint `json:"question_id"`
	IsCorrect       bool `json:"is_correct"`
	CorrectAnswerID uint `json:"correct_answer_id"`
	Mastered        bool `json:"mastered"` // đã đúng đủ 2 lần liên tiếp -> rời sổ tay
}

// SubmitPractice: chấm bộ câu luyện lại + ghi log để cập nhật sổ tay
func (s *PracticeService) SubmitPractice(userID uint, answers []dto.SubmitAnswer) ([]PracticeResult, error) {
	if len(answers) == 0 {
		return nil, errors.New("Chưa trả lời câu nào")
	}
	if len(answers) > practiceQuestionLimit {
		return nil, errors.New("Chỉ được nộp tối đa 20 câu trong một lượt luyện")
	}
	notebook, err := s.practiceNotebook(userID)
	if err != nil {
		return nil, err
	}
	allowed := make(map[uint]bool, len(notebook))
	for _, item := range notebook {
		allowed[item.QuestionID] = true
	}
	seen := make(map[uint]bool, len(answers))
	for _, answer := range answers {
		if answer.QuestionID == 0 || seen[answer.QuestionID] || !allowed[answer.QuestionID] {
			return nil, errors.New("Có câu hỏi không thuộc bộ luyện tập hiện tại")
		}
		seen[answer.QuestionID] = true
	}
	state, err := s.notebookState(userID)
	if err != nil {
		return nil, err
	}
	ids := make([]uint, 0, len(answers))
	for _, a := range answers {
		ids = append(ids, a.QuestionID)
	}
	questions, err := s.qRepo.FindByIDs(ids)
	if err != nil {
		return nil, err
	}
	byID := map[uint]entity.Question{}
	for _, q := range questions {
		byID[q.ID] = q
	}

	var logs []entity.PracticeAnswer
	var results []PracticeResult
	now := time.Now()
	for _, a := range answers {
		q, ok := byID[a.QuestionID]
		if !ok {
			continue
		}
		var correctID uint
		for _, ans := range q.Answers {
			if ans.IsCorrect {
				correctID = ans.ID
			}
		}
		isCorrect := a.SelectedAnswerID == correctID
		logs = append(logs, entity.PracticeAnswer{
			UserID: userID, QuestionID: q.ID, IsCorrect: isCorrect, CreatedAt: now,
		})
		// mastered: trước đó cần đúng 1 lần nữa (need_streak=1) và lần này đúng
		mastered := false
		if st := state[q.ID]; st != nil && isCorrect && st.NeedStreak <= 1 {
			mastered = true
		}
		results = append(results, PracticeResult{
			QuestionID: q.ID, IsCorrect: isCorrect, CorrectAnswerID: correctID, Mastered: mastered,
		})
	}
	if err := s.repo.SaveAnswers(logs); err != nil {
		return nil, err
	}
	return results, nil
}

// MyStats: thống kê góc học tập cá nhân
type MyStats struct {
	SavedExams int     `json:"saved_exams"`
	Attempts   int64   `json:"attempts"`
	AvgScore   float64 `json:"avg_score"`
	WrongCount int     `json:"wrong_count"` // số câu đang trong sổ tay
	StreakDays int     `json:"streak_days"` // chuỗi ngày học liên tiếp
}

func (s *PracticeService) GetMyStats(userID uint) (*MyStats, error) {
	saved, _ := s.folderRepo.SavedExamIDs(userID)
	attempts, avg := s.repo.SubmissionSummary(userID)
	notebook, err := s.notebookState(userID)
	if err != nil {
		return nil, err
	}

	// streak: đếm lùi từ hôm nay (hoặc hôm qua nếu hôm nay chưa học)
	dates := s.repo.ActivityDates(userID)
	streak := 0
	day := time.Now()
	if !dates[day.Format("2006-01-02")] {
		day = day.AddDate(0, 0, -1) // hôm nay chưa học -> chuỗi tính đến hôm qua
	}
	for dates[day.Format("2006-01-02")] {
		streak++
		day = day.AddDate(0, 0, -1)
	}

	return &MyStats{
		SavedExams: len(saved),
		Attempts:   attempts,
		AvgScore:   avg,
		WrongCount: len(notebook),
		StreakDays: streak,
	}, nil
}
