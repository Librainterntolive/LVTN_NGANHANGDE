package controller

import (
	"net/http"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type ClassController struct {
	svc *service.ClassService
}

func NewClassController(svc *service.ClassService) *ClassController {
	return &ClassController{svc: svc}
}

func (ctl *ClassController) GetAll(c *gin.Context) {
	role, _ := c.Get("role")
	roleStr, _ := role.(string)
	data, _ := ctl.svc.GetAll(roleStr, getUserID(c))
	c.JSON(http.StatusOK, data)
}

// Assignable: lớp có thể giao đề (của mình + lớp dùng chung)
func (ctl *ClassController) Assignable(c *gin.Context) {
	role, _ := c.Get("role")
	roleStr, _ := role.(string)
	data, _ := ctl.svc.GetAssignable(roleStr, getUserID(c))
	c.JSON(http.StatusOK, data)
}

// SV tự tham gia lớp bằng mã
func (ctl *ClassController) Join(c *gin.Context) {
	var in dto.JoinClassInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	class, err := ctl.svc.JoinByCode(in.Code, getUserID(c))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Da tham gia lop", "class": class})
}

// SV xem các lớp mình đã tham gia
func (ctl *ClassController) MyClasses(c *gin.Context) {
	data, _ := ctl.svc.GetMyClasses(getUserID(c))
	c.JSON(http.StatusOK, data)
}

func (ctl *ClassController) Create(c *gin.Context) {
	var in dto.ClassInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	cl, _ := ctl.svc.Create(in, getUserID(c))
	c.JSON(http.StatusCreated, cl)
}

func (ctl *ClassController) Update(c *gin.Context) {
	var in dto.ClassInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	cl, err := ctl.svc.Update(c.Param("id"), in)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Khong tim thay lop"})
		return
	}
	c.JSON(http.StatusOK, cl)
}

func (ctl *ClassController) Delete(c *gin.Context) {
	ctl.svc.Delete(c.Param("id"))
	c.JSON(http.StatusOK, gin.H{"message": "Da xoa"})
}

func (ctl *ClassController) GetStudents(c *gin.Context) {
	data, _ := ctl.svc.GetStudents(c.Param("id"))
	c.JSON(http.StatusOK, data)
}

// GetExams: đề thi đã giao cho lớp
func (ctl *ClassController) GetExams(c *gin.Context) {
	data, _ := ctl.svc.GetExams(c.Param("id"))
	c.JSON(http.StatusOK, data)
}

func (ctl *ClassController) AddStudent(c *gin.Context) {
	var in dto.AddStudentInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := ctl.svc.AddStudent(c.Param("id"), in.StudentID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Sinh vien da co trong lop hoac khong hop le"})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"message": "Da them"})
}

func (ctl *ClassController) RemoveStudent(c *gin.Context) {
	ctl.svc.RemoveStudent(c.Param("id"), c.Param("studentId"))
	c.JSON(http.StatusOK, gin.H{"message": "Da xoa khoi lop"})
}
