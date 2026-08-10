package controller

import (
	"bytes"
	"strings"
	"testing"

	"quiz-backend/internal/entity"
	"quiz-backend/internal/service"
)

func TestPrintExamTemplateEscapesContentAndOmitsAnswerKey(t *testing.T) {
	var output bytes.Buffer
	data := struct {
		Exam      entity.Exam
		Variants  []service.ExamVariant
		PrintedAt string
	}{
		Exam: entity.Exam{ID: 7, Title: "De kiem tra", Duration: 45},
		Variants: []service.ExamVariant{{
			Code: "132",
			Questions: []entity.Question{{
				Content: "<script>window.evil=true</script>",
				Answers: []entity.Answer{
					{Label: "A", Content: "Dap an dung", IsCorrect: true},
					{Label: "B", Content: "Dap an sai", IsCorrect: false},
				},
			}},
			AnswerKey: []string{"A"},
		}},
		PrintedAt: "08/08/2026",
	}

	if err := printExamTemplate.Execute(&output, data); err != nil {
		t.Fatalf("execute print template: %v", err)
	}

	paper := output.String()
	if strings.Contains(paper, "<script>window.evil=true</script>") || !strings.Contains(paper, "&lt;script&gt;window.evil=true&lt;/script&gt;") {
		t.Fatalf("question content must be HTML-escaped: %q", paper)
	}
	if strings.Contains(strings.ToLower(paper), "is_correct") || strings.Contains(strings.ToLower(paper), "correct-answer") {
		t.Fatalf("print paper must not contain answer-key metadata: %q", paper)
	}
}
