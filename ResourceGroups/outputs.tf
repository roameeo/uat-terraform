output "network_rg_name" {
  value       = azurerm_resource_group.network.name
  description = "Name of the network resource group"
}

output "servers_rg_name" {
  value       = azurerm_resource_group.servers.name
  description = "Name of the servers resource group"
}

output "network_rg_id" {
  value       = azurerm_resource_group.network.id
  description = "ID of the network resource group"
}

output "servers_rg_id" {
  value       = azurerm_resource_group.servers.id
  description = "ID of the servers resource group"
}

output "avd_rg_name" {
  value       = azurerm_resource_group.avd.name
  description = "Name of the AVD resource group"
}

output "avd_rg_id" {
  value       = azurerm_resource_group.avd.id
  description = "ID of the AVD resource group"
}
