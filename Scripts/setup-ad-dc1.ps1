# Install Active Directory Domain Services on UATAD01 (First Domain Controller)
# This script promotes UATAD01 as the first DC in a new forest: uat.local

# Set variables
$DomainName = "uat.local"
$NetBiosName = "UAT"
$SafeModePassword = ConvertTo-SecureString "yF}8u{7PU0<Wio" -AsPlainText -Force

Write-Host "Installing AD DS Role..." -ForegroundColor Cyan
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Write-Host "Promoting server to Domain Controller..." -ForegroundColor Cyan
Write-Host "Domain: $DomainName" -ForegroundColor Yellow
Write-Host "This will take several minutes and require a reboot..." -ForegroundColor Yellow

Install-ADDSForest `
    -DomainName $DomainName `
    -DomainNetbiosName $NetBiosName `
    -ForestMode "WinThreshold" `
    -DomainMode "WinThreshold" `
    -InstallDns:$true `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -LogPath "C:\Windows\NTDS" `
    -SysvolPath "C:\Windows\SYSVOL" `
    -SafeModeAdministratorPassword $SafeModePassword `
    -Force:$true `
    -NoRebootOnCompletion:$false

Write-Host "AD DS installation complete. Server will reboot..." -ForegroundColor Green
