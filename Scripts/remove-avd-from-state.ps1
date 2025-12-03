# Remove AVD resources from Terraform state
# This removes Terraform management but does NOT delete resources from Azure

Write-Host "Removing AVD module resources from Terraform state..." -ForegroundColor Yellow
Write-Host "Resources will remain in Azure, just no longer managed by Terraform" -ForegroundColor Cyan
Write-Host ""

# AVD Session Host VMs
terraform state rm 'module.avd.azurerm_windows_virtual_machine.avd_session_hosts[0]'
terraform state rm 'module.avd.azurerm_windows_virtual_machine.avd_session_hosts[1]'
terraform state rm 'module.avd.azurerm_windows_virtual_machine.avd_session_hosts[2]'
terraform state rm 'module.avd.azurerm_windows_virtual_machine.avd_session_hosts[3]'
terraform state rm 'module.avd.azurerm_windows_virtual_machine.avd_session_hosts[4]'

# Network Interfaces
terraform state rm 'module.avd.azurerm_network_interface.avd_session_hosts[0]'
terraform state rm 'module.avd.azurerm_network_interface.avd_session_hosts[1]'
terraform state rm 'module.avd.azurerm_network_interface.avd_session_hosts[2]'
terraform state rm 'module.avd.azurerm_network_interface.avd_session_hosts[3]'
terraform state rm 'module.avd.azurerm_network_interface.avd_session_hosts[4]'

# VM Extensions - Domain Join
terraform state rm 'module.avd.azurerm_virtual_machine_extension.domain_join_avd[0]'
terraform state rm 'module.avd.azurerm_virtual_machine_extension.domain_join_avd[1]'
terraform state rm 'module.avd.azurerm_virtual_machine_extension.domain_join_avd[2]'
terraform state rm 'module.avd.azurerm_virtual_machine_extension.domain_join_avd[3]'
terraform state rm 'module.avd.azurerm_virtual_machine_extension.domain_join_avd[4]'

# VM Extensions - AVD DSC
terraform state rm 'module.avd.azurerm_virtual_machine_extension.avd_dsc[0]'
terraform state rm 'module.avd.azurerm_virtual_machine_extension.avd_dsc[1]'
terraform state rm 'module.avd.azurerm_virtual_machine_extension.avd_dsc[2]'
terraform state rm 'module.avd.azurerm_virtual_machine_extension.avd_dsc[3]'
terraform state rm 'module.avd.azurerm_virtual_machine_extension.avd_dsc[4]'

# VM Extensions - FSLogix
terraform state rm 'module.avd.azurerm_virtual_machine_extension.fslogix[0]'
terraform state rm 'module.avd.azurerm_virtual_machine_extension.fslogix[1]'
terraform state rm 'module.avd.azurerm_virtual_machine_extension.fslogix[2]'
terraform state rm 'module.avd.azurerm_virtual_machine_extension.fslogix[3]'
terraform state rm 'module.avd.azurerm_virtual_machine_extension.fslogix[4]'

# AVD Host Pool and related
terraform state rm 'module.avd.azurerm_virtual_desktop_host_pool.main'
terraform state rm 'module.avd.azurerm_virtual_desktop_host_pool_registration_info.main'
terraform state rm 'module.avd.azurerm_virtual_desktop_workspace.main'
terraform state rm 'module.avd.azurerm_virtual_desktop_application_group.main'
terraform state rm 'module.avd.azurerm_virtual_desktop_workspace_application_group_association.main'

# FSLogix Storage
terraform state rm 'module.avd.azurerm_storage_account.fslogix'
terraform state rm 'module.avd.azurerm_storage_share.fslogix_profiles'
terraform state rm 'module.avd.random_string.unique'

# AVD Network resources
terraform state rm 'module.network.azurerm_virtual_network.avd_vnet'
terraform state rm 'module.network.azurerm_subnet.avd_bastion'
terraform state rm 'module.network.azurerm_subnet.avd_workspaces'
terraform state rm 'module.network.azurerm_public_ip.avd_bastion'
terraform state rm 'module.network.azurerm_bastion_host.avd_bastion'

# VNET Peerings
terraform state rm 'module.network.azurerm_virtual_network_peering.avd_to_server'
terraform state rm 'module.network.azurerm_virtual_network_peering.server_to_avd'
terraform state rm 'module.network.azurerm_virtual_network_peering.avd_to_vpn_prod'
terraform state rm 'module.network.azurerm_virtual_network_peering.vpn_prod_to_avd'

# AVD Resource Group
terraform state rm 'module.resource_groups.azurerm_resource_group.avd'

Write-Host ""
Write-Host "Complete! All AVD resources have been removed from Terraform state." -ForegroundColor Green
Write-Host "Resources still exist in Azure and can be managed through the portal." -ForegroundColor Green
Write-Host ""
Write-Host "To bring them back under Terraform management later, you'll need to:" -ForegroundColor Yellow
Write-Host "1. Uncomment/add the resource definitions back to the .tf files" -ForegroundColor Yellow
Write-Host "2. Run terraform import commands for each resource" -ForegroundColor Yellow
