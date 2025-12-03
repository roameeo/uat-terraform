output "vmx_public_ip" {
  value       = azurerm_public_ip.vmx_wan.ip_address
  description = "Public IP address of the Meraki vMX WAN interface"
}

output "vmx_private_ip" {
  value       = azurerm_network_interface.vmx_lan.private_ip_address
  description = "Private IP address of the Meraki vMX LAN interface"
}

output "vmx_vm_id" {
  value       = azurerm_linux_virtual_machine.vmx.id
  description = "Azure resource ID of the Meraki vMX VM"
}

output "vmx_hostname" {
  value       = azurerm_linux_virtual_machine.vmx.name
  description = "Hostname of the Meraki vMX"
}
