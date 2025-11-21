variable "location" {
  type        = string
  description = "Azure region for resources"
  default     = "centralus"
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "new-uat"
}

variable "env" {
  type        = string
  description = "Environment name"
  default     = "uat"
}

# Resource Group Names
variable "network_rg_name" {
  type        = string
  description = "Name of the network resource group"
  default     = "UATNETRG"
}

variable "servers_rg_name" {
  type        = string
  description = "Name of the servers resource group"
  default     = "UATSERVERRG"
}

variable "avd_rg_name" {
  type        = string
  description = "Name of the AVD resource group"
  default     = "UATAVDRG"
}

# Network Configuration
variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
  default     = "UATSERVERVNET"
}

variable "avd_vnet_name" {
  type        = string
  description = "Name of the AVD virtual network"
  default     = "UATAVDVNET"
}

# VM Names
variable "dc1_name" {
  type        = string
  description = "Name of the first domain controller"
  default     = "UATAD01"
}

variable "dc2_name" {
  type        = string
  description = "Name of the second domain controller"
  default     = "UATAD02"
}

# Security
variable "admin_username" {
  type        = string
  description = "Local admin username for VMs"
  default     = "azadmin"
}

variable "admin_password" {
  type        = string
  description = "Admin password for VMs (required for import)"
  sensitive   = true
}

# Domain Configuration
variable "domain_name" {
  type        = string
  description = "Active Directory domain name"
  default     = "uat.local"
}

variable "domain_join_username" {
  type        = string
  description = "Username for domain join operations"
  default     = "terraform.adm"
}

variable "domain_admin_password" {
  type        = string
  description = "Domain administrator password (DSRM password). If not provided, domain controller promotion will be skipped."
  sensitive   = true
  default     = null
}

variable "domain_admin_password_secret_name" {
  type        = string
  description = "Name of the Key Vault secret containing the domain admin password"
  default     = null
}

# Optional: Azure Key Vault wiring for per-VM passwords
variable "key_vault_id" {
  type        = string
  description = "Resource ID of the Azure Key Vault that holds VM admin password secrets"
  default     = null
}

variable "vm_password_secret_names" {
  type        = map(string)
  description = "Map of VM names to Key Vault secret names for admin passwords"
  default     = {}
}

# Common tags
variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default = {
    BuildBy     = "Stormy"
    BuildDate   = "2025-11-10"
    Environment = "UAT"
    Function    = "CoreInfra"
  }
}
