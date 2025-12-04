# Disable IPv6 on all network adapters
Write-Host "=== Disabling IPv6 ===" -ForegroundColor Cyan
Write-Host ""

# Get all network adapters
$adapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}

foreach ($adapter in $adapters) {
    Write-Host "Disabling IPv6 on: $($adapter.Name)" -ForegroundColor Yellow
    try {
        Disable-NetAdapterBinding -Name $adapter.Name -ComponentID ms_tcpip6 -Confirm:$false
        Write-Host "  IPv6 disabled on $($adapter.Name)" -ForegroundColor Green
    } catch {
        Write-Host "  Warning: $_" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Current IPv6 Status:" -ForegroundColor Yellow
Get-NetAdapterBinding -ComponentID ms_tcpip6 | Select-Object Name, DisplayName, Enabled | Format-Table -AutoSize

Write-Host ""
Write-Host "Flushing DNS cache..." -ForegroundColor Yellow
ipconfig /flushdns | Out-Null
Write-Host "DNS cache flushed" -ForegroundColor Green

Write-Host ""
Write-Host "=== IPv6 Disabled ===" -ForegroundColor Green
