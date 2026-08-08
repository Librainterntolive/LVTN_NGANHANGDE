package middleware

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func MaxRequestBody(maxBytes int64) gin.HandlerFunc {
	if maxBytes < 1 {
		maxBytes = 1
	}
	return func(context *gin.Context) {
		if context.Request.ContentLength > maxBytes {
			context.AbortWithStatusJSON(http.StatusRequestEntityTooLarge, gin.H{"error": "Yêu cầu quá lớn"})
			return
		}
		context.Request.Body = http.MaxBytesReader(context.Writer, context.Request.Body, maxBytes)
		context.Next()
	}
}
