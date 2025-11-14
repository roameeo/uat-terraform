#!/usr/bin/env pwsh
# Terraform Import Script for UAT Environment
# This script imports all existing Azure resources into Terraform state

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "UAT Azure Resources Import Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$subscriptionId = "f830b735-d380-4c43-b54b-73ba9ff8cd9d"

# Verify Azure CLI is logged in
Write-Host "Verifying Azure CLI authentication..." -ForegroundColor Yellow
az account show | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Error "Not logged in to Azure CLI. Please run 'az login' first."
    exit 1
}

# Set subscription context
Write-Host "Setting Azure subscription context..." -ForegroundColor Yellow
az account set --subscription $subscriptionId
Write-Host "✓ Subscription set to UAT" -ForegroundColor Green
Write-Host ""

# Initialize Terraform
Write-Host "Initializing Terraform..." -ForegroundColor Yellow
terraform init
if ($LASTEXITCODE -ne 0) {
    Write-Error "Terraform initialization failed"
    exit 1
}
Write-Host "✓ Terraform initialized" -ForegroundColor Green
Write-Host ""

# Import Resource Groups
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Importing Resource Groups" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "Importing UATNETRG..." -ForegroundColor Yellow
terraform import module.resource_groups.azurerm_resource_group.network /subscriptions/$subscriptionId/resourceGroups/UATNETRG
Write-Host "✓ UATNETRG imported" -ForegroundColor Green

Write-Host "Importing UATSERVERRG..." -ForegroundColor Yellow
terraform import module.resource_groups.azurerm_resource_group.servers /subscriptions/$subscriptionId/resourceGroups/UATSERVERRG
Write-Host "✓ UATSERVERRG imported" -ForegroundColor Green
Write-Host ""

# Import Network Resources
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Importing Network Resources" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "Importing Virtual Network..." -ForegroundColor Yellow
terraform import module.network.azurerm_virtual_network.vnet /subscriptions/$subscriptionId/resourceGroups/UATNETRG/providers/Microsoft.Network/virtualNetworks/UATSERVERVNET
Write-Host "✓ Virtual Network imported" -ForegroundColor Green

Write-Host "Importing Default Subnet..." -ForegroundColor Yellow
terraform import module.network.azurerm_subnet.default /subscriptions/$subscriptionId/resourceGroups/UATNETRG/providers/Microsoft.Network/virtualNetworks/UATSERVERVNET/subnets/default
Write-Host "✓ Default Subnet imported" -ForegroundColor Green

Write-Host "Importing Bastion Subnet..." -ForegroundColor Yellow
terraform import module.network.azurerm_subnet.bastion /subscriptions/$subscriptionId/resourceGroups/UATNETRG/providers/Microsoft.Network/virtualNetworks/UATSERVERVNET/subnets/AzureBastionSubnet
Write-Host "✓ Bastion Subnet imported" -ForegroundColor Green

Write-Host "Importing Servers Subnet..." -ForegroundColor Yellow
terraform import module.network.azurerm_subnet.servers /subscriptions/$subscriptionId/resourceGroups/UATNETRG/providers/Microsoft.Network/virtualNetworks/UATSERVERVNET/subnets/UATSERVERS
Write-Host "✓ Servers Subnet imported" -ForegroundColor Green

Write-Host "Importing Bastion Public IP..." -ForegroundColor Yellow
terraform import module.network.azurerm_public_ip.bastion /subscriptions/$subscriptionId/resourceGroups/UATNETRG/providers/Microsoft.Network/publicIPAddresses/uatservervnet-bastion
Write-Host "✓ Bastion Public IP imported" -ForegroundColor Green

Write-Host "Importing Bastion Host..." -ForegroundColor Yellow
terraform import module.network.azurerm_bastion_host.bastion /subscriptions/$subscriptionId/resourceGroups/UATNETRG/providers/Microsoft.Network/bastionHosts/UATSERVERVNET-Bastion
Write-Host "✓ Bastion Host imported" -ForegroundColor Green
Write-Host ""

