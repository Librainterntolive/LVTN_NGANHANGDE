package controller

import (
	"net/http"

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
	data, _ := ctl.svc.GetMyExams(getUserID(c))
	c.JSON(http.StatusOK, data)
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
	data, _ := ctl.svc.GetMySubmissions(getUserID(c))
	c.JSON(http.StatusOK, data)
}
