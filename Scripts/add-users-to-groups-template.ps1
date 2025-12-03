# Add users to groups based on CSV data
Write-Host "=== Adding Users to Groups from CSV ===" -ForegroundColor Cyan
Write-Host ""

# User list will be embedded in the script
$usersJson = @'
USERS_JSON_PLACEHOLDER
'@

$users = $usersJson | ConvertFrom-Json

# Filter users that have groups
$usersWithGroups = $users | Where-Object { -not [string]::IsNullOrWhiteSpace($_.Groups) }

Write-Host "Processing $($usersWithGroups.Count) users with group memberships" -ForegroundColor Yellow
Write-Host ""

$addedCount = 0
$errorCount = 0
$groupsCreated = @{}
$groupsNotFound = @{}

foreach ($user in $usersWithGroups) {
    $samAccountName = $user.SamAccountName
    
    # Skip if no groups
    if ([string]::IsNullOrWhiteSpace($user.Groups)) {
        continue
    }
    
    # Check if user exists
    try {
        $adUser = Get-ADUser -Identity $samAccountName -ErrorAction Stop
    } catch {
        Write-Host "  User not found: $samAccountName" -ForegroundColor Yellow
        continue
    }
    
    # Parse groups (comma-separated)
    $groupNames = $user.Groups -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
    
    foreach ($groupName in $groupNames) {
        try {
            # Check if group exists
            $group = Get-ADGroup -Identity $groupName -ErrorAction Stop
            
            # Check if user is already a member
            $isMember = Get-ADGroupMember -Identity $groupName -Recursive | Where-Object { $_.SamAccountName -eq $samAccountName }
            
            if (-not $isMember) {
                Add-ADGroupMember -Identity $groupName -Members $samAccountName -ErrorAction Stop
                Write-Host "  Added: $samAccountName -> $groupName" -ForegroundColor Green
                $addedCount++
            }
            
        } catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            # Group doesn't exist
            if (-not $groupsNotFound.ContainsKey($groupName)) {
                $groupsNotFound[$groupName] = @()
            }
            $groupsNotFound[$groupName] += $samAccountName
            
        } catch {
            Write-Host "  ERROR: Failed to add $samAccountName to $groupName - $_" -ForegroundColor Red
            $errorCount++
        }
    }
}

Write-Host ""
Write-Host "=== Summary ===" -ForegroundColor Cyan
Write-Host "Memberships added: $addedCount" -ForegroundColor Green
Write-Host "Errors: $errorCount" -ForegroundColor Red
Write-Host ""

if ($groupsNotFound.Count -gt 0) {
    Write-Host "=== Groups Not Found (need to be created) ===" -ForegroundColor Yellow
    $groupsNotFound.Keys | Sort-Object | ForEach-Object {
        Write-Host "  $_ (needed by $($groupsNotFound[$_].Count) users)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=== Group Assignment Complete ===" -ForegroundColor Green
