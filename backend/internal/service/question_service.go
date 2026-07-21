package service

import (
	"errors"
	"strconv"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/entity"
	"quiz-backend/internal/repository"
)

type QuestionService struct {
	repo        *repository.QuestionRepository
	userRepo    *repository.UserRepository
	chapterRepo *repository.ChapterRepository
}

func NewQuestionService(repo *repository.QuestionRepository, userRepo *repository.UserRepository, chapterRepo *repository.ChapterRepository) *QuestionService {
	return &QuestionService{repo: repo, userRepo: userRepo, chapterRepo: chapterRepo}
}

// map id người dùng -> tên hiển thị
func (s *QuestionService) userNameMap() map[uint]string {
	m := map[uint]string{}
	users, _ := s.userRepo.FindAll()
	for _, u := range users {
		name := u.FullName
		if name == "" {
			name = u.Username
		}
		m[u.ID] = name
	}
	return m
}

// GetPaged: trả 1 trang câu hỏi + tổng số (cho lazy-load)
func (s *QuestionService) GetPaged(f repository.QuestionFilter, page, limit int) ([]entity.Question, int64, error) {
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 100 {
		limit = 12
	}
	offset := (page - 1) * limit

	questions, err := s.repo.FindPaged(f, limit, offset)
	if err != nil {
		return nil, 0, err
	}
	total, _ := s.repo.Count(f)

	names := s.userNameMap()
	ids := make([]uint, 0, len(questions))
	for i := range questions {
		questions[i].CreatorName = names[questions[i].CreatedBy]
		ids = append(ids, questions[i].ID)
	}
	// số đề thi đang dùng từng câu (để hiện khóa trên UI)
	used, _ := s.repo.UsedCounts(ids)
	for i := range questions {
		questions[i].UsedCount = used[questions[i].ID]
	}
	return questions, total, nil
}

func (s *QuestionService) GetByID(id string) (*entity.Question, error) {
	q, err := s.repo.FindByID(id)
	if err != nil {
		return nil, err
	}
	q.UsedCount = s.repo.UsedCount(q.ID)
	return q, nil
}

// đảm bảo đúng 1 đáp án đúng, tối thiểu 2 đáp án
func validateOneCorrect(answers []dto.AnswerInput) error {
	if len(answers) < 2 {
		return errors.New("cau hoi can it nhat 2 dap an")
	}
	count := 0
	for _, a := range answers {
		if a.IsCorrect {
			count++
		}
	}
	if count != 1 {
		return errors.New("phai co dung 1 dap an dung")
	}
	return nil
}

// validStatus: chỉ nhận draft/active, mặc định active
func validStatus(s string) string {
	if s == "draft" {
		return "draft"
	}
	return "active"
}

// validateChapter: chương (nếu có) phải thuộc đúng môn của câu hỏi
func (s *QuestionService) validateChapter(chapterID *uint, subjectID uint) error {
	if chapterID == nil {
		return nil
	}
	chapter, err := s.chapterRepo.FindByID(strconv.Itoa(int(*chapterID)))
	if err != nil {
		return errors.New("chuong khong ton tai")
	}
	if chapter.SubjectID != subjectID {
		return errors.New("chuong khong thuoc mon hoc da chon")
	}
	return nil
}

func (s *QuestionService) Create(in dto.QuestionInput, createdBy uint) (*entity.Question, error) {
	if err := validateOneCorrect(in.Answers); err != nil {
		return nil, err
	}
	if err := s.validateChapter(in.ChapterID, in.SubjectID); err != nil {
		return nil, err
	}
	question := &entity.Question{
		SubjectID:    in.SubjectID,
		ChapterID:    in.ChapterID,
		CreatedBy:    createdBy,
		Content:      in.Content,
		QuestionType: defaultStr(in.QuestionType, "single"),
		Difficulty:   defaultStr(in.Difficulty, "medium"),
		Status:       validStatus(in.Status),
		Answers:      toAnswers(in.Answers),
	}
	err := s.repo.Create(question)
	return question, err
}

func (s *QuestionService) Update(id string, in dto.QuestionInput, userID uint, role string) (*entity.Question, error) {
	if err := validateOneCorrect(in.Answers); err != nil {
		return nil, err
	}
	question, err := s.repo.FindByID(id)
	if err != nil {
		return nil, err
	}
	if !canModify(question.CreatedBy, userID, role) {
		return nil, ErrNotOwner
	}
	// câu đã dùng trong đề thi thì khóa, không cho sửa (bảo toàn đề đã phát hành)
	if n := s.repo.UsedCount(question.ID); n > 0 {
		return nil, errors.New("cau hoi da duoc dung trong " + strconv.FormatInt(n, 10) + " de thi, khong the sua - hay Nhan ban de tao ban moi")
	}
	if err := s.validateChapter(in.ChapterID, in.SubjectID); err != nil {
		return nil, err
	}
	question.SubjectID = in.SubjectID
	question.ChapterID = in.ChapterID
	question.Content = in.Content
	question.QuestionType = defaultStr(in.QuestionType, "single")
	question.Difficulty = defaultStr(in.Difficulty, "medium")
	question.Status = validStatus(in.Status)
	question.Answers = nil
	if err := s.repo.Update(question); err != nil {
		return nil, err
	}
	if err := s.repo.ReplaceAnswers(question.ID, toAnswers(in.Answers)); err != nil {
		return nil, err
	}
	return s.repo.FindByID(id)
}

func (s *QuestionService) Delete(id string, userID uint, role string) error {
	question, err := s.repo.FindByID(id)
	if err != nil {
		return errors.New("khong tim thay cau hoi")
	}
	if !canModify(question.CreatedBy, userID, role) {
		return ErrNotOwner
	}
	if n := s.repo.UsedCount(question.ID); n > 0 {
		return errors.New("cau hoi da duoc dung trong " + strconv.FormatInt(n, 10) + " de thi, khong the xoa")
	}
	return s.repo.Delete(id)
}
