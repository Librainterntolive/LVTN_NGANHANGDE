package repository

import (
	"quiz-backend/internal/entity"

	"gorm.io/gorm"
)

type FolderRepository struct {
	db *gorm.DB
}

func NewFolderRepository(db *gorm.DB) *FolderRepository {
	return &FolderRepository{db: db}
}

// ----- Thư mục -----
func (r *FolderRepository) FindByUser(userID uint) ([]entity.Folder, error) {
	var folders []entity.Folder
	err := r.db.Where("user_id = ?", userID).Order("name asc").Find(&folders).Error
	return folders, err
}

func (r *FolderRepository) FindByID(id string) (*entity.Folder, error) {
	var f entity.Folder
	err := r.db.First(&f, id).Error
	return &f, err
}

func (r *FolderRepository) Create(f *entity.Folder) error { return r.db.Create(f).Error }
func (r *FolderRepository) Update(f *entity.Folder) error { return r.db.Save(f).Error }

// các thư mục con trực tiếp
func (r *FolderRepository) FindChildren(parentID uint) ([]entity.Folder, error) {
	var folders []entity.Folder
	err := r.db.Where("parent_id = ?", parentID).Find(&folders).Error
	return folders, err
}

// xóa 1 thư mục + đề đã lưu trong đó
func (r *FolderRepository) Delete(id uint) error {
	r.db.Where("folder_id = ?", id).Delete(&entity.FolderExam{})
	return r.db.Delete(&entity.Folder{}, id).Error
}

// ----- Đề trong thư mục -----
type SavedExam struct {
	ID         uint   `json:"id"`          // id bản ghi folder_exam
	ExamID     uint   `json:"exam_id"`
	Title      string `json:"title"`
	SubjectID  uint   `json:"subject_id"`
	Status     string `json:"status"`
	AccessType string `json:"access_type"`
	Duration   int    `json:"duration"`
	Note       string `json:"note"` // ghi chú cá nhân
	// tiến độ làm bài của người dùng (điền sau khi truy vấn)
	AttemptCount int64   `gorm:"-" json:"attempt_count"`
	BestScore    float64 `gorm:"-" json:"best_score"`
	LastScore    float64 `gorm:"-" json:"last_score"`
}

func (r *FolderRepository) FindExams(folderID, userID uint) ([]SavedExam, error) {
	var rows []SavedExam
	err := r.db.Table("folder_exams fe").
		Select("fe.id, fe.exam_id, fe.note, e.title, e.subject_id, e.status, e.access_type, e.duration").
		Joins("JOIN exams e ON e.id = fe.exam_id").
		Where("fe.folder_id = ? AND fe.user_id = ?", folderID, userID).
		Order("fe.id desc").Scan(&rows).Error
	return rows, err
}

// ExamAttemptStat: tiến độ làm 1 đề của 1 người dùng
type ExamAttemptStat struct {
	Count int64
	Best  float64
	Last  float64
}

// AttemptStats: gom tiến độ làm bài theo exam_id của 1 người dùng (bỏ lượt đang làm dở)
func (r *FolderRepository) AttemptStats(userID uint) (map[uint]ExamAttemptStat, error) {
	var rows []struct {
		ExamID     uint
		TotalScore float64
	}
	err := r.db.Table("submissions").
		Select("exam_id, total_score").
		Where("user_id = ? AND status <> ?", userID, "in_progress").
		Order("id asc").Scan(&rows).Error
	m := map[uint]ExamAttemptStat{}
	for _, row := range rows {
		st := m[row.ExamID]
		st.Count++
		if row.TotalScore > st.Best {
			st.Best = row.TotalScore
		}
		st.Last = row.TotalScore // duyệt theo id tăng dần -> phần tử cuối là lần gần nhất
		m[row.ExamID] = st
	}
	return m, err
}

// SavedExamIDs: id các đề người dùng đã lưu (ở bất kỳ thư mục nào) - cho badge "Đã lưu"
func (r *FolderRepository) SavedExamIDs(userID uint) ([]uint, error) {
	var ids []uint
	err := r.db.Model(&entity.FolderExam{}).Where("user_id = ?", userID).
		Distinct().Pluck("exam_id", &ids).Error
	return ids, err
}

// UpdateNote: cập nhật ghi chú cá nhân trên 1 đề đã lưu
func (r *FolderRepository) UpdateNote(folderID, examID, userID uint, note string) error {
	return r.db.Model(&entity.FolderExam{}).
		Where("folder_id = ? AND exam_id = ? AND user_id = ?", folderID, examID, userID).
		Update("note", note).Error
}

func (r *FolderRepository) ExamExists(folderID, examID, userID uint) bool {
	var n int64
	r.db.Model(&entity.FolderExam{}).
		Where("folder_id = ? AND exam_id = ? AND user_id = ?", folderID, examID, userID).Count(&n)
	return n > 0
}

func (r *FolderRepository) AddExam(fe *entity.FolderExam) error { return r.db.Create(fe).Error }

func (r *FolderRepository) RemoveExam(folderID, examID, userID uint) error {
	return r.db.Where("folder_id = ? AND exam_id = ? AND user_id = ?", folderID, examID, userID).
		Delete(&entity.FolderExam{}).Error
}
