# Update AD Users from CSV - Only update UPN for existing users
Write-Host "=== Updating AD User UPNs from CSV ===" -ForegroundColor Cyan
Write-Host ""

# The CSV will be passed as base64 encoded content
$csvContent = $args[0]
$csvBytes = [System.Convert]::FromBase64String($csvContent)
$csvText = [System.Text.Encoding]::UTF8.GetString($csvBytes)
$csvFile = "C:\Windows\Temp\importusers.csv"
$csvText | Out-File -FilePath $csvFile -Encoding UTF8

# Import CSV
$users = Import-Csv -Path $csvFile

Write-Host "Total users in CSV: $($users.Count)" -ForegroundColor Yellow
Write-Host ""

$updatedCount = 0
$skippedCount = 0
$notFoundCount = 0

foreach ($user in $users) {
    $samAccountName = $user.SamAccountName
    $newUPN = $user.UserPrincipalName
    
    # Skip if no UPN provided
    if ([string]::IsNullOrWhiteSpace($newUPN)) {
        Write-Host "  Skipped: $samAccountName (no UPN in CSV)" -ForegroundColor Gray
        $skippedCount++
        continue
    }
    
    # Check if user exists
    try {
        $adUser = Get-ADUser -Identity $samAccountName -Properties UserPrincipalName -ErrorAction Stop
        
        # Only update if UPN is different
        if ($adUser.UserPrincipalName -ne $newUPN) {
            Set-ADUser -Identity $samAccountName -UserPrincipalName $newUPN
            Write-Host "  Updated: $samAccountName - UPN changed from '$($adUser.UserPrincipalName)' to '$newUPN'" -ForegroundColor Green
            $updatedCount++
        } else {
            Write-Host "  Skipped: $samAccountName (UPN already correct)" -ForegroundColor Gray
            $skippedCount++
        }
        
    } catch {
        Write-Host "  Not Found: $samAccountName" -ForegroundColor Yellow
        $notFoundCount++
    }
}

Write-Host ""
Write-Host "=== Update Summary ===" -ForegroundColor Cyan
Write-Host "Total users in CSV: $($users.Count)" -ForegroundColor White
Write-Host "Updated: $updatedCount" -ForegroundColor Green
Write-Host "Skipped (no change needed or no UPN): $skippedCount" -ForegroundColor Gray
Write-Host "Not found in AD: $notFoundCount" -ForegroundColor Yellow
Write-Host ""
Write-Host "=== UPN Update Complete ===" -ForegroundColor Green

# Clean up
Remove-Item -Path $csvFile -Force
