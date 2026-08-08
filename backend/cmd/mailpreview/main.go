// Cong cu tam: xuat ban xem thu cua email ra file HTML de kiem tra giao dien.
package main

import (
	"fmt"
	"os"

	"quiz-backend/internal/service"
)

func main() {
	html := service.PreviewOTPEmail("046639")
	out := os.Args[1]
	if err := os.WriteFile(out, []byte(html), 0o600); err != nil {
		fmt.Println("Loi:", err)
		os.Exit(1)
	}
	fmt.Println("Da ghi:", out)
}
