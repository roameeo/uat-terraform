# Update AD Users from CSV - Only update UPN for existing users
Write-Host "=== Updating AD User UPNs from CSV ===" -ForegroundColor Cyan
Write-Host ""

# Read CSV from local copy (will be uploaded via Storage Account)
$csvFile = "C:\Windows\Temp\importusers.csv"

# Download CSV from URL passed as parameter
$csvUrl = $args[0]
try {
    Invoke-WebRequest -Uri $csvUrl -OutFile $csvFile -UseBasicParsing
    Write-Host "CSV downloaded successfully" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to download CSV: $_" -ForegroundColor Red
    exit 1
}

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
        $skippedCount++
        continue
    }
    
    # Check if user exists
    try {
        $adUser = Get-ADUser -Identity $samAccountName -Properties UserPrincipalName -ErrorAction Stop
        
        # Only update if UPN is different
        if ($adUser.UserPrincipalName -ne $newUPN) {
            Set-ADUser -Identity $samAccountName -UserPrincipalName $newUPN
            Write-Host "  Updated: $samAccountName -> $newUPN" -ForegroundColor Green
            $updatedCount++
        } else {
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
Write-Host "Skipped: $skippedCount" -ForegroundColor Gray
Write-Host "Not found: $notFoundCount" -ForegroundColor Yellow
Write-Host ""

# Clean up
Remove-Item -Path $csvFile -Force
