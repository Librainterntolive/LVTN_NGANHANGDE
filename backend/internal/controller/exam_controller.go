package controller

import (
	"bytes"
	"html/template"
	"net/http"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

// Mau in de thi. Moi ma de la mot to giay rieng, ngat trang giua cac ma.
// Bang dap an chi duoc dung khi giang vien yeu cau ro (tham so key=1) va nam o
// tep rieng — tuyet doi khong in kem to de phat cho sinh vien.
var printExamTemplate = template.Must(template.New("exam-paper").Funcs(template.FuncMap{
	"add": func(left, right int) int { return left + right },
}).Parse(`<!doctype html>
<html lang="vi"><head><meta charset="utf-8"><title>{{.Exam.Title}}</title>
<style>@page{size:A4;margin:18mm}body{font-family:"Times New Roman",serif;color:#111;font-size:13pt;line-height:1.45}.center{text-align:center}.meta{display:flex;justify-content:space-between;margin:18px 0}.student{margin:20px 0 26px}.question{break-inside:avoid;margin:0 0 18px}.options{margin:6px 0 0 20px}.option{margin:3px 0}.paper{break-after:page}.paper:last-of-type{break-after:auto}.keyrow{font-family:"Courier New",monospace;font-size:12pt;margin:4px 0}.keybox{border:1px solid #111;padding:10px 14px;margin:10px 0}@media print{.no-print{display:none}}</style>
</head><body>
{{range $vi, $variant := .Variants}}<div class="paper">
<div class="center"><strong>TRƯỜNG / KHOA: ................................................</strong><h2>ĐỀ KIỂM TRA HỌC PHẦN</h2><h3>{{$.Exam.Title}}</h3><p>Thời gian làm bài: {{$.Exam.Duration}} phút &nbsp; | &nbsp; Không sử dụng tài liệu (trừ khi giảng viên cho phép)</p></div>
<div class="meta"><span>Mã đề: {{$variant.Code}}</span><span>Ngày in: {{$.PrintedAt}}</span></div><div class="student">Họ và tên: ...............................................................................<br>Lớp / Mã sinh viên: ....................................................................</div>
{{range $index, $question := $variant.Questions}}<section class="question"><strong>Câu {{add $index 1}}. {{$question.Content}}</strong><div class="options">{{range $question.Answers}}<div class="option">{{.Label}}. {{.Content}}</div>{{end}}</div></section>{{end}}
<p class="center"><em>--- HẾT ---</em></p>
</div>{{end}}
<button class="no-print" onclick="window.print()">In đề</button></body></html>`))

// Mau bang dap an, dung rieng cho giang vien cham bai.
var printAnswerKeyTemplate = template.Must(template.New("answer-key").Funcs(template.FuncMap{
	"add": func(left, right int) int { return left + right },
}).Parse(`<!doctype html>
<html lang="vi"><head><meta charset="utf-8"><title>Đáp án — {{.Exam.Title}}</title>
<style>@page{size:A4;margin:18mm}body{font-family:"Times New Roman",serif;color:#111;font-size:13pt;line-height:1.45}.center{text-align:center}.keybox{border:1px solid #111;padding:10px 14px;margin:14px 0;break-inside:avoid}.keyrow{font-family:"Courier New",monospace;font-size:12pt;margin:4px 0;word-spacing:6px}.warn{border:2px solid #111;padding:8px 12px;margin:12px 0;font-weight:bold}@media print{.no-print{display:none}}</style>
</head><body>
<div class="center"><h2>BẢNG ĐÁP ÁN</h2><h3>{{.Exam.Title}}</h3><p>Ngày in: {{.PrintedAt}}</p></div>
<p class="warn">TÀI LIỆU DÀNH RIÊNG CHO GIẢNG VIÊN — KHÔNG PHÁT CHO SINH VIÊN</p>
{{range $variant := .Variants}}<div class="keybox"><strong>Mã đề {{$variant.Code}}</strong>
{{range $i, $ans := $variant.AnswerKey}}<span class="keyrow">{{add $i 1}}.{{$ans}}</span>{{end}}
</div>{{end}}
<button class="no-print" onclick="window.print()">In bảng đáp án</button></body></html>`))

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
			c.JSON(http.StatusBadRequest, gin.H{"error": "File quá lớn (tối đa 20MB)"})
			return
		}
		ext := strings.ToLower(filepath.Ext(fh.Filename))
		if ext != ".csv" && ext != ".xlsx" {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Chỉ hỗ trợ file .csv hoặc .xlsx"})
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
		c.JSON(http.StatusBadRequest, gin.H{"error": "Không có câu hỏi nào (kiểm tra file hoặc đề đã chọn)", "file_errors": fileErrs})
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
		c.JSON(http.StatusBadRequest, gin.H{"error": "Thiếu tên đề thi"})
		return
	}

	exam, err := ctl.svc.Create(input, getUserID(c), getRole(c))
	if err != nil {
		if err == service.ErrNotOwner {
			c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
			return
		}
		// Các lỗi còn lại là vi phạm quy tắc nghiệp vụ do dữ liệu người dùng gửi
		// lên (câu hỏi chưa duyệt, lớp không có quyền giao...), không phải sự cố
		// máy chủ. Trả 500 sẽ khiến người dùng tưởng hệ thống hỏng.
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctl.audit.Log(getUserID(c), "exam.built", "exam", exam.ID, "Tạo đề thi từ kho câu hỏi: "+exam.Title)
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
	ctl.audit.Log(getUserID(c), "exam.generated", "exam", exam.ID, "Sinh đề thi theo ma trận: "+exam.Title)
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
	if limit < 1 || limit > 100 {
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
	if limit < 1 || limit > 100 {
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
	if limit < 1 || limit > 100 {
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
		c.JSON(http.StatusNotFound, gin.H{"error": "Không tìm thấy đề thi"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"exam": exam, "questions": questions})
}

// Print renders a clean A4 student paper. The browser print dialog can print directly
// or save as PDF, avoiding platform-specific PDF font dependencies.
func (ctl *ExamController) Print(c *gin.Context) {
	// variants: so ma de can in (mac dinh 1). key=1: xuat bang dap an rieng.
	variants, _ := strconv.Atoi(c.DefaultQuery("variants", "1"))
	wantKey := c.Query("key") == "1"

	exam, papers, err := ctl.svc.PrintVariants(c.Param("id"), getUserID(c), getRole(c), variants)
	if err != nil {
		if err == service.ErrNotOwner {
			c.JSON(http.StatusForbidden, gin.H{"error": "Không có quyền in đề thi này"})
			return
		}
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var output bytes.Buffer
	data := struct {
		Exam      interface{}
		Variants  interface{}
		PrintedAt string
	}{
		Exam:      exam,
		Variants:  papers,
		PrintedAt: time.Now().Format("02/01/2006"),
	}

	tpl := printExamTemplate
	if wantKey {
		tpl = printAnswerKeyTemplate
	}
	if err := tpl.Execute(&output, data); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Không tạo được bản in"})
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
		c.JSON(http.StatusNotFound, gin.H{"error": "Không tìm thấy đề thi"})
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
	ctl.audit.Log(getUserID(c), "exam.created", "exam", exam.ID, "Tạo đề thi: "+exam.Title)
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
		c.JSON(http.StatusNotFound, gin.H{"error": "Không tìm thấy đề thi"})
		return
	}
	ctl.audit.Log(getUserID(c), "exam.updated", "exam", exam.ID, "Cập nhật đề thi: "+exam.Title)
	c.JSON(http.StatusOK, exam)
}

// Clone: nhân bản đề về cho GV đang đăng nhập
func (ctl *ExamController) Clone(c *gin.Context) {
	exam, err := ctl.svc.Clone(c.Param("id"), getUserID(c))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctl.audit.Log(getUserID(c), "exam.cloned", "exam", exam.ID, "Nhân bản đề thi về kho cá nhân: "+exam.Title)
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
	ctl.audit.Log(getUserID(c), "exam.deleted", "exam", uint(entityID), "Xóa đề thi")
	c.JSON(http.StatusOK, gin.H{"message": "Đã xóa"})
}
