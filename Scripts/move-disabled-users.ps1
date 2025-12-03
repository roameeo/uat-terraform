# Move all disabled users to Disabled Users OU
Write-Host "=== Moving Disabled Users to Disabled Users OU ===" -ForegroundColor Cyan
Write-Host ""

# Define the Disabled Users OU path
$disabledOU = "OU=Disabled Users,DC=uat,DC=local"

# Check if Disabled Users OU exists, create if not
try {
    Get-ADOrganizationalUnit -Identity $disabledOU -ErrorAction Stop | Out-Null
    Write-Host "Disabled Users OU exists" -ForegroundColor Green
} catch {
    Write-Host "Creating Disabled Users OU..." -ForegroundColor Yellow
    New-ADOrganizationalUnit -Name "Disabled Users" -Path "DC=uat,DC=local"
    Write-Host "Disabled Users OU created" -ForegroundColor Green
}

Write-Host ""

# Get all disabled users not already in the Disabled Users OU
$disabledUsers = Get-ADUser -Filter {Enabled -eq $false} -Properties DistinguishedName | 
    Where-Object { $_.DistinguishedName -notlike "*OU=Disabled Users,DC=uat,DC=local" }

if ($disabledUsers.Count -eq 0) {
    Write-Host "No disabled users found to move" -ForegroundColor Gray
} else {
    Write-Host "Found $($disabledUsers.Count) disabled users to move" -ForegroundColor Yellow
    Write-Host ""
    
    $movedCount = 0
    $errorCount = 0
    
    foreach ($user in $disabledUsers) {
        try {
            Move-ADObject -Identity $user.DistinguishedName -TargetPath $disabledOU
            Write-Host "  Moved: $($user.SamAccountName)" -ForegroundColor Green
            $movedCount++
        } catch {
            Write-Host "  ERROR moving $($user.SamAccountName): $_" -ForegroundColor Red
            $errorCount++
        }
    }
    
    Write-Host ""
    Write-Host "=== Summary ===" -ForegroundColor Cyan
    Write-Host "Users moved: $movedCount" -ForegroundColor Green
    Write-Host "Errors: $errorCount" -ForegroundColor $(if ($errorCount -gt 0) { "Red" } else { "Green" })
}

Write-Host ""
Write-Host "=== Complete ===" -ForegroundColor Green
