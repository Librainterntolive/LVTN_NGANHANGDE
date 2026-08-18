package controller

import (
	"net/http"
	"strconv"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type UserController struct {
	svc   *service.UserService
	audit *service.AuditService
}

func NewUserController(svc *service.UserService, audit *service.AuditService) *UserController {
	return &UserController{svc: svc, audit: audit}
}

func (ctl *UserController) GetAll(c *gin.Context) {
	ctl.GetPaged(c)
}
func (ctl *UserController) GetPaged(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 100 {
		limit = 12
	}
	rows, total, err := ctl.svc.GetPaged(c.Query("keyword"), limit, (page-1)*limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": rows, "total": total, "page": page, "limit": limit})
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
	ctl.audit.Log(getUserID(c), "user.created", "user", u.ID, "Tạo tài khoản: "+u.Username+" ("+u.Role+")")
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
		c.JSON(http.StatusNotFound, gin.H{"error": "Không tìm thấy người dùng"})
		return
	}
	ctl.audit.Log(getUserID(c), "user.updated", "user", u.ID, "Cập nhật tài khoản: "+u.Username+" ("+u.Status+")")
	c.JSON(http.StatusOK, u)
}

func (ctl *UserController) Delete(c *gin.Context) {
	id, _ := strconv.Atoi(c.Param("id"))
	if uint(id) == getUserID(c) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Không thể xóa tài khoản đang đăng nhập"})
		return
	}
	if err := ctl.svc.Delete(c.Param("id")); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Không tìm thấy người dùng"})
		return
	}
	ctl.audit.Log(getUserID(c), "user.deleted", "user", uint(id), "Xóa tài khoản")
	c.JSON(http.StatusOK, gin.H{"message": "Đã xóa"})
}
