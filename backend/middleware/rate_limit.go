package middleware

import (
	"net/http"
	"strconv"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
)

type rateLimitBucket struct {
	count   int
	resetAt time.Time
}

func RateLimit(limit int, window time.Duration) gin.HandlerFunc {
	if limit < 1 {
		limit = 1
	}
	if window <= 0 {
		window = time.Minute
	}

	var mutex sync.Mutex
	buckets := make(map[string]rateLimitBucket)

	return func(context *gin.Context) {
		now := time.Now()
		clientIP := context.ClientIP()
		mutex.Lock()
		bucket := buckets[clientIP]
		if bucket.resetAt.IsZero() || !now.Before(bucket.resetAt) {
			bucket = rateLimitBucket{resetAt: now.Add(window)}
		}
		bucket.count++
		buckets[clientIP] = bucket
		if len(buckets) > 4096 {
			for ip, candidate := range buckets {
				if !now.Before(candidate.resetAt) {
					delete(buckets, ip)
				}
			}
		}
		allowed := bucket.count <= limit
		retryAfter := int(time.Until(bucket.resetAt).Seconds())
		mutex.Unlock()

		if !allowed {
			if retryAfter < 1 {
				retryAfter = 1
			}
			context.Header("Retry-After", strconv.Itoa(retryAfter))
			context.AbortWithStatusJSON(http.StatusTooManyRequests, gin.H{"error": "qua nhieu yeu cau, vui long thu lai sau"})
			return
		}
		context.Next()
	}
}
