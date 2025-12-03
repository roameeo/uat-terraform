# Create missing AD groups
Write-Host "=== Creating Missing AD Groups ===" -ForegroundColor Cyan
Write-Host ""

$groupsToCreate = @(
    "AppID_Users",
    "Atlas Authentication",
    "Atlas Data",
    "Bit Photos Write",
    "Citrix Xen 7 - CommInvoice",
    "Citrix Xen 7 - Ulterra Enterprise Apps",
    "DDF_ApplicationsEngineers",
    "DDF_DesignEngineers",
    "Engineering Console Users",
    "IT",
    "JETServiceTier",
    "NAV_PDF_Reader_PDox",
    "Power_BI_Report",
    "SQL 2019 Cluster Admins",
    "SQL Cluster Admins",
    "sql_remote_users",
    "Ulterra Enterprise Application Users"
)

$createdCount = 0
$existsCount = 0

foreach ($groupName in $groupsToCreate) {
    try {
        # Check if group already exists
        $existing = Get-ADGroup -Identity $groupName -ErrorAction Stop
        Write-Host "  Already exists: $groupName" -ForegroundColor Gray
        $existsCount++
    } catch {
        # Group doesn't exist, create it
        try {
            New-ADGroup -Name $groupName `
                       -SamAccountName $groupName `
                       -GroupCategory Security `
                       -GroupScope Global `
                       -Description "Imported from legacy domain" `
                       -Path "CN=Users,DC=uat,DC=local"
            
            Write-Host "  Created: $groupName" -ForegroundColor Green
            $createdCount++
        } catch {
            Write-Host "  ERROR: Failed to create $groupName - $_" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "=== Summary ===" -ForegroundColor Cyan
Write-Host "Groups created: $createdCount" -ForegroundColor Green
Write-Host "Already existed: $existsCount" -ForegroundColor Gray
Write-Host ""
Write-Host "=== Group Creation Complete ===" -ForegroundColor Green
