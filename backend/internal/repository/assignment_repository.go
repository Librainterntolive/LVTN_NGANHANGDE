package repository

import (
	"quiz-backend/internal/entity"
	"time"

	"gorm.io/gorm"
)

type AssignmentRepository struct{ db *gorm.DB }

type ClassSubmissionStat struct {
	StudentID          uint    `json:"student_id"`
	FullName           string  `json:"full_name"`
	Username           string  `json:"username"`
	Submitted          int64   `json:"submitted"`
	Late               int64   `json:"late"`
	AverageSubmitted   float64 `json:"average_submitted"`
	AverageWithMissing float64 `json:"average_with_missing"`
}

type ClassSubmissionSummary struct {
	AverageSubmitted   float64 `json:"average_submitted"`
	AverageWithMissing float64 `json:"average_with_missing"`
	SubmissionRate     float64 `json:"submission_rate"`
}

func NewAssignmentRepository(db *gorm.DB) *AssignmentRepository { return &AssignmentRepository{db: db} }

func (r *AssignmentRepository) Create(item *entity.Assignment) error { return r.db.Create(item).Error }
func (r *AssignmentRepository) Save(item *entity.Assignment) error   { return r.db.Save(item).Error }
func (r *AssignmentRepository) Delete(id uint) error {
	return r.db.Delete(&entity.Assignment{}, id).Error
}
func (r *AssignmentRepository) FindByID(id uint) (*entity.Assignment, error) {
	var item entity.Assignment
	err := r.db.First(&item, id).Error
	return &item, err
}
func (r *AssignmentRepository) ListClass(classID uint, limit, offset int) ([]entity.Assignment, int64, error) {
	var items []entity.Assignment
	var total int64
	query := r.db.Model(&entity.Assignment{}).Where("class_id = ?", classID)
	err := query.Count(&total).Error
	if err == nil {
		err = query.Order("due_at desc").Limit(limit).Offset(offset).Find(&items).Error
	}
	return items, total, err
}
func (r *AssignmentRepository) ListClassForStudent(classID, studentID uint, limit, offset int) ([]entity.Assignment, int64, error) {
	items, total, err := r.ListClass(classID, limit, offset)
	if err != nil || len(items) == 0 {
		return items, total, err
	}
	assignmentIDs := make([]uint, 0, len(items))
	for _, item := range items {
		assignmentIDs = append(assignmentIDs, item.ID)
	}
	var submissions []entity.AssignmentSubmission
	if err := r.db.Where("student_id = ? AND assignment_id IN ?", studentID, assignmentIDs).Find(&submissions).Error; err != nil {
		return nil, 0, err
	}
	byAssignment := make(map[uint]*entity.AssignmentSubmission, len(submissions))
	for index := range submissions {
		byAssignment[submissions[index].AssignmentID] = &submissions[index]
	}
	for index := range items {
		items[index].MySubmission = byAssignment[items[index].ID]
	}
	return items, total, nil
}
func (r *AssignmentRepository) CreateSession(item *entity.UploadSession) error {
	return r.db.Create(item).Error
}
func (r *AssignmentRepository) FindSession(id string) (*entity.UploadSession, error) {
	var item entity.UploadSession
	err := r.db.First(&item, "id = ?", id).Error
	return &item, err
}
func (r *AssignmentRepository) DeleteSession(id string) error {
	return r.db.Delete(&entity.UploadSession{}, "id = ?", id).Error
}
func (r *AssignmentRepository) ExpiredSessions(before time.Time) ([]entity.UploadSession, error) {
	var sessions []entity.UploadSession
	err := r.db.Where("expires_at < ?", before).Find(&sessions).Error
	return sessions, err
}
func (r *AssignmentRepository) CountActiveSessions(studentID uint, now time.Time) (int64, error) {
	var count int64
	err := r.db.Model(&entity.UploadSession{}).Where("student_id = ? AND expires_at >= ?", studentID, now).Count(&count).Error
	return count, err
}
func (r *AssignmentRepository) FindSubmission(assignmentID, studentID uint) (*entity.AssignmentSubmission, error) {
	var item entity.AssignmentSubmission
	err := r.db.Where("assignment_id = ? AND student_id = ?", assignmentID, studentID).First(&item).Error
	return &item, err
}
func (r *AssignmentRepository) FindSubmissionByID(id uint) (*entity.AssignmentSubmission, error) {
	var item entity.AssignmentSubmission
	err := r.db.First(&item, id).Error
	return &item, err
}
func (r *AssignmentRepository) SaveSubmission(item *entity.AssignmentSubmission) error {
	return r.db.Save(item).Error
}
func (r *AssignmentRepository) ListSubmissions(assignmentID uint) ([]entity.AssignmentSubmission, error) {
	var items []entity.AssignmentSubmission
	err := r.submissionQuery(assignmentID).Order("assignment_submissions.submitted_at desc").Scan(&items).Error
	return items, err
}

