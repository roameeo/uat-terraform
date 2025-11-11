data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

/* Add NICs/VMs here later; for now, keep it empty to validate wiring. */

output "dc1_id" {
  value       = null
  description = "Placeholder until VMs are added"
}

output "dc2_id" {
  value       = null
  description = "Placeholder until VMs are added"
}
