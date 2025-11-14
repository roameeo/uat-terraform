output "ad_subnet_id" {
  value       = azurerm_subnet.servers.id
  description = "ID of the servers subnet for compute resources"
}

output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "ID of the virtual network"
}

output "default_subnet_id" {
  value       = azurerm_subnet.default.id
  description = "ID of the default subnet"
}

output "bastion_subnet_id" {
  value       = azurerm_subnet.bastion.id
  description = "ID of the bastion subnet"
}

output "bastion_host_id" {
  value       = azurerm_bastion_host.bastion.id
  description = "ID of the bastion host"
}
