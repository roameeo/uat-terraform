# Fix DNS configuration using alternative method
# This script uses netsh instead of PowerShell cmdlets to avoid interface index issues

Write-Host "=== DNS Configuration Fix Script ===" -ForegroundColor Cyan
Write-Host ""

# Get the primary network adapter name
$adapter = Get-NetAdapter | Where-Object {$_.Status -eq "Up" -and $_.InterfaceDescription -like "*Hyper-V*"}
if (-not $adapter) {
    $adapter = Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object -First 1
}

Write-Host "Found network adapter: $($adapter.Name)" -ForegroundColor Green
Write-Host "Interface Alias: $($adapter.InterfaceAlias)" -ForegroundColor Green
Write-Host ""

# Configure DNS using netsh (more reliable than Set-DnsClientServerAddress)
Write-Host "Configuring DNS servers using netsh..." -ForegroundColor Yellow
$adapterName = $adapter.Name

# Set primary DNS
netsh interface ipv4 set dns name="$adapterName" static 10.48.2.4 primary
Write-Host "Primary DNS set to 10.48.2.4" -ForegroundColor Green

# Set secondary DNS
netsh interface ipv4 add dns name="$adapterName" 10.48.2.5 index=2
Write-Host "Secondary DNS set to 10.48.2.5" -ForegroundColor Green
Write-Host ""

# Flush DNS cache
Write-Host "Flushing DNS cache..." -ForegroundColor Yellow
ipconfig /flushdns | Out-Null
Write-Host "DNS cache flushed" -ForegroundColor Green
Write-Host ""

# Verify DNS configuration
Write-Host "=== DNS Configuration Verification ===" -ForegroundColor Cyan
$dnsServers = Get-DnsClientServerAddress -InterfaceAlias $adapter.InterfaceAlias -AddressFamily IPv4
Write-Host "Current DNS servers for interface $($adapter.InterfaceAlias):" -ForegroundColor Yellow
Write-Host $dnsServers.ServerAddresses -ForegroundColor White
Write-Host ""

# Test DNS resolution
Write-Host "=== Testing DNS Resolution ===" -ForegroundColor Cyan
Write-Host "Testing uat.local domain resolution..." -ForegroundColor Yellow
try {
    $result = nslookup uat.local 2>&1 | Out-String
    Write-Host $result -ForegroundColor White
    
    if ($result -match "10.48.2") {
        Write-Host "SUCCESS: DNS resolution working! uat.local resolves to domain controllers" -ForegroundColor Green
    } else {
        Write-Host "WARNING: DNS resolution may not be working correctly" -ForegroundColor Yellow
    }
} catch {
    Write-Host "ERROR: DNS resolution test failed: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Configuration Complete ===" -ForegroundColor Cyan
