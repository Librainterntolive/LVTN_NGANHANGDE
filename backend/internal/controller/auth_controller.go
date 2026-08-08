package controller

import (
	"net/http"
	"strconv"

	"quiz-backend/internal/dto"
	"quiz-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type AuthController struct {
	svc   *service.AuthService
	audit *service.AuditService
}

func NewAuthController(svc *service.AuthService, audit *service.AuditService) *AuthController {
	return &AuthController{svc: svc, audit: audit}
}

func (ctl *AuthController) Register(c *gin.Context) {
	var in dto.RegisterInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	user, err := ctl.svc.Register(in)
	if err != nil {
		if user != nil {
			c.JSON(http.StatusAccepted, gin.H{"id": user.ID, "username": user.Username, "role": user.Role, "otp_delivery_pending": true, "message": "Tai khoan da tao. Hay bam gui lai OTP neu chua nhan duoc email."})
			return
		}
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"id": user.ID, "username": user.Username, "role": user.Role})
}

func (ctl *AuthController) Login(c *gin.Context) {
	var in dto.LoginInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	token, user, err := ctl.svc.Login(in)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"token": token,
		"user": gin.H{
			"id": user.ID, "username": user.Username,
			"full_name": user.FullName, "role": user.Role, "must_change_password": user.MustChangePassword,
		},
	})
}
func (ctl *AuthController) VerifyOTP(c *gin.Context) {
	var in dto.VerifyOTPInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := ctl.svc.VerifyOTP(in.Email, in.Code); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Email đã xác minh"})
}
func (ctl *AuthController) ResendOTP(c *gin.Context) {
	var in dto.ResendOTPInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := ctl.svc.ResendOTP(in.Email); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Đã gửi lại OTP"})
}
func (ctl *AuthController) ForgotPassword(c *gin.Context) {
	var in dto.ForgotPasswordInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := ctl.svc.RequestPasswordReset(in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusAccepted, gin.H{"message": "Yêu cầu đã gửi Admin duyệt"})
}
func (ctl *AuthController) SendPasswordResetOTP(c *gin.Context) {
	var in dto.ResendOTPInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := ctl.svc.SendPasswordResetOTP(in.Email); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Đã gửi OTP quên mật khẩu"})
}
func (ctl *AuthController) ChangePassword(c *gin.Context) {
	var in dto.ChangePasswordInput
	if err := c.ShouldBindJSON(&in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := ctl.svc.ChangePassword(getUserID(c), in); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Đã đổi mật khẩu"})
}
func (ctl *AuthController) PendingResetRequests(c *gin.Context) {
	ctl.PendingResetRequestsPaged(c)
}
func (ctl *AuthController) PendingResetRequestsPaged(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 15 {
		limit = 12
	}
	rows, total, err := ctl.svc.PendingResetRequestsPaged(limit, (page-1)*limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": rows, "total": total, "page": page, "limit": limit})
}
func (ctl *AuthController) ApproveResetRequest(c *gin.Context) {
	if err := ctl.svc.ApproveResetRequest(c.Param("id")); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	requestID, _ := strconv.Atoi(c.Param("id"))
	ctl.audit.Log(getUserID(c), "password_reset.approved", "password_reset_request", uint(requestID), "Duyệt cấp mật khẩu tạm qua email")
	c.JSON(http.StatusOK, gin.H{"message": "Đã gửi mật khẩu tạm qua Gmail"})
}
