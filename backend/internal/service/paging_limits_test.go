package service

import "testing"

func TestQuestionPagingUsesSafeWindow(t *testing.T) {
	page, limit := normalizeQuestionPaging(0, 100)
	if page != 1 || limit != 12 {
		t.Fatalf("normalizeQuestionPaging(0, 100) = (%d, %d), want (1, 12)", page, limit)
	}
}

func TestSourcePagingUsesSafeWindow(t *testing.T) {
	page, limit := normalizeSourcePaging(4, 50)
	if page != 4 || limit != 12 {
		t.Fatalf("normalizeSourcePaging(4, 50) = (%d, %d), want (4, 12)", page, limit)
	}
}
