# Import AD Users from CSV
Write-Host "=== Importing AD Users from CSV ===" -ForegroundColor Cyan
Write-Host ""

# User list will be embedded in the script
$usersJson = @'
USERS_JSON_PLACEHOLDER
'@

$users = $usersJson | ConvertFrom-Json

Write-Host "Total users to process: $($users.Count)" -ForegroundColor Yellow
Write-Host ""

$createdCount = 0
$existingCount = 0
$errorCount = 0
$defaultPassword = ConvertTo-SecureString "ChangeMe123!" -AsPlainText -Force

foreach ($user in $users) {
    $samAccountName = $user.SamAccountName
    
    # Skip if no SamAccountName
    if ([string]::IsNullOrWhiteSpace($samAccountName)) {
        continue
    }
    
    # Check if user exists
    try {
        $existingUser = Get-ADUser -Identity $samAccountName -ErrorAction Stop
        Write-Host "  Exists: $samAccountName" -ForegroundColor Gray
        $existingCount++
        continue
    } catch {
        # User doesn't exist, create it
    }
    
    # Prepare UPN
    $upn = $user.UserPrincipalName
    if ([string]::IsNullOrWhiteSpace($upn)) {
        $upn = "$samAccountName@uat.local"
    }
    
    # Prepare display name
    $displayName = if ([string]::IsNullOrWhiteSpace($user.Name)) { $samAccountName } else { $user.Name.Trim() }
    
    # Determine if account should be enabled
    $enabled = $user.Enabled -eq "TRUE" -or $user.Enabled -eq "True"
    
    try {
        New-ADUser -Name $displayName `
                   -SamAccountName $samAccountName `
                   -UserPrincipalName $upn `
                   -AccountPassword $defaultPassword `
                   -Enabled $enabled `
                   -PasswordNeverExpires $false `
                   -ChangePasswordAtLogon $true
        
        Write-Host "  Created: $samAccountName ($displayName)" -ForegroundColor Green
        $createdCount++
    } catch {
        Write-Host "  ERROR: Failed to create $samAccountName - $_" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host ""
Write-Host "=== Import Summary ===" -ForegroundColor Cyan
Write-Host "Total processed: $($users.Count)" -ForegroundColor White
Write-Host "Created: $createdCount" -ForegroundColor Green
Write-Host "Already existed: $existingCount" -ForegroundColor Gray
Write-Host "Errors: $errorCount" -ForegroundColor Red
Write-Host ""
Write-Host "=== Import Complete ===" -ForegroundColor Green
Write-Host "Note: New users have default password 'ChangeMe123!' and must change at next logon" -ForegroundColor Yellow
