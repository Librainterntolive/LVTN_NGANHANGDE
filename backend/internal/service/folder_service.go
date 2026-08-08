package service

import (
	"errors"

	"quiz-backend/internal/entity"
	"quiz-backend/internal/repository"
)

type FolderService struct {
	repo *repository.FolderRepository
}

func NewFolderService(repo *repository.FolderRepository) *FolderService {
	return &FolderService{repo: repo}
}

func (s *FolderService) GetMine(userID uint) ([]entity.Folder, error) {
	return s.repo.FindByUser(userID)
}

func (s *FolderService) Create(name string, parentID *uint, userID uint) (*entity.Folder, error) {
	if name == "" {
		return nil, errors.New("Cần nhập tên thư mục")
	}
	f := &entity.Folder{Name: name, ParentID: parentID, UserID: userID}
	err := s.repo.Create(f)
	return f, err
}

func (s *FolderService) Rename(id string, name string, userID uint) (*entity.Folder, error) {
	f, err := s.repo.FindByID(id)
	if err != nil || f.UserID != userID {
		return nil, errors.New("Không tìm thấy thư mục")
	}
	f.Name = name
	err = s.repo.Update(f)
	return f, err
}

// Delete: xóa thư mục + toàn bộ thư mục con (đệ quy) + đề đã lưu
func (s *FolderService) Delete(id string, userID uint) error {
	f, err := s.repo.FindByID(id)
	if err != nil || f.UserID != userID {
		return errors.New("Không tìm thấy thư mục")
	}
	s.deleteRecursive(f.ID)
	return nil
}

func (s *FolderService) deleteRecursive(folderID uint) {
	children, _ := s.repo.FindChildren(folderID)
	for _, c := range children {
		s.deleteRecursive(c.ID)
	}
	s.repo.Delete(folderID)
}

func (s *FolderService) GetExams(folderID string, userID uint) ([]repository.SavedExam, error) {
	f, err := s.repo.FindByID(folderID)
	if err != nil || f.UserID != userID {
		return nil, errors.New("Không tìm thấy thư mục")
	}
	exams, err := s.repo.FindExams(f.ID, userID)
	if err != nil {
		return nil, err
	}
	// điền tiến độ làm bài (số lượt, điểm cao nhất, điểm gần nhất)
	stats, _ := s.repo.AttemptStats(userID)
	for i := range exams {
		st := stats[exams[i].ExamID]
		exams[i].AttemptCount = st.Count
		exams[i].BestScore = st.Best
		exams[i].LastScore = st.Last
	}
	return exams, nil
}

func (s *FolderService) GetExamsPaged(folderID string, userID uint, limit, offset int) ([]repository.SavedExam, int64, error) {
	f, err := s.repo.FindByID(folderID)
	if err != nil || f.UserID != userID {
		return nil, 0, errors.New("Không tìm thấy thư mục")
	}
	exams, total, err := s.repo.FindExamsPaged(f.ID, userID, limit, offset)
	if err != nil {
		return nil, 0, err
	}
	stats, _ := s.repo.AttemptStats(userID)
	for i := range exams {
		st := stats[exams[i].ExamID]
		exams[i].AttemptCount = st.Count
		exams[i].BestScore = st.Best
		exams[i].LastScore = st.Last
	}
	return exams, total, nil
}

// SavedExamIDs: id đề đã lưu (badge "Đã lưu" ở ngân hàng đề)
func (s *FolderService) SavedExamIDs(userID uint) ([]uint, error) {
	return s.repo.SavedExamIDs(userID)
}

// SetNote: ghi chú cá nhân trên đề đã lưu
func (s *FolderService) SetNote(folderID string, examID, userID uint, note string) error {
	f, err := s.repo.FindByID(folderID)
	if err != nil || f.UserID != userID {
		return errors.New("Không tìm thấy thư mục")
	}
	return s.repo.UpdateNote(f.ID, examID, userID, note)
}

func (s *FolderService) AddExam(folderID string, examID uint, userID uint) error {
	f, err := s.repo.FindByID(folderID)
	if err != nil || f.UserID != userID {
		return errors.New("Không tìm thấy thư mục")
	}
	if s.repo.ExamExists(f.ID, examID, userID) {
		return nil // đã có, coi như thành công
	}
	return s.repo.AddExam(&entity.FolderExam{FolderID: f.ID, ExamID: examID, UserID: userID})
}

func (s *FolderService) RemoveExam(folderID string, examID uint, userID uint) error {
	return s.repo.RemoveExam(parseUint(folderID), examID, userID)
}

func parseUint(s string) uint {
	var n uint
	for _, c := range s {
		if c < '0' || c > '9' {
			return 0
		}
		n = n*10 + uint(c-'0')
	}
	return n
}
