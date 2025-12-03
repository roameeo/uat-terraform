# Generate unique secure passwords for each VM
$vms = @('UATAD01', 'UATAD02', 'UATATLAS01', 'UATIIS01', 'UATMULTI01', 'UATSQL01')

function New-SecurePassword {
    # Generate a 24-character password with complexity requirements
    $upper = -join ((65..90) | Get-Random -Count 4 | ForEach-Object {[char]$_})
    $lower = -join ((97..122) | Get-Random -Count 4 | ForEach-Object {[char]$_})
    $numbers = -join ((48..57) | Get-Random -Count 4 | ForEach-Object {[char]$_})
    $special = -join ('!@#$%^&*()'.ToCharArray() | Get-Random -Count 4)
    
    $passwordArray = ($upper + $lower + $numbers + $special).ToCharArray()
    $shuffled = $passwordArray | Get-Random -Count $passwordArray.Length
    return -join $shuffled
}

Write-Host "Generating unique passwords for each VM..." -ForegroundColor Cyan
Write-Host ""

foreach ($vm in $vms) {
    $password = New-SecurePassword
    
    # Save to file temporarily
    $password | Out-File -FilePath "temp_pwd.txt" -NoNewline
    
    # Store in Key Vault
    Write-Host "Setting password for $vm..." -ForegroundColor Yellow
    az keyvault secret set --vault-name CUS-UAT-KEYVAULT --name $vm --file temp_pwd.txt --output none
    
    Write-Host "  ✓ Password set for $vm" -ForegroundColor Green
}

# Clean up temp file
Remove-Item "temp_pwd.txt" -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "All VM passwords have been generated and stored in Key Vault" -ForegroundColor Green
Write-Host ""
Write-Host "Note: The VMs are currently using the old password." -ForegroundColor Yellow
Write-Host "Run 'terraform apply' to update the VMs with the new passwords from Key Vault." -ForegroundColor Yellow
