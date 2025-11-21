output "host_pool_id" {
  description = "AVD Host Pool ID"
  value       = azurerm_virtual_desktop_host_pool.main.id
}

output "host_pool_name" {
  description = "AVD Host Pool Name"
  value       = azurerm_virtual_desktop_host_pool.main.name
}

output "workspace_id" {
  description = "AVD Workspace ID"
  value       = azurerm_virtual_desktop_workspace.main.id
}

output "workspace_name" {
  description = "AVD Workspace Name"
  value       = azurerm_virtual_desktop_workspace.main.name
}

output "fslogix_storage_account_name" {
  description = "FSLogix storage account name"
  value       = azurerm_storage_account.fslogix.name
}

output "fslogix_share_name" {
  description = "FSLogix file share name"
  value       = azurerm_storage_share.fslogix_profiles.name
}

output "fslogix_share_url" {
  description = "FSLogix file share UNC path"
  value       = "\\\\${azurerm_storage_account.fslogix.name}.file.core.windows.net\\${azurerm_storage_share.fslogix_profiles.name}"
}

output "session_host_names" {
  description = "AVD session host VM names"
  value       = azurerm_windows_virtual_machine.avd_session_hosts[*].name
}

output "session_host_ids" {
  description = "AVD session host VM IDs"
  value       = azurerm_windows_virtual_machine.avd_session_hosts[*].id
}

# Scaling plan output commented out since the resource is commented out
# output "scaling_plan_id" {
#   description = "AVD Scaling Plan ID"
#   value       = azurerm_virtual_desktop_scaling_plan.main.id
# }
