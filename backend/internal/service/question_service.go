package service

import (
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"strconv"
	"strings"
	"time"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/entity"
	"quiz-backend/internal/repository"
)

func normalizedQuestionContent(content string) string {
	return strings.ToLower(strings.Join(strings.Fields(content), " "))
}

func questionContentHash(content string) string {
	sum := sha256.Sum256([]byte(normalizedQuestionContent(content)))
	return hex.EncodeToString(sum[:])
}

func normalizeQuestionPaging(page, limit int) (int, int) {
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	return page, limit
}

type QuestionService struct {
	repo        *repository.QuestionRepository
	userRepo    *repository.UserRepository
	chapterRepo *repository.ChapterRepository
	sourceSvc   *SourceService
}

func NewQuestionService(repo *repository.QuestionRepository, userRepo *repository.UserRepository, chapterRepo *repository.ChapterRepository, sourceSvc *SourceService) *QuestionService {
	return &QuestionService{repo: repo, userRepo: userRepo, chapterRepo: chapterRepo, sourceSvc: sourceSvc}
}

// map id người dùng -> tên hiển thị
func (s *QuestionService) userNameMap(questions []entity.Question) map[uint]string {
	creatorIDs := make([]uint, 0, len(questions))
	for _, question := range questions {
		creatorIDs = append(creatorIDs, question.CreatedBy)
	}
	names, err := s.userRepo.FindNameMap(creatorIDs)
	if err != nil {
		return map[uint]string{}
	}
	return names
}

// GetPaged: trả 1 trang câu hỏi + tổng số (cho lazy-load)
func (s *QuestionService) GetPaged(f repository.QuestionFilter, page, limit int) ([]entity.Question, int64, error) {
	page, limit = normalizeQuestionPaging(page, limit)
	offset := (page - 1) * limit

	questions, err := s.repo.FindPaged(f, limit, offset)
	if err != nil {
		return nil, 0, err
	}
	total, _ := s.repo.Count(f)

	names := s.userNameMap(questions)
	ids := make([]uint, 0, len(questions))
	for i := range questions {
		questions[i].CreatorName = names[questions[i].CreatedBy]
		ids = append(ids, questions[i].ID)
	}
	// số đề thi đang dùng từng câu (để hiện khóa trên UI)
	used, _ := s.repo.UsedCounts(ids)
	performance, _ := s.repo.Performance(ids)
	for i := range questions {
		questions[i].UsedCount = used[questions[i].ID]
		if metric, exists := performance[questions[i].ID]; exists {
			questions[i].AttemptCount = metric.AttemptCount
			if metric.AttemptCount > 0 {
				questions[i].CorrectRate = float64(metric.CorrectCount) * 100 / float64(metric.AttemptCount)
			}
		}
	}
	return questions, total, nil
}

func (s *QuestionService) GetByID(id string, userID uint, role string) (*entity.Question, error) {
	q, err := s.repo.FindByID(id)
	if err != nil {
		return nil, err
	}
	if !canModify(q.CreatedBy, userID, role) && (q.ReviewStatus != "approved" || q.Source == nil || q.Source.VerificationStatus != "verified") {
		return nil, ErrNotOwner
	}
	q.UsedCount = s.repo.UsedCount(q.ID)
	return q, nil
}

// đảm bảo đúng 1 đáp án đúng, tối thiểu 2 đáp án
func validateOneCorrect(answers []dto.AnswerInput) error {
	if len(answers) < 2 {
		return errors.New("Câu hỏi cần ít nhất 2 đáp án")
	}
	count := 0
	for _, a := range answers {
		if a.IsCorrect {
			count++
		}
	}
	if count != 1 {
		return errors.New("Phải có đúng 1 đáp án đúng")
	}
	return nil
}

// validStatus: chỉ nhận draft/active, mặc định active
func validStatus(s string) string {
	if s == "active" {
		return "active"
	}
	return "draft"
}

