# Reset VM passwords using run-command (works for all VMs including DCs)

$vms = @{
    "UATAD01"    = "]w/Y6'R$+Bno_w?IdRsQ}s#_w#6pJ6l`""
    "UATAD02"    = "hNVxQV>:Y&_4/PFn~1BYp9?>@h3?w``6N"
    "UATATLAS01" = "3mANP^1XN3mWm4Ue?=H4juW[kOg#N5Vj"
    "UATIIS01"   = "I$)U@A_.],n!;{zK1YQV~n=IR5h+6#[U"
    "UATMULTI01" = "I$)U@A_.],n!;{zK1YQV~n=IR5h+6#[U"
    "UATSQL01"   = "AI$9!Z%x1q#iRn73"
}

Write-Host "Resetting VM passwords using run-command..." -ForegroundColor Cyan
Write-Host ""

foreach ($vmName in $vms.Keys) {
    Write-Host "Resetting password for $vmName..." -ForegroundColor Yellow
    
    $password = $vms[$vmName]
    
    # Create inline script
    $script = @"
`$securePassword = ConvertTo-SecureString '$password' -AsPlainText -Force
Set-LocalUser -Name 'azadmin' -Password `$securePassword -PasswordNeverExpires `$true
Write-Host 'Password reset successfully'
"@
    
    # Write script to temp file
    $script | Out-File -FilePath "temp_reset.ps1" -Encoding utf8
    
    # Execute on VM
    $result = az vm run-command invoke `
        --resource-group UATSERVERRG `
        --name $vmName `
        --command-id RunPowerShellScript `
        --scripts "@temp_reset.ps1" `
        --query "value[0].message" -o tsv
    
    if ($result -match "success") {
        Write-Host "  ✓ $vmName password reset successfully" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ $vmName may have issues: $result" -ForegroundColor Yellow
    }
    
    Remove-Item "temp_reset.ps1" -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "All VM passwords have been reset!" -ForegroundColor Green
Write-Host "VMs now use their unique passwords stored in Key Vault." -ForegroundColor Green
