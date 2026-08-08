package controller

import (
	"net/http"
	"strconv"

	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type AuditController struct{ svc *service.AuditService }

func NewAuditController(svc *service.AuditService) *AuditController {
	return &AuditController{svc: svc}
}

func (ctl *AuditController) GetPaged(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	items, total, err := ctl.svc.GetPaged(c.Query("action"), limit, (page-1)*limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": items, "total": total, "page": page, "limit": limit})
}
