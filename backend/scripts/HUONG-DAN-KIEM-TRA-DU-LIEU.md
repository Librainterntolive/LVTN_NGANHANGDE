# Kiem tra du lieu that tren WampServer

Script `verify-real-data.ps1` chi chay cac cau lenh `SELECT`; khong tao, sua hay xoa ban ghi.

## Chay kiem tra

Mo PowerShell tai thu muc `backend` khi MySQL/WampServer dang chay:

```powershell
.\scripts\verify-real-data.ps1
```

Neu MySQL co mat khau, dat tam thoi trong phien PowerShell hien tai:

```powershell
$env:MYSQL_PWD = 'mat-khau-mysql'
.\scripts\verify-real-data.ps1
Remove-Item Env:MYSQL_PWD
```

Neu Wamp duoc cai o thu muc khac:

```powershell
.\scripts\verify-real-data.ps1 -MySqlExecutable 'C:\duong-dan\mysql.exe'
```

## Dieu kien dat

- `Cau hoi khong co nguon` bang `0`.
- `Cau hoi khong dung mot dap an` bang `0`.
- `De cong khai co cau hoi chua duyet/xac thuc` bang `0`.
- `De cong khai khong co cau hoi` bang `0`.
- Cac lien ket cau hoi, dap an va de thi khong mo coi.
- Khong con tai khoan phat trien co duoi email `@test.local`.

Chi dung de/cau hoi duoc phe duyet, co nguon da xac thuc khi trinh bay du lieu nghiem thu. Sau khi khoi phuc snapshot cu, chay migrations, seed nguon chinh thuc va script nay truoc khi khoi dong backend.

## Khoi phuc an toan tu snapshot cu

`database/quiz_db.sql` la snapshot phat trien cu, chi dung de khoi tao cau truc khi can. Khong dung rieng file nay de demo/bao cao vi no co the chua du lieu phat trien da cu.

Sau khi import snapshot vao `quiz_db`, import lan luot cac file trong `database/migrations/` theo thu tu ten file, sau do import:

```text
database/seed-mon-dai-hoc.sql
database/seed-go-official-basics.sql
database/seed-go-official-spec-supplement.sql
```

Cuoi cung chay `verify-real-data.ps1`. Chi khoi dong backend va nghiem thu khi script tra ve `KET QUA: DAT`.
