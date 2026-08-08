param(
    [string]$Database = 'quiz_db',
    [string]$User = 'root',
    [string]$DumpExecutable = 'C:\wamp64\bin\mysql\mysql9.1.0\bin\mysqldump.exe',
    [string]$OutputDirectory = (Join-Path $PSScriptRoot '..\backups')
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $DumpExecutable)) {
    throw "Khong tim thay mysqldump.exe: $DumpExecutable"
}

New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupFile = Join-Path $OutputDirectory ("$Database-$timestamp.sql")

# MYSQL_PWD co the duoc dat tam thoi trong phien PowerShell neu MySQL co mat khau.
$arguments = @(
    "--user=$User",
    '--single-transaction',
    '--routines',
    '--events',
    '--triggers',
    '--default-character-set=utf8mb4',
    "--result-file=$backupFile",
    $Database
)

& $DumpExecutable @arguments
if ($LASTEXITCODE -ne 0) {
    Remove-Item -LiteralPath $backupFile -Force -ErrorAction SilentlyContinue
    throw "Sao luu CSDL that bai (ma loi $LASTEXITCODE)."
}

$size = (Get-Item -LiteralPath $backupFile).Length
if ($size -eq 0) {
    Remove-Item -LiteralPath $backupFile -Force
    throw 'File sao luu rong, da xoa de tranh nham lan.'
}

Write-Host "Da sao luu $Database vao: $backupFile" -ForegroundColor Green
Write-Host "Dung luong: $size bytes" -ForegroundColor Cyan
