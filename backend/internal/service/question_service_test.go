package service

import "testing"

func TestNormalizedQuestionContent(t *testing.T) {
	input := "  CÂU   hỏi\n  có   khoảng trắng  "
	got := normalizedQuestionContent(input)
	want := "câu hỏi có khoảng trắng"
	if got != want {
		t.Fatalf("normalizedQuestionContent() = %q, want %q", got, want)
	}
}

func TestQuestionContentHashIgnoresWhitespaceAndCase(t *testing.T) {
	first := questionContentHash("  CÂU hỏi\n có khoảng trắng  ")
	second := questionContentHash("câu   HỎI có    khoảng trắng")
	if first != second {
		t.Fatalf("equivalent question content must have the same hash: %q != %q", first, second)
	}
}
