package controller

import (
	"net/http"
	"strconv"

	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type StatsController struct {
	svc *service.StatsService
}

func NewStatsController(svc *service.StatsService) *StatsController {
	return &StatsController{svc: svc}
}

func (ctl *StatsController) Overview(c *gin.Context) {
	c.JSON(http.StatusOK, ctl.svc.Overview(getUserID(c), getRole(c)))
}

func (ctl *StatsController) ExamStats(c *gin.Context) {
	ctl.ExamStatsPaged(c)
}

func (ctl *StatsController) ExamStatsPaged(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	items, total, err := ctl.svc.ExamStatsPaged(getUserID(c), getRole(c), limit, (page-1)*limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": items, "total": total, "page": page, "limit": limit})
}
