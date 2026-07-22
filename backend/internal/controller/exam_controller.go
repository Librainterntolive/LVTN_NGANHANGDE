package controller

import (
	"net/http"
	"path/filepath"
	"strconv"
	"strings"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type ExamController struct {
	svc       *service.ExamService
	importSvc *service.ImportService
}

func NewExamController(svc *service.ExamService, importSvc *service.ImportService) *ExamController {
	return &ExamController{svc: svc, importSvc: importSvc}
}

// Build: tạo đề từ NHIỀU nguồn rồi gộp lại:
//   - file thầy cô kéo vào (import vào ngân hàng, thuộc môn đã chọn)
//   - 1 đề có sẵn trong ngân hàng (lấy câu hỏi của đề đó)
// Nhận multipart/form-data.
func (ctl *ExamController) Build(c *gin.Context) {
	subjectID, _ := strconv.Atoi(c.PostForm("subject_id"))
	duration, _ := strconv.Atoi(c.PostForm("duration"))
	passScore, _ := strconv.ParseFloat(c.DefaultPostForm("pass_score", "0"), 64)
	shuffle := c.PostForm("shuffle") == "true"
	shuffleAns := c.PostForm("shuffle_answers") == "true"
	maxAttempts, _ := strconv.Atoi(c.DefaultPostForm("max_attempts", "0"))

	var questionIDs []uint
	seen := map[uint]bool{}
	add := func(ids []uint) {
		for _, id := range ids {
			if id != 0 && !seen[id] {
				seen[id] = true
				questionIDs = append(questionIDs, id)
			}
		}
	}

	// Nguồn 1: file (nếu có)
	var fileErrs []string
	if fh, err := c.FormFile("file"); err == nil {
		if fh.Size > maxImportSize {
			c.JSON(http.StatusBadRequest, gin.H{"error": "File qua lon (toi da 50MB)"})
			return
		}
		ext := strings.ToLower(filepath.Ext(fh.Filename))
		if ext != ".csv" && ext != ".xlsx" {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Chi ho tro file .csv hoac .xlsx"})
			return
		}
		f, _ := fh.Open()
		defer f.Close()
		ids, _, errs := ctl.importSvc.Import(f, ext, getUserID(c), uint(subjectID))
		fileErrs = errs
		add(ids)
	}

	// Nguồn 2: đề có sẵn trong ngân hàng (nếu chọn)
	if fromExam := c.PostForm("from_exam_id"); fromExam != "" && fromExam != "0" {
		add(ctl.svc.GetQuestionIDs(fromExam))
	}

	// Nguồn 3: câu hỏi chọn trực tiếp từ ngân hàng câu hỏi ("1,2,3")
	var picked []uint
	for _, p := range strings.Split(c.PostForm("question_ids"), ",") {
		if id, err := strconv.Atoi(strings.TrimSpace(p)); err == nil && id > 0 {
			picked = append(picked, uint(id))
		}
	}
	add(picked)

	if len(questionIDs) == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Khong co cau hoi nao (kiem tra file hoac de da chon)", "file_errors": fileErrs})
		return
	}

	// class_ids: "1,2,3"
	var classIDs []uint
	for _, p := range strings.Split(c.PostForm("class_ids"), ",") {
		if id, err := strconv.Atoi(strings.TrimSpace(p)); err == nil && id > 0 {
			classIDs = append(classIDs, uint(id))
		}
	}

	input := dto.ExamInput{
		SubjectID:      uint(subjectID),
		Title:          c.PostForm("title"),
		Description:    c.PostForm("description"),
		Duration:       duration,
		PassScore:      passScore,
		Shuffle:        shuffle,
		ShuffleAnswers: shuffleAns,
		ShuffleMode:    c.DefaultPostForm("shuffle_mode", "per_student"),
		AccessType:     c.DefaultPostForm("access_type", "private"),
		MaxAttempts:    maxAttempts,
		Status:         c.DefaultPostForm("status", "draft"),
		QuestionIDs:    questionIDs,
		ClassIDs:       classIDs,
	}
	if input.Title == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Thieu ten de thi"})
		return
	}

	exam, err := ctl.svc.Create(input, getUserID(c))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{
		"exam":        exam,
		"total":       len(questionIDs),
		"file_errors": fileErrs,
	})
}

// Generate: sinh đề tự động theo ma trận chương × độ khó (JSON)
func (ctl *ExamController) Generate(c *gin.Context) {
	var in dto.GenerateExamInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	exam, total, err := ctl.svc.Generate(in, getUserID(c))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"exam": exam, "total": total})
}

func (ctl *ExamController) GetAll(c *gin.Context) {
	data, _ := ctl.svc.GetAll(c.Query("keyword"), c.Query("subject_id"))
	c.JSON(http.StatusOK, data)
}

// GetPublic: đề công khai cho khách (không cần đăng nhập)
func (ctl *ExamController) GetPublic(c *gin.Context) {
	data, _ := ctl.svc.GetPublic()
	c.JSON(http.StatusOK, data)
}

// GetBank: ngân hàng đề (đề đã phát hành) cho mọi người đăng nhập
func (ctl *ExamController) GetBank(c *gin.Context) {
	data, _ := ctl.svc.GetBank()
	c.JSON(http.StatusOK, data)
}

// Preview: xem đề + câu hỏi kèm đáp án (GV/Admin)
func (ctl *ExamController) Preview(c *gin.Context) {
	exam, questions, err := ctl.svc.Preview(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Khong tim thay de thi"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"exam": exam, "questions": questions})
}

func (ctl *ExamController) GetDetail(c *gin.Context) {
	exam, qids, cids, err := ctl.svc.GetDetail(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Khong tim thay de thi"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"exam": exam, "question_ids": qids, "class_ids": cids})
}

func (ctl *ExamController) Create(c *gin.Context) {
	var in dto.ExamInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	exam, err := ctl.svc.Create(in, getUserID(c))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, exam)
}

func (ctl *ExamController) Update(c *gin.Context) {
	var in dto.ExamInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	exam, err := ctl.svc.Update(c.Param("id"), in, getUserID(c), getRole(c))
	if err == service.ErrNotOwner {
		c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
		return
	}
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Khong tim thay de thi"})
		return
	}
	c.JSON(http.StatusOK, exam)
}

// Clone: nhân bản đề về cho GV đang đăng nhập
func (ctl *ExamController) Clone(c *gin.Context) {
	exam, err := ctl.svc.Clone(c.Param("id"), getUserID(c))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, exam)
}

func (ctl *ExamController) Delete(c *gin.Context) {
	if err := ctl.svc.Delete(c.Param("id"), getUserID(c), getRole(c)); err != nil {
		status := http.StatusBadRequest
		if err == service.ErrNotOwner {
			status = http.StatusForbidden
		}
		c.JSON(status, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Da xoa"})
}
