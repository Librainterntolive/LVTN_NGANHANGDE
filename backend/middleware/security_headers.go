package middleware

import "github.com/gin-gonic/gin"

func SecurityHeaders() gin.HandlerFunc {
	return func(context *gin.Context) {
		context.Header("X-Content-Type-Options", "nosniff")
		context.Header("X-Frame-Options", "SAMEORIGIN")
		context.Header("Referrer-Policy", "strict-origin-when-cross-origin")
		context.Header("Permissions-Policy", "camera=(), microphone=(), geolocation=()")
		context.Next()
	}
}
