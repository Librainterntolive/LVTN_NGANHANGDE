package service

import "testing"

func TestNormalizeSubjectPagingCapsAndDefaults(t *testing.T) {
	tests := []struct {
		name              string
		page, limit       int
		wantPage, wantLim int
	}{
		{name: "uses defaults for invalid values", page: 0, limit: 0, wantPage: 1, wantLim: 12},
		{name: "caps excessive limit", page: 3, limit: 99, wantPage: 3, wantLim: 15},
		{name: "keeps supported limit", page: 2, limit: 10, wantPage: 2, wantLim: 10},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			page, limit := normalizeSubjectPaging(test.page, test.limit)
			if page != test.wantPage || limit != test.wantLim {
				t.Fatalf("normalizeSubjectPaging(%d, %d) = (%d, %d), want (%d, %d)", test.page, test.limit, page, limit, test.wantPage, test.wantLim)
			}
		})
	}
}
