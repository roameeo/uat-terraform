# Script to re-run domain join on AVD session hosts
# This uses Azure VM Run Command to execute domain join remotely

param(
    [Parameter(Mandatory=$true)]
    [string]$DomainName,
    
    [Parameter(Mandatory=$true)]
    [string]$DomainUser,
    
    [Parameter(Mandatory=$true)]
    [SecureString]$DomainPassword,
    
    [string]$ResourceGroup = "UATAVDRG",
    
    [int[]]$HostNumbers = @(1,2,3,4,5)
)

# Convert secure string to plain text for the command
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DomainPassword)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

Write-Host "Starting domain rejoin process for AVD session hosts..." -ForegroundColor Cyan

foreach ($hostNum in $HostNumbers) {
    $vmName = "AVD-UAT-$hostNum"
    
    Write-Host "`nProcessing $vmName..." -ForegroundColor Yellow
    
    # Create the domain join script
    $domainJoinScript = @"
`$domain = '$DomainName'
`$username = '$DomainUser'
`$password = ConvertTo-SecureString '$PlainPassword' -AsPlainText -Force
`$credential = New-Object System.Management.Automation.PSCredential(`$username, `$password)

# Remove from domain first (if joined)
try {
    Remove-Computer -UnjoinDomainCredential `$credential -PassThru -Verbose -Force -ErrorAction SilentlyContinue
    Write-Host "Removed from domain"
} catch {
    Write-Host "Not currently domain joined or removal failed: `$_"
}

# Wait a moment
Start-Sleep -Seconds 5

# Join to domain
try {
    Add-Computer -DomainName `$domain -Credential `$credential -Options JoinWithNewName,AccountCreate -Force -Verbose
    Write-Host "Successfully joined to domain: `$domain"
    
    # Restart to complete domain join
    Restart-Computer -Force
} catch {
    Write-Error "Failed to join domain: `$_"
    exit 1
}
"@

    # Save script to temp file
    $scriptFile = [System.IO.Path]::GetTempFileName() + ".ps1"
    $domainJoinScript | Out-File -FilePath $scriptFile -Encoding UTF8
    
    try {
        # Execute the script on the VM
        Write-Host "Executing domain join on $vmName..." -ForegroundColor Green
        
        az vm run-command invoke `
            --resource-group $ResourceGroup `
            --name $vmName `
            --command-id RunPowerShellScript `
            --scripts @"$scriptFile"
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "$vmName: Domain join command sent successfully. VM will restart." -ForegroundColor Green
        } else {
            Write-Host "$vmName: Failed to send domain join command." -ForegroundColor Red
        }
    }
    catch {
        Write-Host "$vmName: Error - $_" -ForegroundColor Red
    }
    finally {
        # Clean up temp file
        Remove-Item $scriptFile -ErrorAction SilentlyContinue
    }
    
    # Wait between hosts to avoid overwhelming the system
    Start-Sleep -Seconds 10
}

Write-Host "`nDomain rejoin process completed!" -ForegroundColor Cyan
Write-Host "Note: VMs will restart automatically to complete the domain join." -ForegroundColor Yellow
