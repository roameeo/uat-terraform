# List all Active Directory users
Write-Host "=== Active Directory Users ===" -ForegroundColor Cyan
Write-Host ""

try {
    $users = Get-ADUser -Filter * -Properties Name, SamAccountName, Enabled, Created, PasswordLastSet, LastLogonDate | 
             Select-Object Name, SamAccountName, Enabled, Created, PasswordLastSet, LastLogonDate |
             Sort-Object Name
    
    Write-Host "Total users in domain: $($users.Count)" -ForegroundColor Yellow
    Write-Host ""
    
    $users | Format-Table -AutoSize
    
    Write-Host ""
    Write-Host "Enabled users: $(($users | Where-Object { $_.Enabled -eq $true }).Count)" -ForegroundColor Green
    Write-Host "Disabled users: $(($users | Where-Object { $_.Enabled -eq $false }).Count)" -ForegroundColor Yellow
    
} catch {
    Write-Host "ERROR: Failed to query AD users: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Query Complete ===" -ForegroundColor Cyan
