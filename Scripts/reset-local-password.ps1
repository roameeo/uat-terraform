# Reset local admin password on VM using run-command
param(
    [Parameter(Mandatory=$true)]
    [string]$NewPassword
)

Write-Host "Resetting azadmin password..." -ForegroundColor Yellow

try {
    # Reset the password
    $securePassword = ConvertTo-SecureString $NewPassword -AsPlainText -Force
    Set-LocalUser -Name "azadmin" -Password $securePassword -PasswordNeverExpires $true
    
    Write-Host "SUCCESS: Password reset for azadmin" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to reset password: $_" -ForegroundColor Red
    exit 1
}
