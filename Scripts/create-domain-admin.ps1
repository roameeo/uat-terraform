# Create terraform.adm domain admin account in uat.local

$DomainName = "uat.local"
$Username = "terraform.adm"
$Password = ConvertTo-SecureString "yF}8u{7PU0<Wio" -AsPlainText -Force

Write-Host "Creating domain admin account: $Username" -ForegroundColor Cyan

# Import AD module
Import-Module ActiveDirectory

# Create user
New-ADUser `
    -Name $Username `
    -SamAccountName $Username `
    -UserPrincipalName "$Username@$DomainName" `
    -AccountPassword $Password `
    -Enabled $true `
    -PasswordNeverExpires $true `
    -ChangePasswordAtLogon $false `
    -Description "Terraform Domain Admin Account"

Write-Host "Adding $Username to Domain Admins group..." -ForegroundColor Cyan
Add-ADGroupMember -Identity "Domain Admins" -Members $Username

Write-Host "Adding $Username to Enterprise Admins group..." -ForegroundColor Cyan
Add-ADGroupMember -Identity "Enterprise Admins" -Members $Username

Write-Host "Domain admin account created successfully!" -ForegroundColor Green
Write-Host "Username: $DomainName\$Username" -ForegroundColor Yellow
