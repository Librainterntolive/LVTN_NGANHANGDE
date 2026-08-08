package repository

import "testing"

func TestRandomPageOffsetStaysInsideCompleteWindow(t *testing.T) {
	for iteration := 0; iteration < 20; iteration++ {
		offset, err := randomPageOffset(10, 3)
		if err != nil {
			t.Fatalf("randomPageOffset returned an error: %v", err)
		}
		if offset < 0 || offset > 7 {
			t.Fatalf("randomPageOffset(10, 3) = %d, want range 0..7", offset)
		}
	}
}

func TestRandomPageOffsetUsesZeroWhenAllItemsFit(t *testing.T) {
	offset, err := randomPageOffset(3, 3)
	if err != nil {
		t.Fatalf("randomPageOffset returned an error: %v", err)
	}
	if offset != 0 {
		t.Fatalf("randomPageOffset(3, 3) = %d, want 0", offset)
	}
}
