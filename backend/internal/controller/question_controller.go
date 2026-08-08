package controller

import (
	"net/http"
	"strconv"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/repository"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type QuestionController struct {
	svc   *service.QuestionService
	audit *service.AuditService
}

func NewQuestionController(svc *service.QuestionService, audit *service.AuditService) *QuestionController {
	return &QuestionController{svc: svc, audit: audit}
}

func (ctl *QuestionController) GetAll(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	f := repository.QuestionFilter{
		SubjectID:      c.Query("subject_id"),
		Keyword:        c.Query("keyword"),
		OwnerMode:      c.Query("owner"), // ""/me/others
		OwnerID:        getUserID(c),
		ChapterID:      c.Query("chapter_id"), // ""/none/id chương
		Status:         c.Query("status"),     // ""/draft/active
		Difficulty:     c.Query("difficulty"), // ""/easy/medium/hard
		ReviewStatus:   c.Query("review_status"),
		RestrictShared: getRole(c) != "Admin",
	}
	items, total, _ := ctl.svc.GetPaged(f, page, limit)
	c.JSON(http.StatusOK, gin.H{"items": items, "total": total, "page": page, "limit": limit})
}

func (ctl *QuestionController) GetByID(c *gin.Context) {
	q, err := ctl.svc.GetByID(c.Param("id"), getUserID(c), getRole(c))
	if err != nil {
		if err == service.ErrNotOwner {
			c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusNotFound, gin.H{"error": "Không tìm thấy câu hỏi"})
		return
	}
	c.JSON(http.StatusOK, q)
}

func (ctl *QuestionController) Create(c *gin.Context) {
	var in dto.QuestionInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	q, err := ctl.svc.Create(in, getUserID(c))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctl.audit.Log(getUserID(c), "question.created", "question", q.ID, "Tạo câu hỏi mới")
	c.JSON(http.StatusCreated, q)
}

func (ctl *QuestionController) Update(c *gin.Context) {
	var in dto.QuestionInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	q, err := ctl.svc.Update(c.Param("id"), in, getUserID(c), getRole(c))
	if err != nil {
		status := http.StatusBadRequest
		if err == service.ErrNotOwner {
			status = http.StatusForbidden
		}
		c.JSON(status, gin.H{"error": err.Error()})
		return
	}
	ctl.audit.Log(getUserID(c), "question.updated", "question", q.ID, "Cập nhật câu hỏi")
	c.JSON(http.StatusOK, q)
}

func (ctl *QuestionController) Delete(c *gin.Context) {
	if err := ctl.svc.Delete(c.Param("id"), getUserID(c), getRole(c)); err != nil {
		status := http.StatusBadRequest
		if err == service.ErrNotOwner {
			status = http.StatusForbidden
		}
		c.JSON(status, gin.H{"error": err.Error()})
		return
	}
	entityID, _ := strconv.Atoi(c.Param("id"))
	ctl.audit.Log(getUserID(c), "question.deleted", "question", uint(entityID), "Xóa câu hỏi")
	c.JSON(http.StatusOK, gin.H{"message": "Đã xóa"})
}

func (ctl *QuestionController) SubmitForReview(c *gin.Context) {
	q, err := ctl.svc.SubmitForReview(c.Param("id"), getUserID(c), getRole(c))
	if err != nil {
		status := http.StatusBadRequest
		if err == service.ErrNotOwner {
			status = http.StatusForbidden
		}
		c.JSON(status, gin.H{"error": err.Error()})
		return
	}
	ctl.audit.Log(getUserID(c), "question.submitted", "question", q.ID, "Gửi câu hỏi cho quản trị viên duyệt")
	c.JSON(http.StatusOK, q)
}

func (ctl *QuestionController) Review(c *gin.Context) {
	var in dto.ReviewInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	q, err := ctl.svc.Review(c.Param("id"), in, getUserID(c))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctl.audit.Log(getUserID(c), "question.reviewed", "question", q.ID, "Cập nhật trạng thái duyệt thành "+q.ReviewStatus)
	c.JSON(http.StatusOK, q)
}
