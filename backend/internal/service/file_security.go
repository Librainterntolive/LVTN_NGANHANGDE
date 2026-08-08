package service

import (
	"errors"
	"path/filepath"
	"strings"
	"time"
)

const MaxAssignmentFileSize int64 = 20 * 1024 * 1024

var allowedAssignmentFiles = map[string]map[string]bool{
	".pdf":  {"application/pdf": true},
	".doc":  {"application/msword": true},
	".docx": {"application/vnd.openxmlformats-officedocument.wordprocessingml.document": true},
	".zip":  {"application/zip": true, "application/x-zip-compressed": true},
	".jpg":  {"image/jpeg": true},
	".jpeg": {"image/jpeg": true},
	".png":  {"image/png": true},
}

func ValidateUploadSpec(filename string, size int64, mimeType string) error {
	if filename == "" || size <= 0 {
		return errors.New("File không hợp lệ")
	}
	if size > MaxAssignmentFileSize {
		return errors.New("File vượt quá giới hạn 20 MB")
	}
	ext := strings.ToLower(filepath.Ext(filepath.Base(filename)))
	allowedMimes, ok := allowedAssignmentFiles[ext]
	if !ok {
		return errors.New("Định dạng file không được hỗ trợ")
	}
	if mimeType != "" && !allowedMimes[strings.ToLower(mimeType)] {
		return errors.New("Loại nội dung file không khớp định dạng")
	}
	return nil
}

func SubmissionWindow(now, dueAt, lateUntil time.Time) string {
	if !dueAt.IsZero() && now.After(dueAt) {
		if lateUntil.IsZero() || now.After(lateUntil) {
			return "closed"
		}
		return "late"
	}
	return "on_time"
}
