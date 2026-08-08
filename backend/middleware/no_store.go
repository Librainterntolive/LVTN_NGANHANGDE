package middleware

import "github.com/gin-gonic/gin"

func NoStore() gin.HandlerFunc {
	return func(context *gin.Context) {
		context.Header("Cache-Control", "no-store, max-age=0")
		context.Header("Pragma", "no-cache")
		context.Header("Expires", "0")
		context.Next()
	}
}