# Import Compute Resources
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Importing Compute Resources" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# UATAD01 Resources
Write-Host "Importing UATAD01 resources..." -ForegroundColor Yellow
terraform import module.compute.azurerm_network_security_group.uatad01 /subscriptions/$subscriptionId/resourceGroups/UATSERVERRG/providers/Microsoft.Network/networkSecurityGroups/UATAD01-nsg
terraform import module.compute.azurerm_public_ip.uatad01 /subscriptions/$subscriptionId/resourceGroups/UATSERVERRG/providers/Microsoft.Network/publicIPAddresses/UATAD01-ip
terraform import module.compute.azurerm_network_interface.uatad01 /subscriptions/$subscriptionId/resourceGroups/UATSERVERRG/providers/Microsoft.Network/networkInterfaces/uatad01600
terraform import 'module.compute.azurerm_network_interface_security_group_association.uatad01' "/subscriptions/$subscriptionId/resourceGroups/UATSERVERRG/providers/Microsoft.Network/networkInterfaces/uatad01600|/subscriptions/$subscriptionId/resourceGroups/UATSERVERRG/providers/Microsoft.Network/networkSecurityGroups/UATAD01-nsg"
terraform import module.compute.azurerm_windows_virtual_machine.uatad01 /subscriptions/$subscriptionId/resourceGroups/UATSERVERRG/providers/Microsoft.Compute/virtualMachines/UATAD01
Write-Host "✓ UATAD01 resources imported" -ForegroundColor Green

# UATAD02 Resources
Write-Host "Importing UATAD02 resources..." -ForegroundColor Yellow
terraform import module.compute.azurerm_network_interface.uatad02 /subscriptions/$subscriptionId/resourceGroups/UATSERVERRG/providers/Microsoft.Network/networkInterfaces/uatad02958
terraform import module.compute.azurerm_windows_virtual_machine.uatad02 /subscriptions/$subscriptionId/resourceGroups/UATSERVERRG/providers/Microsoft.Compute/virtualMachines/UATAD02
Write-Host "✓ UATAD02 resources imported" -ForegroundColor Green

# UATMULTI01 Resources
Write-Host "Importing UATMULTI01 resources..." -ForegroundColor Yellow
terraform import module.compute.azurerm_network_security_group.uatmulti01 /subscriptions/$subscriptionId/resourceGroups/UATSERVERRG/providers/Microsoft.Network/networkSecurityGroups/UATMULTI01-nsg
terraform import module.compute.azurerm_network_interface.uatmulti01 /subscriptions/$subscriptionId/resourceGroups/UATSERVERRG/providers/Microsoft.Network/networkInterfaces/uatmulti01871
terraform import 'module.compute.azurerm_network_interface_security_group_association.uatmulti01' "/subscriptions/$subscriptionId/resourceGroups/UATSERVERRG/providers/Microsoft.Network/networkInterfaces/uatmulti01871|/subscriptions/$subscriptionId/resourceGroups/UATSERVERRG/providers/Microsoft.Network/networkSecurityGroups/UATMULTI01-nsg"
terraform import module.compute.azurerm_managed_disk.uatmulti01_data /subscriptions/$subscriptionId/resourceGroups/UATSERVERRG/providers/Microsoft.Compute/disks/UATMULTI01_DataDisk_0
terraform import module.compute.azurerm_windows_virtual_machine.uatmulti01 /subscriptions/$subscriptionId/resourceGroups/UATSERVERRG/providers/Microsoft.Compute/virtualMachines/UATMULTI01
terraform import module.compute.azurerm_virtual_machine_data_disk_attachment.uatmulti01_data /subscriptions/$subscriptionId/resourceGroups/UATSERVERRG/providers/Microsoft.Compute/virtualMachines/UATMULTI01/dataDisks/UATMULTI01_DataDisk_0
Write-Host "✓ UATMULTI01 resources imported" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Import Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Review the imported state: terraform state list" -ForegroundColor White
Write-Host "2. Verify configuration matches: terraform plan" -ForegroundColor White
Write-Host "3. Address any differences in the plan output" -ForegroundColor White
Write-Host ""
Write-Host "Note: You'll need to add the admin_password variable value before running terraform plan" -ForegroundColor Yellow
