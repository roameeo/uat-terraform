# Verify domain membership
Write-Host "=== Domain Membership Verification ===" -ForegroundColor Cyan
Write-Host ""

$computerSystem = Get-WmiObject Win32_ComputerSystem

Write-Host "Computer Name: $($computerSystem.Name)" -ForegroundColor Yellow
Write-Host "Domain: $($computerSystem.Domain)" -ForegroundColor Yellow
Write-Host "Part of Domain: $($computerSystem.PartOfDomain)" -ForegroundColor Yellow
Write-Host ""

if ($computerSystem.PartOfDomain -and $computerSystem.Domain -eq "uat.local") {
    Write-Host "SUCCESS: Computer is joined to uat.local domain" -ForegroundColor Green
} else {
    Write-Host "WARNING: Computer is not joined to uat.local domain" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Verification Complete ===" -ForegroundColor Cyan
