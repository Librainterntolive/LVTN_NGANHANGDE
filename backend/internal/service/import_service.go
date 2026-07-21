package service

import (
	"encoding/csv"
	"io"
	"strconv"
	"strings"

	"quiz-backend/internal/entity"
	"quiz-backend/internal/repository"

	"github.com/xuri/excelize/v2"
)

type ImportService struct {
	repo *repository.QuestionRepository
}

func NewImportService(repo *repository.QuestionRepository) *ImportService {
	return &ImportService{repo: repo}
}

// readRows: đọc toàn bộ dòng từ file CSV hoặc XLSX thành [][]string
func readRows(r io.Reader, ext string) ([][]string, error) {
	if ext == ".xlsx" {
		f, err := excelize.OpenReader(r)
		if err != nil {
			return nil, err
		}
		defer f.Close()
		sheets := f.GetSheetList()
		if len(sheets) == 0 {
			return nil, nil
		}
		return f.GetRows(sheets[0]) // đọc sheet đầu tiên
	}
	// mặc định CSV
	cr := csv.NewReader(r)
	cr.FieldsPerRecord = -1
	return cr.ReadAll()
}

func normHeader(s string) string {
	return strings.ToLower(strings.TrimSpace(strings.TrimPrefix(s, "\ufeff")))
}

// parseDifficulty: nh\u1eadn "easy/d\u1ec5", "hard/kh\u00f3", c\u00f2n l\u1ea1i l\u00e0 "medium"
func parseDifficulty(s string) string {
	switch strings.ToLower(strings.TrimSpace(s)) {
	case "easy", "d\u1ec5", "de":
		return "easy"
	case "hard", "kh\u00f3", "kho":
		return "hard"
	}
	return "medium"
}

// mapColumns: nhận diện cột theo tên tiêu đề (linh hoạt, không cần đúng thứ tự).
// Trả về map[field]index, hoặc nil nếu không nhận diện đủ -> sẽ dùng theo vị trí.
func mapColumns(header []string) map[string]int {
	m := map[string]int{}
	for i, h := range header {
		switch normHeader(h) {
		case "subject_id", "mã môn", "ma mon", "môn", "mon", "mã môn học", "subject":
			m["subject_id"] = i
		case "content", "câu hỏi", "cau hoi", "nội dung", "noi dung", "question", "đề bài":
			m["content"] = i
		case "a", "đáp án a", "dap an a", "answer a", "lựa chọn a":
			m["a"] = i
		case "b", "đáp án b", "dap an b", "answer b", "lựa chọn b":
			m["b"] = i
		case "c", "đáp án c", "dap an c", "answer c", "lựa chọn c":
			m["c"] = i
		case "d", "đáp án d", "dap an d", "answer d", "lựa chọn d":
			m["d"] = i
		case "correct", "đáp án đúng", "dap an dung", "đáp án", "key", "answer":
			m["correct"] = i
		case "difficulty", "độ khó", "do kho", "mức độ", "muc do":
			m["difficulty"] = i
		case "chapter_id", "chương", "chuong", "mã chương", "ma chuong":
			m["chapter_id"] = i
		}
	}
	// cần tối thiểu 3 cột này thì mới coi là map hợp lệ
	if _, ok := m["content"]; !ok {
		return nil
	}
	if _, ok := m["correct"]; !ok {
		return nil
	}
	if _, ok := m["subject_id"]; !ok {
		return nil
	}
	return m
}

