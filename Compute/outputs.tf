output "uatad01_id" {
  value       = azurerm_windows_virtual_machine.uatad01.id
  description = "ID of UATAD01 VM"
}

output "uatad02_id" {
  value       = azurerm_windows_virtual_machine.uatad02.id
  description = "ID of UATAD02 VM"
}

output "uatmulti01_id" {
  value       = azurerm_windows_virtual_machine.uatmulti01.id
  description = "ID of UATMULTI01 VM"
}

output "uatiis01_id" {
  value       = azurerm_windows_virtual_machine.uatiis01.id
  description = "ID of UATIIS01 VM"
}

output "uatad01_private_ip" {
  value       = azurerm_network_interface.uatad01.private_ip_address
  description = "Private IP of UATAD01"
}

output "uatad02_private_ip" {
  value       = azurerm_network_interface.uatad02.private_ip_address
  description = "Private IP of UATAD02"
}

output "uatmulti01_private_ip" {
  value       = azurerm_network_interface.uatmulti01.private_ip_address
  description = "Private IP of UATMULTI01"
}

output "uatiis01_private_ip" {
  value       = azurerm_network_interface.uatiis01.private_ip_address
  description = "Private IP of UATIIS01"
}

output "uatatlas01_id" {
  value       = azurerm_windows_virtual_machine.uatatlas01.id
  description = "ID of UATATLAS01 VM"
}

output "uatatlas01_private_ip" {
  value       = azurerm_network_interface.uatatlas01.private_ip_address
  description = "Private IP of UATATLAS01"
}

output "uatsql01_id" {
  value       = azurerm_windows_virtual_machine.uatsql01.id
  description = "ID of UATSQL01 VM"
}

output "uatsql01_private_ip" {
  value       = azurerm_network_interface.uatsql01.private_ip_address
  description = "Private IP of UATSQL01"
}
