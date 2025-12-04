# Enable DNS Server Windows Firewall rules
Write-Host "=== Configuring Windows Firewall for DNS ===" -ForegroundColor Cyan
Write-Host ""

# Check current firewall status
Write-Host "Current Firewall Profile Status:" -ForegroundColor Yellow
Get-NetFirewallProfile | Select-Object Name, Enabled | Format-Table -AutoSize

# Get current DNS firewall rules
Write-Host "Current DNS Firewall Rules:" -ForegroundColor Yellow
Get-NetFirewallRule -DisplayName "*DNS*" | Where-Object {$_.Direction -eq 'Inbound'} | 
    Select-Object DisplayName, Enabled, Direction, Action | Format-Table -AutoSize

# Enable all DNS Server inbound rules
Write-Host "Enabling DNS Server firewall rules..." -ForegroundColor Yellow
try {
    Enable-NetFirewallRule -DisplayGroup "DNS Service"
    Write-Host "  DNS Service firewall rules enabled" -ForegroundColor Green
} catch {
    Write-Host "  Warning: Could not enable DNS Service group: $_" -ForegroundColor Yellow
}

# Check if we need to create custom rules
$udpRule = Get-NetFirewallRule -DisplayName "DNS-Server-UDP-In-Custom" -ErrorAction SilentlyContinue
if (-not $udpRule) {
    Write-Host "Creating custom DNS UDP rule..." -ForegroundColor Yellow
    New-NetFirewallRule -DisplayName "DNS-Server-UDP-In-Custom" -Direction Inbound -Protocol UDP -LocalPort 53 -Action Allow -Enabled True
    Write-Host "  Custom DNS UDP rule created" -ForegroundColor Green
} else {
    Set-NetFirewallRule -DisplayName "DNS-Server-UDP-In-Custom" -Enabled True
    Write-Host "  Custom DNS UDP rule enabled" -ForegroundColor Green
}

$tcpRule = Get-NetFirewallRule -DisplayName "DNS-Server-TCP-In-Custom" -ErrorAction SilentlyContinue
if (-not $tcpRule) {
    Write-Host "Creating custom DNS TCP rule..." -ForegroundColor Yellow
    New-NetFirewallRule -DisplayName "DNS-Server-TCP-In-Custom" -Direction Inbound -Protocol TCP -LocalPort 53 -Action Allow -Enabled True
    Write-Host "  Custom DNS TCP rule created" -ForegroundColor Green
} else {
    Set-NetFirewallRule -DisplayName "DNS-Server-TCP-In-Custom" -Enabled True
    Write-Host "  Custom DNS TCP rule enabled" -ForegroundColor Green
}

Write-Host ""
Write-Host "Updated DNS Firewall Rules:" -ForegroundColor Yellow
Get-NetFirewallRule | Where-Object {$_.DisplayName -like "*DNS*" -and $_.Direction -eq 'Inbound'} | 
    Select-Object DisplayName, Enabled, Direction, Action | Format-Table -AutoSize

Write-Host ""
Write-Host "Testing DNS service on port 53..." -ForegroundColor Yellow
$listening = Get-NetTCPConnection -LocalPort 53 -State Listen -ErrorAction SilentlyContinue
if ($listening) {
    Write-Host "DNS service is listening on TCP port 53" -ForegroundColor Green
} else {
    Write-Host "WARNING: DNS service not listening on TCP port 53" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Windows Firewall Configuration Complete ===" -ForegroundColor Green
