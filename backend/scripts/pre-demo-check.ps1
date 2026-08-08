param(
    [string]$MySqlExecutable = 'C:\wamp64\bin\mysql\mysql9.1.0\bin\mysql.exe',
    [string]$BackendUrl = 'http://127.0.0.1:8081/api/ping',
    [string]$FrontendUrl = 'http://localhost:4200/'
)

$ErrorActionPreference = 'Stop'
$backendRoot = Split-Path -Parent $PSScriptRoot
$envFile = Join-Path $backendRoot '.env'
$allPassed = $true

function Write-Result {
    param([bool]$Passed, [string]$Name, [string]$Detail = '')

    $prefix = if ($Passed) { '[DAT]' } else { '[LOI]' }
    $color = if ($Passed) { 'Green' } else { 'Red' }
    $suffix = if ($Detail) { " - $Detail" } else { '' }
    Write-Host "$prefix $Name$suffix" -ForegroundColor $color
    return $Passed
}

function Get-HttpStatus {
    param([string]$Url)

    $status = curl.exe -sS -o NUL -w '%{http_code}' --max-time 5 $Url
    if ($LASTEXITCODE -ne 0) {
        return '000'
    }
    return $status.Trim()
}

Write-Host 'Pre-demo check - khong hien thi gia tri bi mat.' -ForegroundColor Cyan

if (-not (Test-Path $envFile)) {
    Write-Result $false 'File .env' 'khong tim thay' | Out-Null
    exit 1
}

$settings = @{}
foreach ($line in Get-Content $envFile) {
    $trimmed = $line.Trim()
    if (-not $trimmed -or $trimmed.StartsWith('#') -or -not $trimmed.Contains('=')) {
        continue
    }
    $parts = $trimmed -split '=', 2
    $settings[$parts[0].Trim()] = $parts[1].Trim()
}

$requiredDatabase = @('DB_HOST', 'DB_PORT', 'DB_USER', 'DB_NAME')
foreach ($name in $requiredDatabase) {
    $valid = $settings.ContainsKey($name) -and -not [string]::IsNullOrWhiteSpace($settings[$name])
    $allPassed = (Write-Result $valid "Cau hinh $name") -and $allPassed
}

$jwtConfigured = $settings.ContainsKey('JWT_SECRET') -and $settings['JWT_SECRET'].Length -ge 32 -and $settings['JWT_SECRET'] -ne 'doi-thanh-chuoi-bi-mat-cua-ban'
$allPassed = (Write-Result $jwtConfigured 'JWT_SECRET' 'da dat gia tri rieng va du dai') -and $allPassed

$encryptionConfigured = $false
if ($settings.ContainsKey('FILE_ENCRYPTION_KEY')) {
    try {
        $encryptionConfigured = ([Convert]::FromBase64String($settings['FILE_ENCRYPTION_KEY'])).Length -eq 32
    } catch {
        $encryptionConfigured = $false
    }
}
$allPassed = (Write-Result $encryptionConfigured 'FILE_ENCRYPTION_KEY' 'base64 32 byte') -and $allPassed

$requiredSmtp = @('SMTP_HOST', 'SMTP_PORT', 'SMTP_USERNAME', 'SMTP_PASSWORD', 'SMTP_FROM')
foreach ($name in $requiredSmtp) {
    $valid = $settings.ContainsKey($name) -and -not [string]::IsNullOrWhiteSpace($settings[$name])
    $allPassed = (Write-Result $valid "Cau hinh $name") -and $allPassed
}

if ($settings.ContainsKey('AUTO_MIGRATE') -and $settings['AUTO_MIGRATE'].ToLowerInvariant() -eq 'true') {
    Write-Host '[CANH BAO] AUTO_MIGRATE=true. Dat lai false sau khi cap nhat schema.' -ForegroundColor Yellow
}

$database = if ($settings.ContainsKey('DB_NAME')) { $settings['DB_NAME'] } else { 'quiz_db' }
& (Join-Path $PSScriptRoot 'verify-real-data.ps1') -Database $database -MySqlExecutable $MySqlExecutable
$verifyExitCode = $LASTEXITCODE
$allPassed = (Write-Result ($verifyExitCode -eq 0) 'Kiem tra du lieu co nguon') -and $allPassed

$backendStatus = Get-HttpStatus $BackendUrl
$allPassed = (Write-Result ($backendStatus -eq '200') 'Backend API' "HTTP $backendStatus") -and $allPassed

$frontendStatus = Get-HttpStatus $FrontendUrl
$allPassed = (Write-Result ($frontendStatus -eq '200') 'Frontend' "HTTP $frontendStatus") -and $allPassed

if (-not $allPassed) {
    Write-Host 'KET QUA: KHONG DAT. Sua cac muc bao loi truoc khi demo.' -ForegroundColor Red
    exit 1
}

Write-Host 'KET QUA: DAT. May da san sang cho phien demo.' -ForegroundColor Green
