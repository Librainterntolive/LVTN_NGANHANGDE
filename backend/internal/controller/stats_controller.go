package controller

import (
	"net/http"

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
	c.JSON(http.StatusOK, ctl.svc.Overview())
}

func (ctl *StatsController) ExamStats(c *gin.Context) {
	c.JSON(http.StatusOK, ctl.svc.ExamStats())
}