// Import: đọc file (.csv/.xlsx), nhận diện cột, tạo câu hỏi.
// defaultSubjectID > 0: dùng khi dòng không có subject_id hợp lệ.
// Trả về danh sách ID câu hỏi đã tạo + danh sách lỗi.
func (s *ImportService) Import(r io.Reader, ext string, createdBy uint, defaultSubjectID uint) ([]uint, []string) {
	var ids []uint
	rows, err := readRows(r, ext)
	if err != nil {
		return ids, []string{"Khong doc duoc file: " + err.Error()}
	}
	if len(rows) < 2 {
		return ids, []string{"File khong co du lieu (can dong tieu de + it nhat 1 dong)"}
	}

	colMap := mapColumns(rows[0])
	useMap := colMap != nil

	// hàm lấy giá trị: ưu tiên theo tên cột, không có thì theo vị trí (pos < 0 = chỉ lấy theo tên cột)
	get := func(rec []string, key string, pos int) string {
		if useMap {
			if idx, ok := colMap[key]; ok && idx < len(rec) {
				return rec[idx]
			}
			return ""
		}
		if pos >= 0 && pos < len(rec) {
			return rec[pos]
		}
		return ""
	}

	var errs []string
	labels := []string{"A", "B", "C", "D"}

	for i := 1; i < len(rows); i++ { // bỏ dòng tiêu đề
		rec := rows[i]
		lineNo := i + 1
		if len(rec) == 0 {
			continue
		}
		rec[0] = strings.TrimPrefix(rec[0], "\ufeff")

		subjectID, e := strconv.Atoi(strings.TrimSpace(get(rec, "subject_id", 0)))
		if e != nil {
			if defaultSubjectID > 0 {
				subjectID = int(defaultSubjectID) // dùng môn mặc định khi file không có subject_id
			} else {
				errs = append(errs, "Dong "+strconv.Itoa(lineNo)+": subject_id khong hop le")
				continue
			}
		}
		content := strings.TrimSpace(get(rec, "content", 1))
		options := []string{get(rec, "a", 2), get(rec, "b", 3), get(rec, "c", 4), get(rec, "d", 5)}
		correctLabel := strings.ToUpper(strings.TrimSpace(get(rec, "correct", 6)))

		var answers []entity.Answer
		hasCorrect := false
		for j, opt := range options {
			opt = strings.TrimSpace(opt)
			if opt == "" {
				continue
			}
			isCorrect := labels[j] == correctLabel
			if isCorrect {
				hasCorrect = true
			}
			answers = append(answers, entity.Answer{Label: labels[j], Content: opt, IsCorrect: isCorrect, OrderIndex: j})
		}
		if content == "" || len(answers) < 2 || !hasCorrect {
			errs = append(errs, "Dong "+strconv.Itoa(lineNo)+": thieu noi dung/dap an/dap an dung")
			continue
		}

		// cột tùy chọn: độ khó + chương (chỉ nhận diện qua tên cột)
		difficulty := parseDifficulty(get(rec, "difficulty", -1))
		var chapterID *uint
		if v, e := strconv.Atoi(strings.TrimSpace(get(rec, "chapter_id", -1))); e == nil && v > 0 {
			u := uint(v)
			chapterID = &u
		}

		q := &entity.Question{
			SubjectID: uint(subjectID), ChapterID: chapterID, CreatedBy: createdBy,
			Content: content, QuestionType: "single", Difficulty: difficulty,
			Status: "active", Answers: answers,
		}
		if err := s.repo.Create(q); err != nil {
			errs = append(errs, "Dong "+strconv.Itoa(lineNo)+": loi luu DB")
			continue
		}
		ids = append(ids, q.ID)
	}
	return ids, errs
}

// GenerateTemplate: tạo file Excel mẫu để giáo viên tải về điền
func (s *ImportService) GenerateTemplate() ([]byte, error) {
	f := excelize.NewFile()
	defer f.Close()
	sheet := f.GetSheetName(0)

	headers := []string{"subject_id", "content", "A", "B", "C", "D", "correct", "difficulty", "chapter_id"}
	for i, h := range headers {
		cell, _ := excelize.CoordinatesToCellName(i+1, 1)
		f.SetCellValue(sheet, cell, h)
	}
	example := []interface{}{1, "Thủ đô Việt Nam là?", "Hà Nội", "Huế", "Đà Nẵng", "Cần Thơ", "A", "easy", ""}
	for i, v := range example {
		cell, _ := excelize.CoordinatesToCellName(i+1, 2)
		f.SetCellValue(sheet, cell, v)
	}

	buf, err := f.WriteToBuffer()
	if err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}
