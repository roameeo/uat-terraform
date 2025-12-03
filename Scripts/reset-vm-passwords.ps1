# Reset VM passwords to match Key Vault secrets
$vms = @('UATAD01', 'UATAD02', 'UATATLAS01', 'UATIIS01', 'UATMULTI01', 'UATSQL01')
$resourceGroup = 'UATSERVERRG'

Write-Host "Resetting VM passwords to match Key Vault secrets..." -ForegroundColor Cyan
Write-Host ""

foreach ($vm in $vms) {
    Write-Host "Processing $vm..." -ForegroundColor Yellow
    
    # Get password from Key Vault
    $password = az keyvault secret show --vault-name CUS-UAT-KEYVAULT --name $vm --query "value" -o tsv
    
    if ($password) {
        # Reset VM password
        Write-Host "  Resetting password for azadmin on $vm..." -ForegroundColor Yellow
        az vm user update --resource-group $resourceGroup --name $vm --username azadmin --password $password --output none
        
        Write-Host "  ✓ Password reset for $vm" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Failed to get password from Key Vault for $vm" -ForegroundColor Red
    }
    
    Write-Host ""
}

Write-Host "All VM passwords have been reset to match Key Vault" -ForegroundColor Green
Write-Host ""
Write-Host "You can now access VMs using:" -ForegroundColor Cyan
Write-Host "  Username: azadmin" -ForegroundColor White
Write-Host "  Password: [Retrieved from Key Vault secret matching VM name]" -ForegroundColor White
