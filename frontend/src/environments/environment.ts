// Địa chỉ API của backend Go (Gin)
export const environment = {
  production: false,
  apiUrl: process.env.API_BASE_URL || 'http://localhost:8081/api',
};
