package service

import "testing"

func TestValidateImportRowsRejectsExcessiveRows(t *testing.T) {
	rows := make([][]string, maxImportRows+1)
	if err := validateImportRows(rows); err == nil {
		t.Fatal("expected excessive row count to be rejected")
	}
}

func TestValidateImportRowsRejectsExcessiveColumns(t *testing.T) {
	row := make([]string, maxImportColumns+1)
	if err := validateImportRows([][]string{row}); err == nil {
		t.Fatal("expected excessive column count to be rejected")
	}
}
