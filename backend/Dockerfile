# ==========================================
# Stage 1: Build binary & Download Cert
# ==========================================
FROM golang:1.24-alpine AS builder

# Region mặc định (có thể override khi chạy `docker build --build-arg AWS_REGION=...`)
ARG AWS_REGION=ap-southeast-1

WORKDIR /app

# Cài đặt curl, ca-certificates và git
RUN apk add --no-cache curl ca-certificates git

# Tải RDS CA Bundle trực tiếp từ AWS Truststore PKI
# URL chuẩn: https://truststore.pki.rds.amazonaws.com/<region>/<region>-bundle.pem
RUN mkdir -p /app/certs && \
    curl -fsSL "https://truststore.pki.rds.amazonaws.com/${AWS_REGION}/${AWS_REGION}-bundle.pem" \
    -o /app/certs/regional.pem

# Cache & tải Go modules
COPY go.mod go.sum ./
RUN go mod download
RUN go mod tidy
# Copy mã nguồn và build binary tĩnh
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GIN_MODE=debug go build \
    -ldflags="-w -s" \
    -o server ./main.go

# ==========================================
# Stage 2: Runtime Image (Minimal & Secure)
# ==========================================
FROM alpine:3.21

WORKDIR /app

# Cài đặt certs hệ thống, tzdata và tạo non-root user
RUN apk --no-cache add ca-certificates tzdata \
    && addgroup -S appgroup && adduser -S appuser -G appgroup

# Tạo thư mục certs
RUN mkdir -p /app/certs

# 1. Copy cert vừa curl từ builder sang runtime
COPY --from=builder /app/certs/regional.pem /app/certs/regional.pem

# 2. Copy binary thực thi
COPY --from=builder /app/server /app/server

# Phân quyền cho non-root user
RUN chown -R appuser:appgroup /app

# Chuyển sang non-root user
USER appuser

EXPOSE 8080

ENTRYPOINT ["/app/server"]
