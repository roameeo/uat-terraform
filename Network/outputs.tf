output "ad_subnet_id" {
  value       = azurerm_subnet.ad.id
  description = "ID of the AD subnet for domain controllers"
}

output "application_subnet_id" {
  value       = azurerm_subnet.application.id
  description = "ID of the application subnet"
}

output "sql_subnet_id" {
  value       = azurerm_subnet.sql.id
  description = "ID of the SQL subnet"
}

output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "ID of the virtual network"
}

output "bastion_subnet_id" {
  value       = azurerm_subnet.bastion.id
  description = "ID of the bastion subnet"
}

output "bastion_host_id" {
  value       = azurerm_bastion_host.bastion.id
  description = "ID of the bastion host"
}

output "avd_vnet_id" {
  value       = azurerm_virtual_network.avd_vnet.id
  description = "ID of the AVD virtual network"
}

output "avd_workspaces_subnet_id" {
  value       = azurerm_subnet.avd_workspaces.id
  description = "ID of the AVD workspaces subnet"
}

output "avd_bastion_subnet_id" {
  value       = azurerm_subnet.avd_bastion.id
  description = "ID of the AVD bastion subnet"
}

output "avd_bastion_host_id" {
  value       = azurerm_bastion_host.avd_bastion.id
  description = "ID of the AVD bastion host"
}
