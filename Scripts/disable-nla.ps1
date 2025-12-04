# Disable Network Level Authentication (NLA) on Remote Desktop
Write-Host "=== Disabling NLA on Remote Desktop ===" -ForegroundColor Cyan
Write-Host ""

# Registry path for Terminal Services
$registryPath = "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"

try {
    # Check current NLA setting
    $currentValue = Get-ItemProperty -Path $registryPath -Name "UserAuthentication" -ErrorAction Stop
    Write-Host "Current NLA setting: $($currentValue.UserAuthentication)" -ForegroundColor Yellow
    
    if ($currentValue.UserAuthentication -eq 0) {
        Write-Host "NLA is already disabled" -ForegroundColor Green
    } else {
        # Disable NLA
        Set-ItemProperty -Path $registryPath -Name "UserAuthentication" -Value 0
        Write-Host "NLA has been disabled" -ForegroundColor Green
        Write-Host "Note: A reboot may be required for changes to take full effect" -ForegroundColor Yellow
    }
    
    # Verify the change
    $newValue = Get-ItemProperty -Path $registryPath -Name "UserAuthentication"
    Write-Host ""
    Write-Host "New NLA setting: $($newValue.UserAuthentication) (0 = Disabled, 1 = Enabled)" -ForegroundColor Cyan
    
} catch {
    Write-Host "ERROR: Failed to disable NLA - $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Complete ===" -ForegroundColor Green
