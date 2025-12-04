# Repair broken secure channel to domain
Write-Host "=== Repairing Domain Secure Channel ===" -ForegroundColor Cyan
Write-Host ""

# Get domain admin credentials from Key Vault secret
Write-Host "Using terraform.adm domain admin account..." -ForegroundColor Yellow

try {
    # Test and repair secure channel
    Write-Host "Testing secure channel..." -ForegroundColor Yellow
    $testResult = Test-ComputerSecureChannel
    
    if (-not $testResult) {
        Write-Host "Secure channel is broken. Attempting repair..." -ForegroundColor Red
        
        # Repair using the computer account
        $repairResult = Test-ComputerSecureChannel -Repair -Verbose
        
        if ($repairResult) {
            Write-Host "Secure channel repaired successfully!" -ForegroundColor Green
        } else {
            Write-Host "Failed to repair secure channel automatically" -ForegroundColor Red
            Write-Host "Attempting to re-register DNS..." -ForegroundColor Yellow
            ipconfig /registerdns
            
            Write-Host "Restarting Netlogon service..." -ForegroundColor Yellow
            Restart-Service Netlogon -Force
            
            # Test again
            Start-Sleep -Seconds 5
            $finalTest = Test-ComputerSecureChannel
            if ($finalTest) {
                Write-Host "Secure channel repaired after service restart!" -ForegroundColor Green
            } else {
                Write-Host "Secure channel still broken. May need to rejoin domain." -ForegroundColor Red
            }
        }
    } else {
        Write-Host "Secure channel is already healthy!" -ForegroundColor Green
    }
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Complete ===" -ForegroundColor Green
