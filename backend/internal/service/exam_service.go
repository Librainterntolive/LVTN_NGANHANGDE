package service

import (
	"errors"
	"strconv"
	"time"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/entity"
	"quiz-backend/internal/repository"
)

type ExamService struct {
	repo      *repository.ExamRepository
	qRepo     *repository.QuestionRepository
	classRepo *repository.ClassRepository
}

func NewExamService(repo *repository.ExamRepository, qRepo *repository.QuestionRepository, classRepo *repository.ClassRepository) *ExamService {
	return &ExamService{repo: repo, qRepo: qRepo, classRepo: classRepo}
}

// Preview: trả đề + đầy đủ câu hỏi kèm đáp án (cho GV xem lại, có hiện đáp án đúng)
func (s *ExamService) Preview(idStr string, userID uint, role string) (*entity.Exam, []entity.Question, error) {
	exam, err := s.repo.FindByID(idStr)
	if err != nil {
		return nil, nil, err
	}
	if !canModify(exam.CreatedBy, userID, role) {
		return nil, nil, ErrNotOwner
	}
	qids := s.repo.GetQuestionIDs(exam.ID)
	questions, _ := s.qRepo.FindByIDs(qids)

	// giữ đúng thứ tự theo qids
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
	return exam, ordered, nil
}

func parseTime(s string) time.Time {
	if s == "" {
		return time.Time{}
	}
	layouts := []string{"2006-01-02T15:04", "2006-01-02T15:04:05", time.RFC3339}
	for _, l := range layouts {
		if t, err := time.Parse(l, s); err == nil {
			return t
		}
	}
	return time.Time{}
}

func (s *ExamService) GetAll(keyword, subjectID string, userID uint, role string) ([]entity.Exam, error) {
	items, _, err := s.repo.FindPagedForOwner(keyword, subjectID, userID, role == "Admin", 1000, 0)
	return items, err
}
func (s *ExamService) GetPaged(keyword, subjectID string, userID uint, role string, limit, offset int) ([]entity.Exam, int64, error) {
	return s.repo.FindPagedForOwner(keyword, subjectID, userID, role == "Admin", limit, offset)
}

// đề công khai cho khách dùng thử
func (s *ExamService) GetPublic() ([]entity.Exam, error) {
	return s.repo.FindPublic()
}
func (s *ExamService) GetPublicPaged(subjectID string, limit, offset int) ([]entity.Exam, int64, error) {
	return s.repo.FindPublicPaged(subjectID, limit, offset)
}

// đề đã phát hành cho "ngân hàng đề" (mọi người đăng nhập đều xem được)
func (s *ExamService) GetBank() ([]entity.Exam, error) {
	return s.repo.FindPublished()
}

func (s *ExamService) GetBankPaged(subjectID, keyword string, limit, offset int) ([]entity.Exam, int64, error) {
	return s.repo.FindPublishedPaged(subjectID, keyword, limit, offset)
}

// GetDetail: trả đề + danh sách câu hỏi + lớp (cho màn hình sửa)
func (s *ExamService) GetDetail(id string, userID uint, role string) (*entity.Exam, []uint, []uint, error) {
	exam, err := s.repo.FindByID(id)
	if err != nil {
		return nil, nil, nil, err
	}
	if !canModify(exam.CreatedBy, userID, role) {
		return nil, nil, nil, ErrNotOwner
	}
	return exam, s.repo.GetQuestionIDs(exam.ID), s.repo.GetClassIDs(exam.ID), nil
}

func (s *ExamService) Create(in dto.ExamInput, createdBy uint, role string) (*entity.Exam, error) {
	if n := s.qRepo.CountNotApproved(in.QuestionIDs); n > 0 {
		return nil, errors.New("Đề thi chứa câu hỏi chưa được duyệt hoặc thiếu nguồn")
	}
	if err := s.validateClassAssignments(in.ClassIDs, createdBy, role); err != nil {
		return nil, err
	}
	exam := &entity.Exam{
		SubjectID:      in.SubjectID,
		CreatedBy:      createdBy,
		Title:          in.Title,
		Description:    in.Description,
		StartTime:      parseTime(in.StartTime),
		EndTime:        parseTime(in.EndTime),
		Duration:       in.Duration,
		PassScore:      in.PassScore,
		Shuffle:        in.Shuffle,
		ShuffleAnswers: in.ShuffleAnswers,
		ShuffleMode:    defaultStr(in.ShuffleMode, "per_student"),
		AccessType:     defaultStr(in.AccessType, "private"),
		MaxAttempts:    in.MaxAttempts,
		Status:         defaultStr(in.Status, "draft"),
	}
	if err := s.repo.Create(exam); err != nil {
		return nil, err
	}
	s.repo.SetQuestions(exam.ID, in.QuestionIDs)
	s.repo.SetClasses(exam.ID, in.ClassIDs)
	return exam, nil
}

