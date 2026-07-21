package controller

import (
	"net/http"
	"strconv"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/repository"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type QuestionController struct {
	svc *service.QuestionService
}

func NewQuestionController(svc *service.QuestionService) *QuestionController {
	return &QuestionController{svc: svc}
}

func (ctl *QuestionController) GetAll(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	f := repository.QuestionFilter{
		SubjectID: c.Query("subject_id"),
		Keyword:   c.Query("keyword"),
		OwnerMode: c.Query("owner"),     // ""/me/others
		OwnerID:   getUserID(c),
		ChapterID:  c.Query("chapter_id"), // ""/none/id chương
		Status:     c.Query("status"),     // ""/draft/active
		Difficulty: c.Query("difficulty"), // ""/easy/medium/hard
	}
	items, total, _ := ctl.svc.GetPaged(f, page, limit)
	c.JSON(http.StatusOK, gin.H{"items": items, "total": total, "page": page, "limit": limit})
}

func (ctl *QuestionController) GetByID(c *gin.Context) {
	q, err := ctl.svc.GetByID(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Khong tim thay cau hoi"})
		return
	}
	c.JSON(http.StatusOK, q)
}

func (ctl *QuestionController) Create(c *gin.Context) {
	var in dto.QuestionInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	q, err := ctl.svc.Create(in, getUserID(c))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, q)
}

func (ctl *QuestionController) Update(c *gin.Context) {
	var in dto.QuestionInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	q, err := ctl.svc.Update(c.Param("id"), in)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, q)
}

func (ctl *QuestionController) Delete(c *gin.Context) {
	if err := ctl.svc.Delete(c.Param("id")); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Da xoa"})
}
