package controller

import (
	"net/http"
	"strconv"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type SubmissionController struct {
	svc *service.SubmissionService
}

func NewSubmissionController(svc *service.SubmissionService) *SubmissionController {
	return &SubmissionController{svc: svc}
}

func (ctl *SubmissionController) GetMyExams(c *gin.Context) {
	ctl.GetMyExamsPaged(c)
}

func (ctl *SubmissionController) GetMyExamsPaged(c *gin.Context) {
	page, limit := pagination(c)
	items, total, err := ctl.svc.GetMyExamsPaged(getUserID(c), limit, (page-1)*limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": items, "total": total, "page": page, "limit": limit})
}

func (ctl *SubmissionController) Take(c *gin.Context) {
	exam, questions, session, err := ctl.svc.Take(c.Param("id"), getUserIDPtr(c))
	if err != nil {
		c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
		return
	}
	res := gin.H{
		"exam":      gin.H{"id": exam.ID, "title": exam.Title, "duration": exam.Duration},
		"questions": questions,
	}
	// Khách làm thử không có phiên -> không có đồng hồ do server giữ
	if session != nil {
		res["submission_id"] = session.SubmissionID
		res["remaining_seconds"] = session.RemainingSeconds
	} else {
		res["is_guest_trial"] = true
		res["question_limit"] = 20
	}
	c.JSON(http.StatusOK, res)
}

func (ctl *SubmissionController) Submit(c *gin.Context) {
	var in dto.SubmitInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	res, err := ctl.svc.Submit(c.Param("id"), in, getUserIDPtr(c))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, res)
}

func (ctl *SubmissionController) GetMySubmissions(c *gin.Context) {
	ctl.GetMySubmissionsPaged(c)
}

func (ctl *SubmissionController) GetMySubmissionsPaged(c *gin.Context) {
	page, limit := pagination(c)
	items, total, err := ctl.svc.GetMySubmissionsPaged(getUserID(c), limit, (page-1)*limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": items, "total": total, "page": page, "limit": limit})
}

func (ctl *SubmissionController) GetResult(c *gin.Context) {
	submissionID, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil || submissionID == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "ma bai lam khong hop le"})
		return
	}
	result, err := ctl.svc.GetSubmissionResult(uint(submissionID), getUserID(c))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, result)
}

func pagination(c *gin.Context) (int, int) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	return page, limit
}
