# List all domain-joined computers in Active Directory
Write-Host "=== Active Directory Computer Accounts ===" -ForegroundColor Cyan
Write-Host ""

try {
    $computers = Get-ADComputer -Filter * | Select-Object Name, DNSHostName, Enabled | Sort-Object Name
    
    Write-Host "Total computers in domain: $($computers.Count)" -ForegroundColor Yellow
    Write-Host ""
    
    $computers | Format-Table -AutoSize
    
    Write-Host ""
    Write-Host "Domain Controllers:" -ForegroundColor Yellow
    $dcs = $computers | Where-Object { $_.Name -like "*AD*" }
    $dcs | Format-Table -AutoSize
    
    Write-Host "Member Servers:" -ForegroundColor Yellow
    $members = $computers | Where-Object { $_.Name -notlike "*AD*" }
    $members | Format-Table -AutoSize
    
} catch {
    Write-Host "ERROR: Failed to query AD: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Query Complete ===" -ForegroundColor Cyan
