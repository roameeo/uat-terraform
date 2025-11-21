variable "rg_name" {
  type        = string
  description = "Name of the resource group for compute resources"
}

variable "dc1_name" {
  type        = string
  description = "Name of the first domain controller"
}

variable "dc2_name" {
  type        = string
  description = "Name of the second domain controller"
}

variable "ad_subnet_id" {
  type        = string
  description = "ID of the AD subnet for domain controllers"
}

variable "application_subnet_id" {
  type        = string
  description = "ID of the application subnet"
}

variable "sql_subnet_id" {
  type        = string
  description = "ID of the SQL subnet"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

variable "admin_password" {
  type        = string
  description = "Admin password for VMs"
  sensitive   = true
}

variable "location" {
  type        = string
  description = "Azure region for resources"
}

# Optional: Azure Key Vault to source per-VM admin passwords
variable "key_vault_id" {
  type        = string
  description = "Resource ID of the Azure Key Vault that holds VM admin password secrets"
  default     = null
}

# Optional: map of VM name => Key Vault secret name
# Example: { UATAD01 = "vm-UATAD01-admin" }
variable "vm_password_secret_names" {
  type        = map(string)
  description = "Map of VM names to Key Vault secret names for admin passwords"
  default     = {}
}
