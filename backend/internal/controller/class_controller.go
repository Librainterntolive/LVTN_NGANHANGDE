package controller

import (
	"net/http"
	"strconv"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type ClassController struct {
	svc   *service.ClassService
	audit *service.AuditService
}

func NewClassController(svc *service.ClassService, audit *service.AuditService) *ClassController {
	return &ClassController{svc: svc, audit: audit}
}

func (ctl *ClassController) GetAll(c *gin.Context) {
	ctl.GetPaged(c)
}
func (ctl *ClassController) GetPaged(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	rows, total, err := ctl.svc.GetPaged(getRole(c), getUserID(c), limit, (page-1)*limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": rows, "total": total, "page": page, "limit": limit})
}

func (ctl *ClassController) GetOne(c *gin.Context) {
	item, err := ctl.svc.GetOne(c.Param("id"), getUserID(c), getRole(c))
	if err != nil {
		if err == service.ErrNotOwner {
			c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, item)
}

// Assignable: lớp có thể giao đề (của mình + lớp dùng chung)
func (ctl *ClassController) Assignable(c *gin.Context) {
	ctl.AssignablePaged(c)
}

func (ctl *ClassController) AssignablePaged(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	items, total, err := ctl.svc.GetAssignablePaged(getRole(c), getUserID(c), limit, (page-1)*limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": items, "total": total, "page": page, "limit": limit})
}

// SV tự tham gia lớp bằng mã
func (ctl *ClassController) Join(c *gin.Context) {
	if getRole(c) != "Student" {
		c.JSON(http.StatusForbidden, gin.H{"error": "Chỉ tài khoản sinh viên mới có thể tham gia lớp"})
		return
	}
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
	ctl.audit.Log(getUserID(c), "class.joined", "class", class.ID, "Sinh viên tham gia lớp bằng mã lớp")
	c.JSON(http.StatusOK, gin.H{"message": "Đã tham gia lớp", "class": class})
}

// SV xem các lớp mình đã tham gia
func (ctl *ClassController) MyClasses(c *gin.Context) {
	ctl.MyClassesPaged(c)
}

func (ctl *ClassController) MyClassesPaged(c *gin.Context) {
	if getRole(c) != "Student" {
		c.JSON(http.StatusForbidden, gin.H{"error": "Chỉ tài khoản sinh viên mới có thể xem danh sách lớp đã tham gia"})
		return
	}
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	items, total, err := ctl.svc.GetMyClassesPaged(getUserID(c), limit, (page-1)*limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": items, "total": total, "page": page, "limit": limit})
}

func (ctl *ClassController) SearchStudents(c *gin.Context) {
	items, err := ctl.svc.SearchStudents(c.Query("query"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, items)
}

func (ctl *ClassController) Create(c *gin.Context) {
	var in dto.ClassInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	cl, _ := ctl.svc.Create(in, getUserID(c))
	ctl.audit.Log(getUserID(c), "class.created", "class", cl.ID, "Tạo lớp học: "+cl.Name)
	c.JSON(http.StatusCreated, cl)
}

func (ctl *ClassController) Update(c *gin.Context) {
	var in dto.ClassInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	cl, err := ctl.svc.Update(c.Param("id"), in, getUserID(c), getRole(c))
	if err == service.ErrNotOwner {
		c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
		return
	}
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Không tìm thấy lớp"})
		return
	}
	ctl.audit.Log(getUserID(c), "class.updated", "class", cl.ID, "Cập nhật lớp học: "+cl.Name)
	c.JSON(http.StatusOK, cl)
}

func (ctl *ClassController) Delete(c *gin.Context) {
	if err := ctl.svc.Delete(c.Param("id"), getUserID(c), getRole(c)); err != nil {
		status := http.StatusBadRequest
		if err == service.ErrNotOwner {
			status = http.StatusForbidden
		}
		c.JSON(status, gin.H{"error": err.Error()})
		return
	}
	entityID, _ := strconv.Atoi(c.Param("id"))
	ctl.audit.Log(getUserID(c), "class.deleted", "class", uint(entityID), "Xóa lớp học")
	c.JSON(http.StatusOK, gin.H{"message": "Đã xóa"})
}

func (ctl *ClassController) GetStudents(c *gin.Context) {
	ctl.GetStudentsPaged(c)
}

func (ctl *ClassController) GetStudentsPaged(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	items, total, err := ctl.svc.GetStudentsPaged(c.Param("id"), getUserID(c), getRole(c), limit, (page-1)*limit)
	if err != nil {
		if err == service.ErrNotOwner {
			c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": items, "total": total, "page": page, "limit": limit})
}

// GetExams: đề thi đã giao cho lớp
func (ctl *ClassController) GetExams(c *gin.Context) {
	ctl.GetExamsPaged(c)
}

func (ctl *ClassController) GetExamsPaged(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	items, total, err := ctl.svc.GetExamsPaged(c.Param("id"), getUserID(c), getRole(c), limit, (page-1)*limit)
	if err != nil {
		if err == service.ErrNotOwner {
			c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": items, "total": total, "page": page, "limit": limit})
}

func (ctl *ClassController) AddStudent(c *gin.Context) {
	var in dto.AddStudentInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := ctl.svc.AddStudent(c.Param("id"), in.StudentID, getUserID(c), getRole(c)); err != nil {
		if err == service.ErrNotOwner {
			c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	entityID, _ := strconv.Atoi(c.Param("id"))
	ctl.audit.Log(getUserID(c), "class.student_added", "class", uint(entityID), "Thêm sinh viên #"+strconv.FormatUint(uint64(in.StudentID), 10)+" vao lop")
	c.JSON(http.StatusCreated, gin.H{"message": "Đã thêm"})
}

func (ctl *ClassController) RemoveStudent(c *gin.Context) {
	if err := ctl.svc.RemoveStudent(c.Param("id"), c.Param("studentId"), getUserID(c), getRole(c)); err != nil {
		status := http.StatusBadRequest
		if err == service.ErrNotOwner {
			status = http.StatusForbidden
		}
		c.JSON(status, gin.H{"error": err.Error()})
		return
	}
	entityID, _ := strconv.Atoi(c.Param("id"))
	studentID, _ := strconv.Atoi(c.Param("studentId"))
	ctl.audit.Log(getUserID(c), "class.student_removed", "class", uint(entityID), "Xóa sinh viên #"+strconv.Itoa(studentID)+" khoi lop")
	c.JSON(http.StatusOK, gin.H{"message": "Đã xóa khỏi lớp"})
}
