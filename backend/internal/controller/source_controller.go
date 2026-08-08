package controller

import (
	"net/http"
	"strconv"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type SourceController struct {
	svc   *service.SourceService
	audit *service.AuditService
}

func NewSourceController(svc *service.SourceService, audit *service.AuditService) *SourceController {
	return &SourceController{svc: svc, audit: audit}
}

func (ctl *SourceController) GetAll(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	items, total, err := ctl.svc.GetPaged(c.Query("keyword"), page, limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": items, "total": total, "page": page, "limit": limit})
}

func (ctl *SourceController) Create(c *gin.Context) {
	var in dto.SourceInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	source, err := ctl.svc.Create(in, getUserID(c))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctl.audit.Log(getUserID(c), "source.created", "source", source.ID, "Khai báo nguồn tài liệu: "+source.Title)
	c.JSON(http.StatusCreated, source)
}

func (ctl *SourceController) Review(c *gin.Context) {
	var input dto.SourceReviewInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	source, err := ctl.svc.Review(c.Param("id"), input.Status, getUserID(c))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctl.audit.Log(getUserID(c), "source.reviewed", "source", source.ID, "Cập nhật trạng thái nguồn thành "+source.VerificationStatus+": "+source.Title)
	c.JSON(http.StatusOK, source)
}
