# Sao luu va kiem tra CSDL

Chay cac lenh tu thu muc `backend` khi WampServer/MySQL dang hoat dong.

## Kiem tra truoc khi demo

```powershell
.\scripts\pre-demo-check.ps1
```

Script khong hien thi mat khau. No kiem tra cau hinh `.env`, khoa ma hoa upload, SMTP, du lieu co nguon va hai server localhost.

## Kiem tra du lieu co nguon (read-only)

```powershell
.\scripts\verify-real-data.ps1
```

Script nay chi doc CSDL, khong thay doi bat ky ban ghi nao. Xem cach xu ly sau khi khoi phuc snapshot cu tai `scripts/HUONG-DAN-KIEM-TRA-DU-LIEU.md`.

Neu MySQL co mat khau, chi dat tam thoi trong cua so PowerShell hien tai:

```powershell
$env:MYSQL_PWD = 'mat-khau-mysql'
.\scripts\verify-real-data.ps1
Remove-Item Env:MYSQL_PWD
```

## Sao luu CSDL

```powershell
.\scripts\backup-quiz-db.ps1
```

Lenh tao file `.sql` theo thoi gian trong `backend/backups/`. File backup khong duoc dua vao Git.

Co the thay database hoac duong dan `mysqldump.exe` khi cai Wamp o vi tri khac:

```powershell
.\scripts\backup-quiz-db.ps1 -Database quiz_db -DumpExecutable 'C:\duong-dan\mysqldump.exe'
```
