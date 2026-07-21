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

// getRole: vai trò lấy từ token ("" nếu chưa đăng nhập)
func getRole(c *gin.Context) string {
	if v, ok := c.Get("role"); ok {
		if s, ok := v.(string); ok {
			return s
		}
	}
	return ""
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
