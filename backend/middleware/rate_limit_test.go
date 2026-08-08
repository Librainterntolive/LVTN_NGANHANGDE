package middleware

import (
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
)

func TestRateLimitBlocksRequestsAboveWindowLimit(t *testing.T) {
	gin.SetMode(gin.TestMode)
	router := gin.New()
	router.Use(RateLimit(2, time.Minute))
	router.GET("/auth", func(context *gin.Context) { context.Status(http.StatusNoContent) })

	for attempt := 1; attempt <= 3; attempt++ {
		response := httptest.NewRecorder()
		request := httptest.NewRequest(http.MethodGet, "/auth", nil)
		request.RemoteAddr = "192.0.2.10:1200"
		router.ServeHTTP(response, request)
		if attempt < 3 && response.Code != http.StatusNoContent {
			t.Fatalf("attempt %d returned %d, want %d", attempt, response.Code, http.StatusNoContent)
		}
		if attempt == 3 && response.Code != http.StatusTooManyRequests {
			t.Fatalf("attempt 3 returned %d, want %d", response.Code, http.StatusTooManyRequests)
		}
	}
}
