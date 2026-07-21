package controller

import (
	"net/http"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type SubjectController struct {
	svc *service.SubjectService
}

func NewSubjectController(svc *service.SubjectService) *SubjectController {
	return &SubjectController{svc: svc}
}

func (ctl *SubjectController) GetAll(c *gin.Context) {
	data, _ := ctl.svc.GetAll()
	c.JSON(http.StatusOK, data)
}

func (ctl *SubjectController) GetByID(c *gin.Context) {
	s, err := ctl.svc.GetByID(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Khong tim thay mon hoc"})
		return
	}
	c.JSON(http.StatusOK, s)
}

func (ctl *SubjectController) Create(c *gin.Context) {
	var in dto.SubjectInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	s, _ := ctl.svc.Create(in)
	c.JSON(http.StatusCreated, s)
}

func (ctl *SubjectController) Update(c *gin.Context) {
	var in dto.SubjectInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	s, err := ctl.svc.Update(c.Param("id"), in)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Khong tim thay mon hoc"})
		return
	}
	c.JSON(http.StatusOK, s)
}

func (ctl *SubjectController) Delete(c *gin.Context) {
	if err := ctl.svc.Delete(c.Param("id")); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Da xoa"})
}
