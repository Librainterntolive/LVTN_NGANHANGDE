package controller

import (
	"net/http"
	"path/filepath"
	"strconv"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type AssignmentController struct {
	svc   *service.AssignmentService
	audit *service.AuditService
}

func NewAssignmentController(svc *service.AssignmentService, audit *service.AuditService) *AssignmentController {
	return &AssignmentController{svc: svc, audit: audit}
}

func (ctl *AssignmentController) Create(c *gin.Context) {
	var input dto.AssignmentInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	classID, _ := strconv.Atoi(c.Param("id"))
	input.ClassID = uint(classID)
	item, err := ctl.svc.Create(input, getUserID(c), getRole(c))
	if err != nil {
		writeAssignmentError(c, err)
		return
	}
	ctl.audit.Log(getUserID(c), "assignment.created", "assignment", item.ID, "Tao bai tap: "+item.Title)
	c.JSON(http.StatusCreated, item)
}
func (ctl *AssignmentController) List(c *gin.Context) {
	classID, _ := strconv.Atoi(c.Param("id"))
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	items, total, err := ctl.svc.List(uint(classID), getUserID(c), getRole(c), limit, (page-1)*limit)
	if err != nil {
		writeAssignmentError(c, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": items, "total": total, "page": page, "limit": limit})
}
func (ctl *AssignmentController) ClassStats(c *gin.Context) {
	id, _ := strconv.Atoi(c.Param("id"))
	rows, err := ctl.svc.ClassStats(uint(id), getUserID(c), getRole(c))
	if err != nil {
		writeAssignmentError(c, err)
		return
	}
	c.JSON(http.StatusOK, rows)
}
func (ctl *AssignmentController) ClassStatsPaged(c *gin.Context) {
	id, _ := strconv.Atoi(c.Param("id"))
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	items, total, summary, err := ctl.svc.ClassStatsPaged(uint(id), getUserID(c), getRole(c), limit, (page-1)*limit)
	if err != nil {
		writeAssignmentError(c, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": items, "total": total, "summary": summary, "page": page, "limit": limit})
}
func (ctl *AssignmentController) Update(c *gin.Context) {
	var input dto.AssignmentInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	id, _ := strconv.Atoi(c.Param("assignmentId"))
	item, err := ctl.svc.Update(uint(id), getUserID(c), getRole(c), input)
	if err != nil {
		writeAssignmentError(c, err)
		return
	}
	ctl.audit.Log(getUserID(c), "assignment.updated", "assignment", item.ID, "Cap nhat bai tap: "+item.Title)
	c.JSON(http.StatusOK, item)
}
func (ctl *AssignmentController) Delete(c *gin.Context) {
	id, _ := strconv.Atoi(c.Param("assignmentId"))
	if err := ctl.svc.Delete(uint(id), getUserID(c), getRole(c)); err != nil {
		writeAssignmentError(c, err)
		return
	}
	ctl.audit.Log(getUserID(c), "assignment.deleted", "assignment", uint(id), "Xoa bai tap")
	c.JSON(http.StatusOK, gin.H{"message": "Da xoa bai tap"})
}
func (ctl *AssignmentController) StartUpload(c *gin.Context) {
	var input dto.StartUploadInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	id, _ := strconv.Atoi(c.Param("id"))
	item, err := ctl.svc.StartUpload(uint(id), getUserID(c), input)
	if err != nil {
		writeAssignmentError(c, err)
		return
	}
	c.JSON(http.StatusCreated, item)
}
func (ctl *AssignmentController) UploadChunk(c *gin.Context) {
	index, err := strconv.Atoi(c.Param("index"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "chi so phan file khong hop le"})
		return
	}
	count, err := ctl.svc.SaveChunk(c.Param("uploadId"), getUserID(c), index, c.Request.Body, c.Request.ContentLength)
	if err != nil {
		writeAssignmentError(c, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"received_chunks": count})
}
func (ctl *AssignmentController) UploadProgress(c *gin.Context) {
	session, indexes, err := ctl.svc.UploadProgress(c.Param("uploadId"), getUserID(c))
	if err != nil {
		writeAssignmentError(c, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"id": session.ID, "chunk_size": session.ChunkSize, "total_chunks": session.TotalChunks, "received_indexes": indexes})
}
func (ctl *AssignmentController) CompleteUpload(c *gin.Context) {
	item, err := ctl.svc.CompleteUpload(c.Param("uploadId"), getUserID(c))
	if err != nil {
		writeAssignmentError(c, err)
		return
	}
	ctl.audit.Log(getUserID(c), "assignment.submitted", "assignment_submission", item.ID, "Nop bai tap: "+item.OriginalName)
	c.JSON(http.StatusCreated, item)
}
func (ctl *AssignmentController) ListSubmissions(c *gin.Context) {
	ctl.ListSubmissionsPaged(c)
}
func (ctl *AssignmentController) ListSubmissionsPaged(c *gin.Context) {
	id, _ := strconv.Atoi(c.Param("id"))
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	items, total, err := ctl.svc.ListSubmissionsPaged(uint(id), getUserID(c), getRole(c), limit, (page-1)*limit)
	if err != nil {
		writeAssignmentError(c, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": items, "total": total, "page": page, "limit": limit})
}
func (ctl *AssignmentController) Grade(c *gin.Context) {
	var input dto.GradeAssignmentInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	id, _ := strconv.Atoi(c.Param("id"))
	item, err := ctl.svc.Grade(uint(id), getUserID(c), getRole(c), input.Score, input.Feedback)
	if err != nil {
		writeAssignmentError(c, err)
		return
	}
	ctl.audit.Log(getUserID(c), "assignment.graded", "assignment_submission", item.ID, "Cham bai tap")
	c.JSON(http.StatusOK, item)
}
func (ctl *AssignmentController) Download(c *gin.Context) {
	id, _ := strconv.Atoi(c.Param("id"))
	item, data, err := ctl.svc.Download(uint(id), getUserID(c), getRole(c))
	if err != nil {
		writeAssignmentError(c, err)
		return
	}
	c.Header("Content-Disposition", "attachment; filename="+strconv.Quote(filepath.Base(item.OriginalName)))
	c.Data(http.StatusOK, item.MimeType, data)
}
func writeAssignmentError(c *gin.Context, err error) {
	status := http.StatusBadRequest
	if err == service.ErrNotOwner {
		status = http.StatusForbidden
	}
	c.JSON(status, gin.H{"error": err.Error()})
}
