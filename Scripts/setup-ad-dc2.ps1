# Setup script for second domain controller (UATAD02)
# This script joins UATAD02 to the uat.local domain as a replica DC

Write-Host "Promoting UATAD02 as second domain controller..."

# Password for domain admin and safe mode
$Password = ConvertTo-SecureString "yF}8u{7PU0<Wio" -AsPlainText -Force
$DomainCred = New-Object System.Management.Automation.PSCredential("uat.local\terraform.adm", $Password)

# Install AD DS role
Write-Host "Installing AD DS Role..."
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Wait for installation to complete
Start-Sleep -Seconds 10

# Promote as domain controller (replica)
Write-Host "Promoting server to Domain Controller..."
Install-ADDSDomainController `
    -DomainName "uat.local" `
    -Credential $DomainCred `
    -InstallDns:$true `
    -SafeModeAdministratorPassword $Password `
    -Force:$true `
    -NoRebootOnCompletion:$false

Write-Host "AD DS installation complete. Server will reboot..."
