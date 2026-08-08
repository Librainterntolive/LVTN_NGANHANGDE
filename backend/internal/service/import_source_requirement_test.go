package service

import (
	"strings"
	"testing"
)

func TestImportRejectsMissingSourceBeforeDatabaseAccess(t *testing.T) {
	service := &ImportService{}
	csv := "subject_id,content,A,B,C,D,correct,difficulty\n42,Cau hoi khong co nguon,Dap an A,Dap an B,Dap an C,Dap an D,A,easy\n"

	ids, subjectIDs, errs := service.Import(strings.NewReader(csv), ".csv", 1, 0)

	if len(ids) != 0 || len(subjectIDs) != 0 {
		t.Fatalf("missing-source row must not be imported: ids=%v subjects=%v", ids, subjectIDs)
	}
	if len(errs) != 1 || !strings.Contains(errs[0], "thieu ten nguon") {
		t.Fatalf("expected missing-source error, got %v", errs)
	}
}
