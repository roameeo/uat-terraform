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
