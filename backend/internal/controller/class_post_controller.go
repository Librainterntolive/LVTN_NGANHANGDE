package controller

import (
	"net/http"
	"strconv"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type ClassPostController struct {
	svc   *service.ClassPostService
	audit *service.AuditService
}

func NewClassPostController(svc *service.ClassPostService, audit *service.AuditService) *ClassPostController {
	return &ClassPostController{svc: svc, audit: audit}
}

func postClassID(c *gin.Context) (uint, bool) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil || id < 1 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Mã lớp không hợp lệ"})
		return 0, false
	}
	return uint(id), true
}

func (ctl *ClassPostController) List(c *gin.Context) {
	classID, ok := postClassID(c)
	if !ok {
		return
	}
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 100 {
		limit = 12
	}
	items, total, err := ctl.svc.List(classID, getUserID(c), getRole(c), limit, (page-1)*limit)
	if err != nil {
		writeClassPostError(c, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": items, "total": total, "page": page, "limit": limit})
}

func (ctl *ClassPostController) Create(c *gin.Context) {
	classID, ok := postClassID(c)
	if !ok {
		return
	}
	var input dto.ClassPostInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	item, err := ctl.svc.Create(classID, getUserID(c), getRole(c), input)
	if err != nil {
		writeClassPostError(c, err)
		return
	}
	ctl.audit.Log(getUserID(c), "class.post_created", "class_post", item.ID, "Đăng thông báo trong lớp #"+strconv.FormatUint(uint64(classID), 10))
	c.JSON(http.StatusCreated, item)
}

func (ctl *ClassPostController) Update(c *gin.Context) {
	var input dto.ClassPostInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	item, err := ctl.svc.Update(c.Param("id"), getUserID(c), getRole(c), input)
	if err != nil {
		writeClassPostError(c, err)
		return
	}
	ctl.audit.Log(getUserID(c), "class.post_updated", "class_post", item.ID, "Cập nhật thông báo trong lớp #"+strconv.FormatUint(uint64(item.ClassID), 10))
	c.JSON(http.StatusOK, item)
}

func (ctl *ClassPostController) Delete(c *gin.Context) {
	item, err := ctl.svc.Delete(c.Param("id"), getUserID(c), getRole(c))
	if err != nil {
		writeClassPostError(c, err)
		return
	}
	ctl.audit.Log(getUserID(c), "class.post_deleted", "class_post", item.ID, "Xóa thông báo trong lớp #"+strconv.FormatUint(uint64(item.ClassID), 10))
	c.JSON(http.StatusOK, gin.H{"message": "Đã xóa thông báo"})
}

func writeClassPostError(c *gin.Context, err error) {
	status := http.StatusBadRequest
	if err == service.ErrNotOwner {
		status = http.StatusForbidden
	}
	c.JSON(status, gin.H{"error": err.Error()})
}
