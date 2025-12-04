# Create DNS zones on domain controller
Write-Host "=== Creating DNS Zones ===" -ForegroundColor Cyan
Write-Host ""

# Check if DNS Server role is installed
$dnsService = Get-Service -Name DNS -ErrorAction SilentlyContinue
if (-not $dnsService) {
    Write-Host "ERROR: DNS Server service not found!" -ForegroundColor Red
    exit 1
}

Write-Host "DNS Service Status: $($dnsService.Status)" -ForegroundColor Yellow
Write-Host ""

# Create Forward Lookup Zone for uat.local
Write-Host "Creating Forward Lookup Zone for uat.local..." -ForegroundColor Yellow
try {
    $existingZone = Get-DnsServerZone -Name "uat.local" -ErrorAction SilentlyContinue
    if ($existingZone) {
        Write-Host "  Forward zone uat.local already exists" -ForegroundColor Gray
    } else {
        Add-DnsServerPrimaryZone -Name "uat.local" -ReplicationScope "Forest" -DynamicUpdate "Secure"
        Write-Host "  Forward zone uat.local created" -ForegroundColor Green
    }
} catch {
    Write-Host "  ERROR creating forward zone: $_" -ForegroundColor Red
}

# Create Reverse Lookup Zone for 10.48.2.0/24
Write-Host "Creating Reverse Lookup Zone for 10.48.2.0/24..." -ForegroundColor Yellow
try {
    $reverseZoneName = "2.48.10.in-addr.arpa"
    $existingReverse = Get-DnsServerZone -Name $reverseZoneName -ErrorAction SilentlyContinue
    if ($existingReverse) {
        Write-Host "  Reverse zone $reverseZoneName already exists" -ForegroundColor Gray
    } else {
        Add-DnsServerPrimaryZone -NetworkId "10.48.2.0/24" -ReplicationScope "Forest" -DynamicUpdate "Secure"
        Write-Host "  Reverse zone $reverseZoneName created" -ForegroundColor Green
    }
} catch {
    Write-Host "  ERROR creating reverse zone: $_" -ForegroundColor Red
}

# Create Reverse Lookup Zone for 10.48.3.0/24 (DMZ)
Write-Host "Creating Reverse Lookup Zone for 10.48.3.0/24..." -ForegroundColor Yellow
try {
    $reverseZoneName = "3.48.10.in-addr.arpa"
    $existingReverse = Get-DnsServerZone -Name $reverseZoneName -ErrorAction SilentlyContinue
    if ($existingReverse) {
        Write-Host "  Reverse zone $reverseZoneName already exists" -ForegroundColor Gray
    } else {
        Add-DnsServerPrimaryZone -NetworkId "10.48.3.0/24" -ReplicationScope "Forest" -DynamicUpdate "Secure"
        Write-Host "  Reverse zone $reverseZoneName created" -ForegroundColor Green
    }
} catch {
    Write-Host "  ERROR creating reverse zone: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Registering Domain Controller DNS Records ===" -ForegroundColor Cyan
ipconfig /registerdns | Out-Null
Write-Host "DNS records registered" -ForegroundColor Green

Write-Host ""
Write-Host "=== Current DNS Zones ===" -ForegroundColor Cyan
Get-DnsServerZone | Select-Object ZoneName, ZoneType, DynamicUpdate, IsAutoCreated | Format-Table -AutoSize

Write-Host ""
Write-Host "=== DNS Zone Creation Complete ===" -ForegroundColor Green
