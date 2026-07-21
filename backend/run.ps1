# Chay server nhanh.
#
# Vi sao khong dung "go run ./cmd"?
#   go run bien dich ra mot file .exe MOI trong thu muc tam moi lan chay, nen
#   Windows Defender phai quet lai tu dau moi lan -> cham vai giay.
#   Script nay bien dich ra mot file co dinh (bin/server.exe): Defender chi quet
#   1 lan, va neu ma nguon khong doi thi bo qua luon buoc bien dich.
#
# Cach dung:
#   .\run.ps1            chay server (bien dich lai neu can)
#   .\run.ps1 -Force     bat bien dich lai du ma nguon khong doi

param([switch]$Force)

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

$exe = Join-Path $PSScriptRoot 'bin\server.exe'
if (-not (Test-Path (Split-Path $exe))) {
    New-Item -ItemType Directory (Split-Path $exe) | Out-Null
}

# Co can bien dich lai khong? So gio sua file .go moi nhat voi gio cua .exe
$needBuild = $Force -or -not (Test-Path $exe)
if (-not $needBuild) {
    $newestSource = Get-ChildItem -Recurse -Filter *.go |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $needBuild = $newestSource.LastWriteTime -gt (Get-Item $exe).LastWriteTime
}

if ($needBuild) {
    Write-Host 'Dang bien dich...' -ForegroundColor Yellow
    go build -o $exe ./cmd
    if ($LASTEXITCODE -ne 0) { exit 1 }
} else {
    Write-Host 'Ma nguon khong doi - chay luon ban da bien dich.' -ForegroundColor Green
}

& $exe
