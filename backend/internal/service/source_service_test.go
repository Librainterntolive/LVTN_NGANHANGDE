package service

import "testing"

func TestValidSourceURL(t *testing.T) {
	for _, value := range []string{"https://moet.gov.vn/van-ban", "http://example.edu.vn/tai-lieu"} {
		if !validSourceURL(value) {
			t.Fatalf("expected valid source URL: %q", value)
		}
	}
	for _, value := range []string{"", "example.edu.vn/tai-lieu", "ftp://example.edu.vn/file", "https:///missing-host"} {
		if validSourceURL(value) {
			t.Fatalf("expected invalid source URL: %q", value)
		}
	}
}
