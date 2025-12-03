# Update Key Vault secrets with existing VM passwords

$passwords = @{
    "UATAD01"    = "]w/Y6'R$+Bno_w?IdRsQ}s#_w#6pJ6l`""
    "UATAD02"    = "hNVxQV>:Y&_4/PFn~1BYp9?>@h3?w``6N"
    "UATIIS01"   = "I$)U@A_.],n!;{zK1YQV~n=IR5h+6#[U"
    "UATMULTI01" = "I$)U@A_.],n!;{zK1YQV~n=IR5h+6#[U"
    "UATATLAS01" = "3mANP^1XN3mWm4Ue?=H4juW[kOg#N5Vj"
    "UATSQL01"   = "AI$9!Z%x1q#iRn73"
}

Write-Host "Updating VM passwords in Key Vault..." -ForegroundColor Cyan
Write-Host ""

foreach ($vm in $passwords.Keys) {
    Write-Host "Updating $vm..." -ForegroundColor Yellow
    $pwd = $passwords[$vm]
    $pwd | Out-File -FilePath temp_pwd.txt -NoNewline -Encoding utf8
    az keyvault secret set --vault-name CUS-UAT-KEYVAULT --name $vm --file temp_pwd.txt --output none
    Remove-Item temp_pwd.txt
    Write-Host "  ✓ $vm password updated" -ForegroundColor Green
}

Write-Host ""
Write-Host "All VM passwords updated in Key Vault!" -ForegroundColor Green
