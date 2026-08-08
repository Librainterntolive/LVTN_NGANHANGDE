package service

import (
	"fmt"
	"html"
	"strings"
)

// Khung thu HTML dung chung cho moi email cua he thong.
//
// Vi sao dung bang (<table>) va style noi dong thay vi CSS hien dai: cac ung
// dung mail (Outlook, Gmail bản web) cat bo the <style> va ho tro flexbox rat
// kem. Bang voi style noi dong la cach duy nhat hien thi giong nhau o moi noi.
const (
	brandName    = "QuizBank"
	brandTagline = "Hệ thống quản lý ngân hàng đề thi"

	colorBrand   = "#2f52b8"
	colorText    = "#16203a"
	colorMuted   = "#66718c"
	colorBorder  = "#dde3ee"
	colorSurface = "#f4f6fb"
)

// PreviewOTPEmail tra ve ban HTML cua thu ma xac minh, dung de xem truoc giao
// dien thu ma khong phai gui that.
func PreviewOTPEmail(code string) string {
	_, htmlBody := otpEmailContent(code)
	return htmlBody
}

// emailBlock la mot doan noi dung trong thu.
type emailBlock struct {
	Text string // doan van thuong
	Code string // ma xac minh / mat khau tam, hien to va de doc
	Note string // dong luu y mau nhat
}

// buildEmail dung ca ban HTML va ban van ban thuan tu cung mot noi dung.
// Ban van ban thuan la bat buoc: mot so nguoi dat ung dung mail chi hien van
// ban, va cac bo loc thu rac danh gia thap thu chi co HTML.
func buildEmail(heading string, blocks []emailBlock, footer string) (textBody, htmlBody string) {
	var text strings.Builder
	var body strings.Builder

	text.WriteString(heading + "\r\n\r\n")

	for _, b := range blocks {
		switch {
		case b.Code != "":
			text.WriteString(b.Code + "\r\n\r\n")
			body.WriteString(fmt.Sprintf(
				`<tr><td style="padding:8px 0 20px"><div style="font-family:'Courier New',monospace;font-size:30px;font-weight:700;letter-spacing:6px;color:%s;background:%s;border:1px solid %s;border-radius:10px;padding:16px;text-align:center">%s</div></td></tr>`,
				colorBrand, colorSurface, colorBorder, html.EscapeString(b.Code)))
		case b.Note != "":
			text.WriteString(b.Note + "\r\n\r\n")
			body.WriteString(fmt.Sprintf(
				`<tr><td style="padding:0 0 16px;font-size:13px;line-height:1.6;color:%s">%s</td></tr>`,
				colorMuted, html.EscapeString(b.Note)))
		default:
			text.WriteString(b.Text + "\r\n\r\n")
			body.WriteString(fmt.Sprintf(
				`<tr><td style="padding:0 0 14px;font-size:15px;line-height:1.65;color:%s">%s</td></tr>`,
				colorText, html.EscapeString(b.Text)))
		}
	}

	text.WriteString(footer + "\r\n")
	text.WriteString("Thư tự động từ " + brandName + ". Vui lòng không trả lời email này.\r\n")

	htmlBody = fmt.Sprintf(`<!doctype html>
<html lang="vi"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"></head>
<body style="margin:0;padding:24px 12px;background:%s;font-family:'Segoe UI',Roboto,Arial,sans-serif">
<table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%%" style="max-width:560px;margin:0 auto;background:#ffffff;border:1px solid %s;border-radius:14px">
  <tr><td style="padding:22px 28px;background:%s;border-radius:13px 13px 0 0">
    <div style="font-size:18px;font-weight:700;color:#ffffff">%s</div>
    <div style="font-size:12px;color:#dbe3ff;padding-top:2px">%s</div>
  </td></tr>
  <tr><td style="padding:26px 28px 6px">
    <div style="font-size:19px;font-weight:700;color:%s;padding-bottom:16px">%s</div>
    <table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%%">%s</table>
  </td></tr>
  <tr><td style="padding:14px 28px 24px;border-top:1px solid %s">
    <div style="font-size:12px;line-height:1.6;color:%s">%s</div>
    <div style="font-size:12px;line-height:1.6;color:%s;padding-top:6px">Thư tự động từ %s. Vui lòng không trả lời email này.</div>
  </td></tr>
</table>
</body></html>`,
		colorSurface, colorBorder, colorBrand,
		html.EscapeString(brandName), html.EscapeString(brandTagline),
		colorText, html.EscapeString(heading),
		body.String(),
		colorBorder, colorMuted, html.EscapeString(footer), colorMuted, html.EscapeString(brandName))

	return text.String(), htmlBody
}
