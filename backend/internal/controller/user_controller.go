package controller

import (
	"net/http"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type UserController struct {
	svc *service.UserService
}

func NewUserController(svc *service.UserService) *UserController {
	return &UserController{svc: svc}
}

func (ctl *UserController) GetAll(c *gin.Context) {
	data, _ := ctl.svc.GetAll()
	c.JSON(http.StatusOK, data)
}

func (ctl *UserController) Create(c *gin.Context) {
	var in dto.UserInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	u, err := ctl.svc.Create(in)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, u)
}

func (ctl *UserController) Update(c *gin.Context) {
	var in dto.UserInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	u, err := ctl.svc.Update(c.Param("id"), in)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Khong tim thay nguoi dung"})
		return
	}
	c.JSON(http.StatusOK, u)
}

func (ctl *UserController) Delete(c *gin.Context) {
	ctl.svc.Delete(c.Param("id"))
	c.JSON(http.StatusOK, gin.H{"message": "Da xoa"})
}
