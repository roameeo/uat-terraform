# Configure UATAD02 to use UATAD01 as DNS before domain join
Write-Host "Configuring DNS to point to UATAD01 (10.48.2.4)..."

# Get the network adapter
$Adapter = Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object -First 1

# Set DNS server to UATAD01
Set-DnsClientServerAddress -InterfaceIndex $Adapter.ifIndex -ServerAddresses "10.48.2.4"

Write-Host "DNS configured successfully"
Write-Host "Current DNS settings:"
Get-DnsClientServerAddress -InterfaceIndex $Adapter.ifIndex -AddressFamily IPv4

# Test DNS resolution
Write-Host "`nTesting DNS resolution for uat.local..."
nslookup uat.local

Write-Host "`nDNS configuration complete!"
