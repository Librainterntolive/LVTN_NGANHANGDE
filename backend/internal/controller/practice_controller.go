package controller

import (
	"net/http"
	"strconv"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type PracticeController struct {
	svc *service.PracticeService
}

func NewPracticeController(svc *service.PracticeService) *PracticeController {
	return &PracticeController{svc: svc}
}

// Notebook: GET /practice/wrong-questions - sổ tay câu sai
func (ctl *PracticeController) Notebook(c *gin.Context) {
	ctl.NotebookPaged(c)
}

func (ctl *PracticeController) NotebookPaged(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 100 {
		limit = 12
	}
	items, total, err := ctl.svc.GetNotebookPaged(getUserID(c), limit, (page-1)*limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": items, "total": total, "page": page, "limit": limit})
}

// Take: GET /practice/wrong-questions/take - bộ câu để luyện lại (ẩn đáp án đúng)
func (ctl *PracticeController) Take(c *gin.Context) {
	data, err := ctl.svc.GetPracticeSet(getUserID(c))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, data)
}

// Submit: POST /practice/wrong-questions/submit - chấm + cập nhật sổ tay
func (ctl *PracticeController) Submit(c *gin.Context) {
	var in dto.SubmitInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	results, err := ctl.svc.SubmitPractice(getUserID(c), in.Answers)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"results": results})
}

// MyStats: GET /my-stats - thống kê góc học tập
func (ctl *PracticeController) MyStats(c *gin.Context) {
	data, err := ctl.svc.GetMyStats(getUserID(c))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, data)
}
