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

output "dmz_subnet_id" {
  value       = azurerm_subnet.dmz.id
  description = "ID of the DMZ subnet for Meraki vMX"
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

output "ad_nsg_id" {
  value       = azurerm_network_security_group.ad.id
  description = "ID of the AD NSG"
}

output "application_nsg_id" {
  value       = azurerm_network_security_group.application.id
  description = "ID of the Application NSG"
}

output "sql_nsg_id" {
  value       = azurerm_network_security_group.sql.id
  description = "ID of the SQL NSG"
}

output "dmz_nsg_id" {
  value       = azurerm_network_security_group.dmz.id
  description = "ID of the DMZ NSG"
}
