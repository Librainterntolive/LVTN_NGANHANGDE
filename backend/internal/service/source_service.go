package service

import (
	"errors"
	"net/url"
	"strconv"
	"strings"
	"time"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/entity"
	"quiz-backend/internal/repository"
)

type SourceService struct {
	repo *repository.SourceRepository
}

func NewSourceService(repo *repository.SourceRepository) *SourceService {
	return &SourceService{repo: repo}
}

func normalizeSourcePaging(page, limit int) (int, int) {
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	return page, limit
}

func validSourceURL(value string) bool {
	parsed, err := url.ParseRequestURI(strings.TrimSpace(value))
	if err != nil || parsed.Host == "" {
		return false
	}
	return parsed.Scheme == "http" || parsed.Scheme == "https"
}

func (s *SourceService) GetPaged(keyword string, page, limit int) ([]entity.Source, int64, error) {
	page, limit = normalizeSourcePaging(page, limit)
	return s.repo.FindPaged(keyword, limit, (page-1)*limit)
}

func (s *SourceService) Create(in dto.SourceInput, createdBy uint) (*entity.Source, error) {
	if strings.TrimSpace(in.Title) == "" || strings.TrimSpace(in.URL) == "" {
		return nil, errors.New("nguon phai co ten tai lieu va URL")
	}
	if !validSourceURL(in.URL) {
		return nil, errors.New("URL nguon phai bat dau bang http:// hoac https://")
	}
	if existing, err := s.repo.FindByURL(strings.TrimSpace(in.URL)); err == nil {
		return existing, nil
	}
	source := &entity.Source{
		Title: strings.TrimSpace(in.Title), Publisher: strings.TrimSpace(in.Publisher),
		URL: strings.TrimSpace(in.URL), PublishedYear: strings.TrimSpace(in.PublishedYear),
		LicenseNote: strings.TrimSpace(in.LicenseNote), VerificationStatus: "pending", CreatedBy: createdBy,
	}
	if err := s.repo.Create(source); err != nil {
		return nil, err
	}
	return source, nil
}

func (s *SourceService) RequireValidSource(id *uint, reference string) error {
	if id == nil || *id == 0 {
		return errors.New("cau hoi phai gan nguon tai lieu")
	}
	if strings.TrimSpace(reference) == "" {
		return errors.New("cau hoi phai co vi tri tham chieu trong nguon")
	}
	source, err := s.repo.FindByID(*id)
	if err != nil {
		return errors.New("nguon tai lieu khong ton tai")
	}
	if source.VerificationStatus != "verified" {
		return errors.New("nguon tai lieu chua duoc Admin xac thuc")
	}
	return nil
}

func (s *SourceService) Review(id string, status string, reviewerID uint) (*entity.Source, error) {
	sourceID, err := strconv.Atoi(id)
	if err != nil {
		return nil, errors.New("ma nguon khong hop le")
	}
	source, err := s.repo.FindByID(uint(sourceID))
	if err != nil {
		return nil, errors.New("nguon tai lieu khong ton tai")
	}
	if status != "verified" && status != "rejected" {
		return nil, errors.New("trang thai xac thuc khong hop le")
	}
	source.VerificationStatus = status
	source.ReviewedBy = &reviewerID
	now := time.Now()
	source.ReviewedAt = &now
	if err := s.repo.Update(source); err != nil {
		return nil, err
	}
	return source, nil
}
