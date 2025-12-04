# Diagnose domain connectivity issues
Write-Host "=== Domain Connectivity Diagnostics ===" -ForegroundColor Cyan
Write-Host ""

# Check computer name and domain membership
$computerInfo = Get-ComputerInfo | Select-Object CsName, CsDomain, CsDomainRole
Write-Host "Computer Name: $($computerInfo.CsName)" -ForegroundColor Yellow
Write-Host "Domain: $($computerInfo.CsDomain)" -ForegroundColor Yellow
Write-Host "Domain Role: $($computerInfo.CsDomainRole)" -ForegroundColor Yellow
Write-Host ""

# Test domain controller connectivity
Write-Host "=== Testing Domain Controller Connectivity ===" -ForegroundColor Cyan
$dcs = @("UATAD01", "UATAD02", "10.48.2.4", "10.48.2.5")
foreach ($dc in $dcs) {
    $result = Test-Connection -ComputerName $dc -Count 2 -Quiet
    if ($result) {
        Write-Host "  $dc : Reachable" -ForegroundColor Green
    } else {
        Write-Host "  $dc : NOT Reachable" -ForegroundColor Red
    }
}
Write-Host ""

# Check DNS configuration
Write-Host "=== DNS Configuration ===" -ForegroundColor Cyan
$dnsServers = Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*"}
foreach ($adapter in $dnsServers) {
    Write-Host "Adapter: $($adapter.InterfaceAlias)" -ForegroundColor Yellow
    Write-Host "  DNS Servers: $($adapter.ServerAddresses -join ', ')" -ForegroundColor White
}
Write-Host ""

# Test DNS resolution
Write-Host "=== Testing DNS Resolution ===" -ForegroundColor Cyan
$dnsTests = @("uat.local", "UATAD01.uat.local", "UATAD02.uat.local")
foreach ($name in $dnsTests) {
    try {
        $result = Resolve-DnsName -Name $name -ErrorAction Stop
        Write-Host "  $name : Resolved to $($result.IPAddress -join ', ')" -ForegroundColor Green
    } catch {
        Write-Host "  $name : FAILED to resolve" -ForegroundColor Red
    }
}
Write-Host ""

# Check secure channel
Write-Host "=== Testing Secure Channel to Domain ===" -ForegroundColor Cyan
try {
    $secureChannel = Test-ComputerSecureChannel -Verbose
    if ($secureChannel) {
        Write-Host "Secure channel: OK" -ForegroundColor Green
    } else {
        Write-Host "Secure channel: BROKEN" -ForegroundColor Red
    }
} catch {
    Write-Host "Secure channel test failed: $_" -ForegroundColor Red
}
Write-Host ""

# Check domain controller availability via nltest
Write-Host "=== Checking Domain Controller with NLTEST ===" -ForegroundColor Cyan
$nltest = nltest /dsgetdc:uat.local 2>&1
Write-Host $nltest

Write-Host ""
Write-Host "=== Diagnostics Complete ===" -ForegroundColor Green
