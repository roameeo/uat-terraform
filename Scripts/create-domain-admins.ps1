# Create Domain Admin Accounts
Write-Host "=== Creating Domain Admin Accounts ===" -ForegroundColor Cyan
Write-Host ""

# Define admin accounts
$admins = @(
    @{
        Name = "terraform.adm"
        Password = '3NNz[YQy[,""2J(Ab=w?vxd|0L;!u#61'
        Description = "Terraform Service Account"
    },
    @{
        Name = "swinters.adm"
        Password = '&P,Ivifl0"%Y,v''uM&8as2|{SojuR8mI'
        Description = "Stormy Winters Admin Account"
    },
    @{
        Name = "stjohnson.adm"
        Password = 'ChangeMe2SomethingElse!'
        Description = "Sam Johnson Admin Account"
    },
    @{
        Name = "aphillips.adm"
        Password = 'ChangeMe2SomethingElse!'
        Description = "Alex Phillips Admin Account"
    }
)

foreach ($admin in $admins) {
    Write-Host "Processing: $($admin.Name)" -ForegroundColor Yellow
    
    # Check if user already exists
    $existingUser = $null
    try {
        $existingUser = Get-ADUser -Identity $admin.Name -ErrorAction SilentlyContinue
    } catch {
        # User doesn't exist, which is fine
    }
    
    if ($existingUser) {
        Write-Host "  User $($admin.Name) already exists" -ForegroundColor Green
        
        # Reset password for existing user
        $securePassword = ConvertTo-SecureString $admin.Password -AsPlainText -Force
        Set-ADAccountPassword -Identity $admin.Name -NewPassword $securePassword -Reset
        Set-ADUser -Identity $admin.Name -ChangePasswordAtLogon $false
        Write-Host "  Password updated for $($admin.Name)" -ForegroundColor Green
        
        # Ensure they're in Domain Admins and Enterprise Admins
        Add-ADGroupMember -Identity "Domain Admins" -Members $admin.Name -ErrorAction SilentlyContinue
        Add-ADGroupMember -Identity "Enterprise Admins" -Members $admin.Name -ErrorAction SilentlyContinue
        Write-Host "  Group memberships verified for $($admin.Name)" -ForegroundColor Green
        
    } else {
        Write-Host "  Creating new user: $($admin.Name)" -ForegroundColor Yellow
        
        # Create new user
        $securePassword = ConvertTo-SecureString $admin.Password -AsPlainText -Force
        
        New-ADUser -Name $admin.Name `
                   -SamAccountName $admin.Name `
                   -UserPrincipalName "$($admin.Name)@uat.local" `
                   -AccountPassword $securePassword `
                   -Enabled $true `
                   -PasswordNeverExpires $true `
                   -ChangePasswordAtLogon $false `
                   -Description $admin.Description
        
        Write-Host "  User created: $($admin.Name)" -ForegroundColor Green
        
        # Add to Domain Admins and Enterprise Admins groups
        Add-ADGroupMember -Identity "Domain Admins" -Members $admin.Name
        Add-ADGroupMember -Identity "Enterprise Admins" -Members $admin.Name
        
        Write-Host "  Added $($admin.Name) to Domain Admins and Enterprise Admins" -ForegroundColor Green
    }
    
    Write-Host ""
}

Write-Host "=== Summary of Domain Admin Accounts ===" -ForegroundColor Cyan
Write-Host ""

# List all domain admin accounts
$domainAdmins = Get-ADGroupMember -Identity "Domain Admins" | 
                Get-ADUser -Properties Enabled, Description | 
                Select-Object Name, SamAccountName, Enabled, Description |
                Sort-Object Name

$domainAdmins | Format-Table -AutoSize

Write-Host ""
Write-Host "Total Domain Admins: $($domainAdmins.Count)" -ForegroundColor Yellow
Write-Host ""
Write-Host "=== Domain Admin Account Creation Complete ===" -ForegroundColor Green