func (r *AssignmentRepository) ListSubmissionsPaged(assignmentID uint, limit, offset int) ([]entity.AssignmentSubmission, int64, error) {
	var items []entity.AssignmentSubmission
	query := r.db.Model(&entity.AssignmentSubmission{}).Where("assignment_id = ?", assignmentID)
	var total int64
	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}
	err := r.submissionQuery(assignmentID).Order("assignment_submissions.submitted_at desc").Limit(limit).Offset(offset).Scan(&items).Error
	return items, total, err
}

func (r *AssignmentRepository) submissionQuery(assignmentID uint) *gorm.DB {
	return r.db.Table("assignment_submissions").
		Select("assignment_submissions.*, users.full_name as student_name, users.username as student_username").
		Joins("JOIN users ON users.id = assignment_submissions.student_id").
		Where("assignment_submissions.assignment_id = ?", assignmentID)
}
func (r *AssignmentRepository) ClassStats(classID uint) ([]ClassSubmissionStat, error) {
	var rows []ClassSubmissionStat
	err := r.db.Raw(`SELECT u.id student_id,u.full_name,u.username,COUNT(s.id) submitted,COALESCE(SUM(s.status='late'),0) late,COALESCE(AVG(s.score),0) average_submitted,COALESCE(SUM(COALESCE(s.score,0))/NULLIF((SELECT COUNT(*) FROM assignments a WHERE a.class_id=?),0),0) average_with_missing FROM class_students cs JOIN users u ON u.id=cs.student_id LEFT JOIN assignments a ON a.class_id=cs.class_id LEFT JOIN assignment_submissions s ON s.assignment_id=a.id AND s.student_id=u.id WHERE cs.class_id=? GROUP BY u.id,u.full_name,u.username`, classID, classID).Scan(&rows).Error
	return rows, err
}

func (r *AssignmentRepository) ClassStatsPaged(classID uint, limit, offset int) ([]ClassSubmissionStat, int64, ClassSubmissionSummary, error) {
	var rows []ClassSubmissionStat
	var total int64
	var summary ClassSubmissionSummary
	if err := r.db.Model(&entity.ClassStudent{}).Where("class_id = ?", classID).Count(&total).Error; err != nil {
		return nil, 0, summary, err
	}
	base := `SELECT u.id student_id,u.full_name,u.username,COUNT(s.id) submitted,COALESCE(SUM(s.status='late'),0) late,COALESCE(AVG(s.score),0) average_submitted,COALESCE(SUM(COALESCE(s.score,0))/NULLIF((SELECT COUNT(*) FROM assignments a WHERE a.class_id=?),0),0) average_with_missing FROM class_students cs JOIN users u ON u.id=cs.student_id LEFT JOIN assignments a ON a.class_id=cs.class_id LEFT JOIN assignment_submissions s ON s.assignment_id=a.id AND s.student_id=u.id WHERE cs.class_id=? GROUP BY u.id,u.full_name,u.username`
	if err := r.db.Raw(base+" ORDER BY u.full_name ASC, u.username ASC LIMIT ? OFFSET ?", classID, classID, limit, offset).Scan(&rows).Error; err != nil {
		return nil, 0, summary, err
	}
	if err := r.db.Raw("SELECT COALESCE(AVG(average_submitted),0) average_submitted, COALESCE(AVG(average_with_missing),0) average_with_missing FROM ("+base+") class_stat_rows", classID, classID).Scan(&summary).Error; err != nil {
		return nil, 0, summary, err
	}
	var assignmentCount, submissionCount int64
	r.db.Model(&entity.Assignment{}).Where("class_id = ?", classID).Count(&assignmentCount)
	if assignmentCount > 0 && total > 0 {
		r.db.Table("assignment_submissions s").Joins("JOIN assignments a ON a.id = s.assignment_id").Where("a.class_id = ?", classID).Count(&submissionCount)
		summary.SubmissionRate = float64(submissionCount) * 100 / float64(total*assignmentCount)
	}
	return rows, total, summary, nil
}
