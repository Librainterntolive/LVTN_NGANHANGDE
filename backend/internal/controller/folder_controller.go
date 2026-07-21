package controller

import (
	"net/http"
	"strconv"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type FolderController struct {
	svc *service.FolderService
}

func NewFolderController(svc *service.FolderService) *FolderController {
	return &FolderController{svc: svc}
}

func (ctl *FolderController) GetMine(c *gin.Context) {
	data, _ := ctl.svc.GetMine(getUserID(c))
	c.JSON(http.StatusOK, data)
}

func (ctl *FolderController) Create(c *gin.Context) {
	var in dto.FolderInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	f, err := ctl.svc.Create(in.Name, in.ParentID, getUserID(c))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, f)
}

func (ctl *FolderController) Rename(c *gin.Context) {
	var in dto.RenameInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	f, err := ctl.svc.Rename(c.Param("id"), in.Name, getUserID(c))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, f)
}

func (ctl *FolderController) Delete(c *gin.Context) {
	if err := ctl.svc.Delete(c.Param("id"), getUserID(c)); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Da xoa"})
}

func (ctl *FolderController) GetExams(c *gin.Context) {
	data, err := ctl.svc.GetExams(c.Param("id"), getUserID(c))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, data)
}

func (ctl *FolderController) AddExam(c *gin.Context) {
	var in dto.SaveExamInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := ctl.svc.AddExam(c.Param("id"), in.ExamID, getUserID(c)); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Da luu vao kho"})
}

func (ctl *FolderController) RemoveExam(c *gin.Context) {
	examID, _ := strconv.Atoi(c.Param("examId"))
	ctl.svc.RemoveExam(c.Param("id"), uint(examID), getUserID(c))
	c.JSON(http.StatusOK, gin.H{"message": "Da xoa khoi kho"})
}

// SavedExamIDs: id các đề đã lưu ở bất kỳ thư mục nào (badge "Đã lưu")
func (ctl *FolderController) SavedExamIDs(c *gin.Context) {
	ids, _ := ctl.svc.SavedExamIDs(getUserID(c))
	c.JSON(http.StatusOK, ids)
}

// SetNote: ghi chú cá nhân trên đề đã lưu
func (ctl *FolderController) SetNote(c *gin.Context) {
	var in dto.NoteInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	examID, _ := strconv.Atoi(c.Param("examId"))
	if err := ctl.svc.SetNote(c.Param("id"), uint(examID), getUserID(c), in.Note); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Da luu ghi chu"})
}
