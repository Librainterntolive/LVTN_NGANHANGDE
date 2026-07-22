package controller

import (
	"net/http"
	"path/filepath"
	"strings"

	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type ImportController struct {
	svc *service.ImportService
}

func NewImportController(svc *service.ImportService) *ImportController {
	return &ImportController{svc: svc}
}

const maxImportSize = 50 << 20 // 50 MB

func (ctl *ImportController) Import(c *gin.Context) {
	fileHeader, err := c.FormFile("file")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Khong nhan duoc file (field 'file')"})
		return
	}

	// chốt chặn 1: dung lượng tối đa 50MB
	if fileHeader.Size > maxImportSize {
		c.JSON(http.StatusBadRequest, gin.H{"error": "File qua lon (toi da 50MB)"})
		return
	}

	// chốt chặn 2: chỉ nhận .csv hoặc .xlsx
	ext := strings.ToLower(filepath.Ext(fileHeader.Filename))
	if ext != ".csv" && ext != ".xlsx" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Chi ho tro file .csv hoac .xlsx"})
		return
	}

	f, err := fileHeader.Open()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Khong mo duoc file"})
		return
	}
	defer f.Close()

	ids, subjectIDs, errs := ctl.svc.Import(f, ext, getUserID(c), 0)
	c.JSON(http.StatusOK, gin.H{
		"imported": len(ids),
		// môn đã nhận câu hỏi -> giao diện mở đúng môn đó cho người dùng thấy ngay
		"subject_ids": subjectIDs,
		"errors":      errs,
	})
}

// Template: tải file Excel mẫu để giáo viên điền
func (ctl *ImportController) Template(c *gin.Context) {
	data, err := ctl.svc.GenerateTemplate()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.Header("Content-Disposition", "attachment; filename=mau-import-cau-hoi.xlsx")
	c.Data(http.StatusOK,
		"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", data)
}
