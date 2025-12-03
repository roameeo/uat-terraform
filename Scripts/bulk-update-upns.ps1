# Bulk Update UPNs - Simple approach
Write-Host "=== Updating All User UPNs to @uat.local ===" -ForegroundColor Cyan
Write-Host ""

# Get all AD users (excluding built-in accounts)
$users = Get-ADUser -Filter * -Properties UserPrincipalName, SamAccountName |
         Where-Object { $_.SamAccountName -notlike "krbtgt" -and 
                       $_.SamAccountName -notlike "Guest" -and
                       $_.UserPrincipalName -notlike "*@uat.local" }

Write-Host "Found $($users.Count) users with non-uat.local UPNs" -ForegroundColor Yellow
Write-Host ""

$updatedCount = 0

foreach ($user in $users) {
    $newUPN = "$($user.SamAccountName)@uat.local"
    
    try {
        Set-ADUser -Identity $user.SamAccountName -UserPrincipalName $newUPN
        Write-Host "  Updated: $($user.SamAccountName) -> $newUPN" -ForegroundColor Green
        $updatedCount++
    } catch {
        Write-Host "  ERROR: Failed to update $($user.SamAccountName): $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=== Summary ===" -ForegroundColor Cyan
Write-Host "Total updated: $updatedCount" -ForegroundColor Green
Write-Host ""
Write-Host "=== Update Complete ===" -ForegroundColor Green
