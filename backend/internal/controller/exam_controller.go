package controller

import (
	"bytes"
	"fmt"
	"html/template"
	"net/http"
	"path/filepath"
	"strconv"
	"strings"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

var printExamTemplate = template.Must(template.New("exam-paper").Funcs(template.FuncMap{
	"add": func(left, right int) int { return left + right },
}).Parse(`<!doctype html>
<html lang="vi"><head><meta charset="utf-8"><title>{{.Exam.Title}}</title>
<style>@page{size:A4;margin:18mm}body{font-family:"Times New Roman",serif;color:#111;font-size:13pt;line-height:1.45}.center{text-align:center}.meta{display:flex;justify-content:space-between;margin:18px 0}.student{margin:20px 0 26px}.question{break-inside:avoid;margin:0 0 18px}.options{margin:6px 0 0 20px}.option{margin:3px 0}@media print{.no-print{display:none}}</style>
</head><body><div class="center"><strong>TRƯỜNG / KHOA: ................................................</strong><h2>ĐỀ KIỂM TRA HỌC PHẦN</h2><h3>{{.Exam.Title}}</h3><p>Thời gian làm bài: {{.Exam.Duration}} phút &nbsp; | &nbsp; Không sử dụng tài liệu (trừ khi giảng viên cho phép)</p></div>
<div class="meta"><span>Mã đề: {{.Exam.ID}}</span><span>Ngày in: {{.PrintedAt}}</span></div><div class="student">Họ và tên: ...............................................................................<br>Lớp / Mã sinh viên: ....................................................................</div>
{{range $index, $question := .Questions}}<section class="question"><strong>Câu {{add $index 1}}. {{$question.Content}}</strong><div class="options">{{range $question.Answers}}<div class="option">{{.Label}}. {{.Content}}</div>{{end}}</div></section>{{end}}
<p class="center"><em>--- HẾT ---</em></p><button class="no-print" onclick="window.print()">In đề</button></body></html>`))

type ExamController struct {
	svc       *service.ExamService
	importSvc *service.ImportService
	audit     *service.AuditService
}

func NewExamController(svc *service.ExamService, importSvc *service.ImportService, audit *service.AuditService) *ExamController {
	return &ExamController{svc: svc, importSvc: importSvc, audit: audit}
}

// Build: tạo đề từ NHIỀU nguồn rồi gộp lại:
//   - file thầy cô kéo vào (import vào ngân hàng, thuộc môn đã chọn)
//   - 1 đề có sẵn trong ngân hàng (lấy câu hỏi của đề đó)
//
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
			c.JSON(http.StatusBadRequest, gin.H{"error": "File qua lon (toi da 20MB)"})
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
		ids, err := ctl.svc.GetReusableQuestionIDs(fromExam, getUserID(c), getRole(c))
		if err != nil {
			c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
			return
		}
		add(ids)
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

	exam, err := ctl.svc.Create(input, getUserID(c), getRole(c))
	if err != nil {
		if err == service.ErrNotOwner {
			c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctl.audit.Log(getUserID(c), "exam.built", "exam", exam.ID, "Tao de thi tu kho cau hoi: "+exam.Title)
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
	exam, total, err := ctl.svc.Generate(in, getUserID(c), getRole(c))
	if err != nil {
		if err == service.ErrNotOwner {
			c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctl.audit.Log(getUserID(c), "exam.generated", "exam", exam.ID, "Sinh de thi theo ma tran: "+exam.Title)
	c.JSON(http.StatusCreated, gin.H{"exam": exam, "total": total})
}

func (ctl *ExamController) GetAll(c *gin.Context) {
	ctl.GetPaged(c)
}
func (ctl *ExamController) GetPaged(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	rows, total, err := ctl.svc.GetPaged(c.Query("keyword"), c.Query("subject_id"), getUserID(c), getRole(c), limit, (page-1)*limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": rows, "total": total, "page": page, "limit": limit})
}

// GetPublic: đề công khai cho khách (không cần đăng nhập)
func (ctl *ExamController) GetPublic(c *gin.Context) {
	ctl.GetPublicPaged(c)
}
func (ctl *ExamController) GetPublicPaged(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	rows, total, err := ctl.svc.GetPublicPaged(c.Query("subject_id"), limit, (page-1)*limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": rows, "total": total, "page": page, "limit": limit})
}

// GetBank: ngân hàng đề (đề đã phát hành) cho mọi người đăng nhập
func (ctl *ExamController) GetBank(c *gin.Context) {
	ctl.GetBankPaged(c)
}

func (ctl *ExamController) GetBankPaged(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	items, total, err := ctl.svc.GetBankPaged(c.Query("subject_id"), c.Query("keyword"), limit, (page-1)*limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": items, "total": total, "page": page, "limit": limit})
}

// Preview: xem đề + câu hỏi kèm đáp án (GV/Admin)
func (ctl *ExamController) Preview(c *gin.Context) {
	exam, questions, err := ctl.svc.Preview(c.Param("id"), getUserID(c), getRole(c))
	if err != nil {
		if err == service.ErrNotOwner {
			c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusNotFound, gin.H{"error": "Khong tim thay de thi"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"exam": exam, "questions": questions})
}

// Print renders a clean A4 student paper. The browser print dialog can print directly
// or save as PDF, avoiding platform-specific PDF font dependencies.
func (ctl *ExamController) Print(c *gin.Context) {
	exam, questions, err := ctl.svc.Preview(c.Param("id"), getUserID(c), getRole(c))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Khong tim thay de thi"})
		return
	}
	if getRole(c) != "Admin" && exam.CreatedBy != getUserID(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "Khong co quyen in de thi nay"})
		return
	}

	var output bytes.Buffer
	data := struct {
		Exam      interface{}
		Questions interface{}
		PrintedAt string
	}{
		Exam:      exam,
		Questions: questions,
		PrintedAt: fmt.Sprintf("%s", exam.CreatedAt.Format("02/01/2006")),
	}
	if err := printExamTemplate.Execute(&output, data); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Khong tao duoc ban in"})
		return
	}
	c.Data(http.StatusOK, "text/html; charset=utf-8", output.Bytes())
}

func (ctl *ExamController) GetDetail(c *gin.Context) {
	exam, qids, cids, err := ctl.svc.GetDetail(c.Param("id"), getUserID(c), getRole(c))
	if err != nil {
		if err == service.ErrNotOwner {
			c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
			return
		}
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
	exam, err := ctl.svc.Create(in, getUserID(c), getRole(c))
	if err != nil {
		if err == service.ErrNotOwner {
			c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctl.audit.Log(getUserID(c), "exam.created", "exam", exam.ID, "Tao de thi: "+exam.Title)
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
	ctl.audit.Log(getUserID(c), "exam.updated", "exam", exam.ID, "Cap nhat de thi: "+exam.Title)
	c.JSON(http.StatusOK, exam)
}

// Clone: nhân bản đề về cho GV đang đăng nhập
func (ctl *ExamController) Clone(c *gin.Context) {
	exam, err := ctl.svc.Clone(c.Param("id"), getUserID(c))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctl.audit.Log(getUserID(c), "exam.cloned", "exam", exam.ID, "Nhan ban de thi ve kho ca nhan: "+exam.Title)
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
	entityID, _ := strconv.Atoi(c.Param("id"))
	ctl.audit.Log(getUserID(c), "exam.deleted", "exam", uint(entityID), "Xoa de thi")
	c.JSON(http.StatusOK, gin.H{"message": "Da xoa"})
}