// validateChapter: chương (nếu có) phải thuộc đúng môn của câu hỏi
func (s *QuestionService) validateChapter(chapterID *uint, subjectID uint) error {
	if chapterID == nil {
		return nil
	}
	chapter, err := s.chapterRepo.FindByID(strconv.Itoa(int(*chapterID)))
	if err != nil {
		return errors.New("Chương không tồn tại")
	}
	if chapter.SubjectID != subjectID {
		return errors.New("Chương không thuộc môn học đã chọn")
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
	if err := s.sourceSvc.RequireValidSource(in.SourceID, in.SourceReference); err != nil {
		return nil, err
	}
	if exists, err := s.repo.ContentExists(in.SubjectID, questionContentHash(in.Content), 0); err != nil {
		return nil, err
	} else if exists {
		return nil, errors.New("Câu hỏi trùng nội dung đã tồn tại trong học phần")
	}
	reviewStatus := "draft"
	if in.SubmitForReview {
		reviewStatus = "pending"
	}
	question := &entity.Question{
		SubjectID:    in.SubjectID,
		ChapterID:    in.ChapterID,
		CreatedBy:    createdBy,
		Content:      in.Content,
		ContentHash:  questionContentHash(in.Content),
		QuestionType: defaultStr(in.QuestionType, "single"),
		Difficulty:   defaultStr(in.Difficulty, "medium"),
		Status:       "draft",
		SourceID:     in.SourceID,
		SourceRef:    in.SourceReference,
		ReviewStatus: reviewStatus,
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
	if err := s.sourceSvc.RequireValidSource(in.SourceID, in.SourceReference); err != nil {
		return nil, err
	}
	if exists, err := s.repo.ContentExists(in.SubjectID, questionContentHash(in.Content), question.ID); err != nil {
		return nil, err
	} else if exists {
		return nil, errors.New("Câu hỏi trùng nội dung đã tồn tại trong học phần")
	}
	question.SubjectID = in.SubjectID
	question.ChapterID = in.ChapterID
	question.Content = in.Content
	question.ContentHash = questionContentHash(in.Content)
	question.QuestionType = defaultStr(in.QuestionType, "single")
	question.Difficulty = defaultStr(in.Difficulty, "medium")
	question.Status = validStatus(in.Status)
	if question.ReviewStatus != "approved" {
		question.Status = "draft"
	}
	question.SourceID = in.SourceID
	question.SourceRef = in.SourceReference
	if in.SubmitForReview {
		question.ReviewStatus = "pending"
		question.ReviewNote = ""
		question.ReviewedBy = nil
		question.ReviewedAt = nil
	} else if question.ReviewStatus != "approved" {
		question.ReviewStatus = "draft"
	}
	question.Answers = nil
	if err := s.repo.Update(question); err != nil {
		return nil, err
	}
	if err := s.repo.ReplaceAnswers(question.ID, toAnswers(in.Answers)); err != nil {
		return nil, err
	}
	return s.repo.FindByID(id)
}

func (s *QuestionService) SubmitForReview(id string, userID uint, role string) (*entity.Question, error) {
	question, err := s.repo.FindByID(id)
	if err != nil {
		return nil, err
	}
	if !canModify(question.CreatedBy, userID, role) {
		return nil, ErrNotOwner
	}
	if err := s.sourceSvc.RequireValidSource(question.SourceID, question.SourceRef); err != nil {
		return nil, err
	}
	if question.ReviewStatus == "approved" {
		return nil, errors.New("Câu hỏi đã được duyệt")
	}
	question.ReviewStatus = "pending"
	question.Status = "draft"
	question.ReviewNote = ""
	question.ReviewedBy = nil
	question.ReviewedAt = nil
	if err := s.repo.Update(question); err != nil {
		return nil, err
	}
	return s.repo.FindByID(id)
}

func (s *QuestionService) Review(id string, in dto.ReviewInput, reviewerID uint) (*entity.Question, error) {
	question, err := s.repo.FindByID(id)
	if err != nil {
		return nil, err
	}
	if question.ReviewStatus != "pending" {
		return nil, errors.New("Chỉ duyệt được câu hỏi đang chờ duyệt")
	}
	now := time.Now()
	question.ReviewStatus = in.Status
	question.ReviewNote = in.Note
	question.ReviewedBy = &reviewerID
	question.ReviewedAt = &now
	if in.Status == "approved" {
		question.Status = "active"
	} else {
		question.Status = "draft"
	}
	if err := s.repo.Update(question); err != nil {
		return nil, err
	}
	return s.repo.FindByID(id)
}

func (s *QuestionService) Delete(id string, userID uint, role string) error {
	question, err := s.repo.FindByID(id)
	if err != nil {
		return errors.New("Không tìm thấy câu hỏi")
	}
	if !canModify(question.CreatedBy, userID, role) {
		return ErrNotOwner
	}
	if n := s.repo.UsedCount(question.ID); n > 0 {
		return errors.New("cau hoi da duoc dung trong " + strconv.FormatInt(n, 10) + " de thi, khong the xoa")
	}
	return s.repo.Delete(id)
}
