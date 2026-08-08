param(
    [string]$Database = 'quiz_db',
    [string]$User = 'root',
    [string]$MySqlExecutable = 'C:\wamp64\bin\mysql\mysql9.1.0\bin\mysql.exe'
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $MySqlExecutable)) {
    throw "Khong tim thay mysql.exe: $MySqlExecutable"
}

function Get-ScalarValue {
    param([string]$Sql)

    $arguments = @(
        "--user=$User",
        "--database=$Database",
        '--default-character-set=utf8mb4',
        '--batch',
        '--skip-column-names',
        '--raw',
        '--execute', $Sql
    )

    $result = & $MySqlExecutable @arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Khong the truy van database $Database (ma loi $LASTEXITCODE)."
    }

    return (($result -join '').Trim())
}

function Add-Check {
    param(
        [string]$Name,
        [string]$Sql,
        [int]$Expected = 0
    )

    $actual = [int](Get-ScalarValue $Sql)
    if ($actual -eq $Expected) {
        Write-Host "[DAT] ${Name}: $actual" -ForegroundColor Green
        return $true
    }

    Write-Host "[LOI] ${Name}: $actual (can la $Expected)" -ForegroundColor Red
    return $false
}

Write-Host "Kiem tra du lieu co nguon - database: $Database" -ForegroundColor Cyan
Write-Host 'Script chi doc du lieu, khong INSERT/UPDATE/DELETE.' -ForegroundColor DarkCyan

$allPassed = $true
$allPassed = (Add-Check -Name 'Cau hoi khong co nguon' -Sql @'
SELECT COUNT(*)
FROM questions q
LEFT JOIN sources s ON s.id = q.source_id
WHERE q.source_id IS NULL OR s.id IS NULL;
'@) -and $allPassed

$allPassed = (Add-Check -Name 'Cau hoi khong dung mot dap an' -Sql @'
SELECT COUNT(*)
FROM (
  SELECT q.id
  FROM questions q
  LEFT JOIN answers a ON a.question_id = q.id
  GROUP BY q.id
  HAVING SUM(CASE WHEN a.is_correct = 1 THEN 1 ELSE 0 END) <> 1
) AS invalid_questions;
'@) -and $allPassed

$allPassed = (Add-Check -Name 'De cong khai co cau hoi chua duyet/xac thuc' -Sql @'
SELECT COUNT(DISTINCT e.id)
FROM exams e
JOIN exam_questions eq ON eq.exam_id = e.id
LEFT JOIN questions q ON q.id = eq.question_id
LEFT JOIN sources s ON s.id = q.source_id
WHERE e.status = 'published'
  AND e.access_type = 'public'
  AND (q.id IS NULL OR q.status <> 'active' OR q.review_status <> 'approved'
       OR s.id IS NULL OR s.verification_status <> 'verified');
'@) -and $allPassed

$allPassed = (Add-Check -Name 'De cong khai khong co cau hoi' -Sql @'
SELECT COUNT(*)
FROM exams e
WHERE e.status = 'published'
  AND e.access_type = 'public'
  AND NOT EXISTS (SELECT 1 FROM exam_questions eq WHERE eq.exam_id = e.id);
'@) -and $allPassed

$allPassed = (Add-Check -Name 'Dap an mo coi' -Sql @'
SELECT COUNT(*) FROM answers a
LEFT JOIN questions q ON q.id = a.question_id
WHERE q.id IS NULL;
'@) -and $allPassed

$allPassed = (Add-Check -Name 'Lien ket cau hoi-de mo coi' -Sql @'
SELECT COUNT(*) FROM exam_questions eq
LEFT JOIN exams e ON e.id = eq.exam_id
LEFT JOIN questions q ON q.id = eq.question_id
WHERE e.id IS NULL OR q.id IS NULL;
'@) -and $allPassed

$allPassed = (Add-Check -Name 'Tai khoan test.local con sot' -Sql @'
SELECT COUNT(*) FROM users WHERE email LIKE '%@test.local';
'@) -and $allPassed

$verifiedSources = Get-ScalarValue @'
SELECT COUNT(*) FROM sources WHERE verification_status = 'verified';
'@
$approvedQuestions = Get-ScalarValue @'
SELECT COUNT(*)
FROM questions q
JOIN sources s ON s.id = q.source_id
WHERE q.status = 'active' AND q.review_status = 'approved' AND s.verification_status = 'verified';
'@
$publicExams = Get-ScalarValue @'
SELECT COUNT(*) FROM exams WHERE status = 'published' AND access_type = 'public';
'@

Write-Host ''
Write-Host "Nguon da xac thuc: $verifiedSources" -ForegroundColor Cyan
Write-Host "Cau hoi da duyet co nguon: $approvedQuestions" -ForegroundColor Cyan
Write-Host "De cong khai: $publicExams" -ForegroundColor Cyan

if (-not $allPassed) {
    Write-Host 'KET QUA: KHONG DAT. Khong dung du lieu nay de nghiem thu truoc khi sua cac muc bao loi.' -ForegroundColor Red
    exit 1
}

Write-Host 'KET QUA: DAT. Cac kiem tra toan ven va truy xuat du lieu deu qua.' -ForegroundColor Green
