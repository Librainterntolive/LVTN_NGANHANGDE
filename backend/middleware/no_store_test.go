package middleware

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
)

func TestNoStoreAddsCacheProtectionHeaders(t *testing.T) {
	gin.SetMode(gin.TestMode)
	router := gin.New()
	router.Use(NoStore())
	router.GET("/auth", func(context *gin.Context) { context.Status(http.StatusNoContent) })

	response := httptest.NewRecorder()
	router.ServeHTTP(response, httptest.NewRequest(http.MethodGet, "/auth", nil))
	if value := response.Header().Get("Cache-Control"); value != "no-store, max-age=0" {
		t.Fatalf("Cache-Control = %q, want no-store", value)
	}
	if value := response.Header().Get("Pragma"); value != "no-cache" {
		t.Fatalf("Pragma = %q, want no-cache", value)
	}
}