func (s *ExamService) Update(id string, in dto.ExamInput, userID uint, role string) (*entity.Exam, error) {
	if n := s.qRepo.CountNotApproved(in.QuestionIDs); n > 0 {
		return nil, errors.New("Đề thi chứa câu hỏi chưa được duyệt hoặc thiếu nguồn")
	}
	exam, err := s.repo.FindByID(id)
	if err != nil {
		return nil, err
	}
	if !canModify(exam.CreatedBy, userID, role) {
		return nil, ErrNotOwner
	}
	if in.ClassIDs != nil {
		if err := s.validateClassAssignments(in.ClassIDs, userID, role); err != nil {
			return nil, err
		}
	}
	exam.SubjectID = in.SubjectID
	exam.Title = in.Title
	exam.Description = in.Description
	exam.StartTime = parseTime(in.StartTime)
	exam.EndTime = parseTime(in.EndTime)
	exam.Duration = in.Duration
	exam.PassScore = in.PassScore
	exam.Shuffle = in.Shuffle
	exam.ShuffleAnswers = in.ShuffleAnswers
	exam.ShuffleMode = defaultStr(in.ShuffleMode, "per_student")
	exam.AccessType = defaultStr(in.AccessType, "private")
	exam.MaxAttempts = in.MaxAttempts
	exam.Status = defaultStr(in.Status, "draft")
	if err := s.repo.Update(exam); err != nil {
		return nil, err
	}
	// Chỉ thay danh sách khi client CÓ gửi trường tương ứng.
	// Trước đây gọi PUT mà quên kèm question_ids là xóa sạch câu hỏi của đề.
	// nil = không gửi -> giữ nguyên; [] = gửi mảng rỗng -> cố ý xóa hết.
	if in.QuestionIDs != nil {
		s.repo.SetQuestions(exam.ID, in.QuestionIDs)
	}
	if in.ClassIDs != nil {
		s.repo.SetClasses(exam.ID, in.ClassIDs)
	}
	return exam, nil
}

// Generate: sinh đề tự động theo ma trận (chương × độ khó × số câu).
// Bốc ngẫu nhiên câu CHÍNH THỨC trong ngân hàng; thiếu câu ở dòng nào thì báo rõ dòng đó.
func (s *ExamService) Generate(in dto.GenerateExamInput, createdBy uint, role string) (*entity.Exam, int, error) {
	var qids []uint
	for i, rule := range in.Rules {
		if rule.Count <= 0 {
			continue
		}
		ids, err := s.qRepo.PickRandomIDs(in.SubjectID, rule.Chapter, rule.Difficulty, rule.Count, qids)
		if err != nil {
			return nil, 0, err
		}
		if len(ids) < rule.Count {
			return nil, 0, errors.New("Dòng " + strconv.Itoa(i+1) + " của ma trận: chỉ còn " +
				strconv.Itoa(len(ids)) + " câu khả dụng trong ngân hàng (cần " + strconv.Itoa(rule.Count) + ")")
		}
		qids = append(qids, ids...)
	}
	if len(qids) == 0 {
		return nil, 0, errors.New("Ma trận chưa có dòng nào hợp lệ (số câu > 0)")
	}
	in.ExamInput.QuestionIDs = qids
	exam, err := s.Create(in.ExamInput, createdBy, role)
	return exam, len(qids), err
}

// Clone: nhân bản 1 đề về cho người dùng (GV thấy đề hay thì copy về chỉnh thành đề riêng).
// Đề mới ở trạng thái nháp, riêng tư, dùng chung danh sách câu hỏi với đề gốc.
func (s *ExamService) Clone(id string, userID uint) (*entity.Exam, error) {
	src, err := s.repo.FindByID(id)
	if err != nil {
		return nil, errors.New("Không tìm thấy đề gốc")
	}
	if src.CreatedBy != userID && (src.Status != "published" || src.AccessType != "public" || !s.repo.HasVerifiedQuestionSet(src.ID)) {
		return nil, ErrNotOwner
	}
	clone := &entity.Exam{
		SubjectID:      src.SubjectID,
		CreatedBy:      userID,
		Title:          src.Title + " (bản sao)",
		Description:    src.Description,
		Duration:       src.Duration,
		PassScore:      src.PassScore,
		Shuffle:        src.Shuffle,
		ShuffleAnswers: src.ShuffleAnswers,
		ShuffleMode:    src.ShuffleMode,
		AccessType:     "private",
		MaxAttempts:    src.MaxAttempts,
		Status:         "draft",
	}
	if err := s.repo.Create(clone); err != nil {
		return nil, err
	}
	s.repo.SetQuestions(clone.ID, s.repo.GetQuestionIDs(src.ID))
	return clone, nil
}

func (s *ExamService) Delete(id string, userID uint, role string) error {
	exam, err := s.repo.FindByID(id)
	if err != nil {
		return errors.New("Không tìm thấy đề thi")
	}
	if !canModify(exam.CreatedBy, userID, role) {
		return ErrNotOwner
	}
	return s.repo.Delete(id)
}

func (s *ExamService) validateClassAssignments(classIDs []uint, userID uint, role string) error {
	if role == "Admin" {
		return nil
	}
	for _, classID := range classIDs {
		classroom, err := s.classRepo.FindByID(strconv.FormatUint(uint64(classID), 10))
		if err != nil || (classroom.CreatedBy != userID && !classroom.IsPublic) {
			return ErrNotOwner
		}
	}
	return nil
}

// lấy danh sách id câu hỏi của 1 đề (để gộp khi tạo đề mới)
func (s *ExamService) GetReusableQuestionIDs(examID string, userID uint, role string) ([]uint, error) {
	exam, err := s.repo.FindByID(examID)
	if err != nil {
		return nil, errors.New("Không tìm thấy đề thi")
	}
	if !canModify(exam.CreatedBy, userID, role) && (exam.Status != "published" || exam.AccessType != "public" || !s.repo.HasVerifiedQuestionSet(exam.ID)) {
		return nil, ErrNotOwner
	}
	return s.repo.GetQuestionIDs(exam.ID), nil
}
