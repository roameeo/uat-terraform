# Final verification of AD setup
Write-Host "=== Active Directory Final Status ===" -ForegroundColor Cyan
Write-Host ""

# Count total users
$totalUsers = (Get-ADUser -Filter *).Count
Write-Host "Total Users: $totalUsers" -ForegroundColor Green

# Count custom groups
$customGroups = Get-ADGroup -Filter * | Where-Object { $_.DistinguishedName -notlike "*,CN=Builtin,*" -and $_.DistinguishedName -notlike "*,CN=Users,DC=ForestDnsZones,*" -and $_.DistinguishedName -notlike "*,CN=Users,DC=DomainDnsZones,*" }
$customGroupCount = $customGroups.Count
Write-Host "Custom Groups: $customGroupCount" -ForegroundColor Green
Write-Host ""

# List custom groups with member counts
Write-Host "=== Custom Groups and Member Counts ===" -ForegroundColor Cyan
$customGroups | ForEach-Object {
    $memberCount = (Get-ADGroupMember -Identity $_.SamAccountName).Count
    Write-Host ("  {0,-45} : {1,3} members" -f $_.Name, $memberCount)
} | Sort-Object Name

Write-Host ""
Write-Host "=== Domain Admins ===" -ForegroundColor Cyan
Get-ADGroupMember -Identity "Domain Admins" | Select-Object Name, SamAccountName | Format-Table -AutoSize
