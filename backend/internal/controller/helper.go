package controller

import "github.com/gin-gonic/gin"

// getUserID: lấy user_id từ context (0 nếu chưa đăng nhập)
func getUserID(c *gin.Context) uint {
	if v, ok := c.Get("user_id"); ok {
		if id, ok := v.(uint); ok {
			return id
		}
	}
	return 0
}

// getUserIDPtr: trả con trỏ user_id, nil nếu là khách (cho làm bài)
func getUserIDPtr(c *gin.Context) *uint {
	if v, ok := c.Get("user_id"); ok {
		if id, ok := v.(uint); ok {
			return &id
		}
	}
	return nil
}
