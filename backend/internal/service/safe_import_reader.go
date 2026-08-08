package service

import (
	"encoding/csv"
	"fmt"
	"io"

	"github.com/xuri/excelize/v2"
)

const (
	maxImportRows         = 2000
	maxImportColumns      = 32
	maxImportCellBytes    = 12 << 10
	maxImportUnzipSize    = 64 << 20
	maxImportUnzipXMLSize = 8 << 20
)

func validateImportRow(row []string) error {
	if len(row) > maxImportColumns {
		return fmt.Errorf("file co qua nhieu cot (toi da %d cot)", maxImportColumns)
	}
	for _, cell := range row {
		if len(cell) > maxImportCellBytes {
			return fmt.Errorf("o du lieu qua dai (toi da %d KB)", maxImportCellBytes>>10)
		}
	}
	return nil
}

func validateImportRows(rows [][]string) error {
	if len(rows) > maxImportRows {
		return fmt.Errorf("file co qua nhieu dong (toi da %d dong)", maxImportRows)
	}
	for _, row := range rows {
		if err := validateImportRow(row); err != nil {
			return err
		}
	}
	return nil
}

func readSafeCSVRows(reader io.Reader) ([][]string, error) {
	csvReader := csv.NewReader(reader)
	csvReader.FieldsPerRecord = -1
	rows := make([][]string, 0, 128)
	for {
		row, err := csvReader.Read()
		if err == io.EOF {
			return rows, nil
		}
		if err != nil {
			return nil, err
		}
		if len(rows) >= maxImportRows {
			return nil, fmt.Errorf("file co qua nhieu dong (toi da %d dong)", maxImportRows)
		}
		if err := validateImportRow(row); err != nil {
			return nil, err
		}
		rows = append(rows, row)
	}
}

func readSafeImportRows(reader io.Reader, ext string) ([][]string, error) {
	if ext != ".xlsx" {
		return readSafeCSVRows(reader)
	}

	file, err := excelize.OpenReader(reader, excelize.Options{
		UnzipSizeLimit:    maxImportUnzipSize,
		UnzipXMLSizeLimit: maxImportUnzipXMLSize,
	})
	if err != nil {
		return nil, err
	}
	defer file.Close()
	sheets := file.GetSheetList()
	if len(sheets) == 0 {
		return nil, nil
	}
	rows, err := file.GetRows(sheets[0])
	if err != nil {
		return nil, err
	}
	return rows, validateImportRows(rows)
}
