package service

import (
	"testing"
	"time"
)

func TestValidateUploadSpecRejectsUnsafeFiles(t *testing.T) {
	tests := []struct {
		name string
		file string
		size int64
		mime string
	}{
		{name: "oversized", file: "essay.pdf", size: 20*1024*1024 + 1, mime: "application/pdf"},
		{name: "executable renamed", file: "essay.pdf.exe", size: 42, mime: "application/x-msdownload"},
		{name: "unsupported extension", file: "script.js", size: 42, mime: "text/javascript"},
	}
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			if err := ValidateUploadSpec(test.file, test.size, test.mime); err == nil {
				t.Fatal("expected unsafe upload to be rejected")
			}
		})
	}
}

func TestValidateUploadSpecAcceptsAllowedPDF(t *testing.T) {
	if err := ValidateUploadSpec("bai-lam.pdf", 1024, "application/pdf"); err != nil {
		t.Fatalf("expected allowed PDF to pass, got %v", err)
	}
}

func TestSubmissionWindowLabelsLateAndClosed(t *testing.T) {
	dueAt := time.Date(2026, 8, 8, 10, 0, 0, 0, time.UTC)
	lateUntil := dueAt.Add(24 * time.Hour)
	if got := SubmissionWindow(dueAt.Add(-time.Minute), dueAt, lateUntil); got != "on_time" {
		t.Fatalf("before deadline = %q, want on_time", got)
	}
	if got := SubmissionWindow(dueAt.Add(time.Minute), dueAt, lateUntil); got != "late" {
		t.Fatalf("during grace period = %q, want late", got)
	}
	if got := SubmissionWindow(lateUntil.Add(time.Minute), dueAt, lateUntil); got != "closed" {
		t.Fatalf("after late deadline = %q, want closed", got)
	}
}
