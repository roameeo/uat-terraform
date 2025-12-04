# Rejoin computer to domain
Write-Host "=== Rejoining Computer to Domain ===" -ForegroundColor Cyan
Write-Host ""

$domainUser = "UAT\terraform.adm"
$domainPass = ConvertTo-SecureString "TerraformAdmin2024!" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($domainUser, $domainPass)

try {
    Write-Host "Removing computer from domain..." -ForegroundColor Yellow
    Remove-Computer -UnjoinDomainCredential $cred -PassThru -Force -Verbose
    Write-Host "Computer removed from domain" -ForegroundColor Green
    Write-Host "Restarting in 10 seconds to complete removal..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    Restart-Computer -Force
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
}
