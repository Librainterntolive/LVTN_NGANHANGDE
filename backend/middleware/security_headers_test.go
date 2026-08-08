package middleware

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
)

func TestSecurityHeaders(t *testing.T) {
	gin.SetMode(gin.TestMode)
	router := gin.New()
	router.Use(SecurityHeaders())
	router.GET("/ping", func(context *gin.Context) { context.Status(http.StatusNoContent) })

	response := httptest.NewRecorder()
	router.ServeHTTP(response, httptest.NewRequest(http.MethodGet, "/ping", nil))

	if value := response.Header().Get("X-Content-Type-Options"); value != "nosniff" {
		t.Fatalf("X-Content-Type-Options = %q, want nosniff", value)
	}
	if value := response.Header().Get("X-Frame-Options"); value != "SAMEORIGIN" {
		t.Fatalf("X-Frame-Options = %q, want SAMEORIGIN", value)
	}
}
