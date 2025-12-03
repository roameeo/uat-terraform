# Create awill.adm domain admin account
Write-Host "=== Creating Domain Admin Account ===" -ForegroundColor Cyan
Write-Host ""

$username = "awill.adm"
$password = "ChangeMe2SomethingElse!"
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force

try {
    # Check if user already exists
    $existingUser = Get-ADUser -Identity $username -ErrorAction Stop
    Write-Host "User $username already exists, updating password..." -ForegroundColor Yellow
    Set-ADAccountPassword -Identity $username -NewPassword $securePassword -Reset
    Set-ADUser -Identity $username -ChangePasswordAtLogon $true
    Write-Host "Password updated for $username" -ForegroundColor Green
} catch {
    # User doesn't exist, create it
    Write-Host "Creating user: $username" -ForegroundColor Yellow
    New-ADUser -Name "awill.adm" `
               -SamAccountName $username `
               -UserPrincipalName "$username@uat.local" `
               -AccountPassword $securePassword `
               -Enabled $true `
               -ChangePasswordAtLogon $true `
               -PasswordNeverExpires $false
    Write-Host "User created: $username" -ForegroundColor Green
}

# Add to Domain Admins
Write-Host "Adding $username to Domain Admins..." -ForegroundColor Yellow
try {
    Add-ADGroupMember -Identity "Domain Admins" -Members $username -ErrorAction Stop
    Write-Host "Added to Domain Admins" -ForegroundColor Green
} catch {
    if ($_.Exception.Message -like "*already a member*") {
        Write-Host "Already member of Domain Admins" -ForegroundColor Gray
    } else {
        Write-Host "ERROR adding to Domain Admins: $_" -ForegroundColor Red
    }
}

# Add to Enterprise Admins
Write-Host "Adding $username to Enterprise Admins..." -ForegroundColor Yellow
try {
    Add-ADGroupMember -Identity "Enterprise Admins" -Members $username -ErrorAction Stop
    Write-Host "Added to Enterprise Admins" -ForegroundColor Green
} catch {
    if ($_.Exception.Message -like "*already a member*") {
        Write-Host "Already member of Enterprise Admins" -ForegroundColor Gray
    } else {
        Write-Host "ERROR adding to Enterprise Admins: $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=== Domain Admin Account Ready ===" -ForegroundColor Green
Write-Host "Username: $username" -ForegroundColor Cyan
Write-Host "Password: $password" -ForegroundColor Cyan
Write-Host "Must change password at next logon: Yes" -ForegroundColor Cyan
