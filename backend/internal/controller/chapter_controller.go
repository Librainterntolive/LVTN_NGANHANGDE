package controller

import (
	"net/http"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type ChapterController struct {
	svc *service.ChapterService
}

func NewChapterController(svc *service.ChapterService) *ChapterController {
	return &ChapterController{svc: svc}
}

// GetAll: GET /chapters?subject_id=xx
func (ctl *ChapterController) GetAll(c *gin.Context) {
	subjectID := c.Query("subject_id")
	if subjectID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Thieu subject_id"})
		return
	}
	chapters, err := ctl.svc.GetBySubject(subjectID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, chapters)
}

func (ctl *ChapterController) Create(c *gin.Context) {
	var in dto.ChapterInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	chapter, err := ctl.svc.Create(in)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, chapter)
}

func (ctl *ChapterController) Update(c *gin.Context) {
	var in dto.ChapterInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	chapter, err := ctl.svc.Update(c.Param("id"), in)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, chapter)
}

func (ctl *ChapterController) Delete(c *gin.Context) {
	if err := ctl.svc.Delete(c.Param("id")); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Da xoa chuong (cau hoi trong chuong tro ve chua phan chuong)"})
}
