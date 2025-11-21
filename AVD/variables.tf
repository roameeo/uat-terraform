variable "rg_name" {
  description = "Resource group name for AVD resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Central US"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "avd_subnet_id" {
  description = "Subnet ID for AVD session hosts"
  type        = string
}

variable "dns_servers" {
  description = "DNS servers for AVD session hosts (domain controllers)"
  type        = list(string)
  default     = ["10.0.2.5", "10.0.2.4"]
}

variable "admin_username" {
  description = "Local admin username for session hosts"
  type        = string
}

variable "admin_password" {
  description = "Local admin password for session hosts"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Active Directory domain name"
  type        = string
}

variable "domain_join_username" {
  description = "Username for domain join (e.g., terraform.adm)"
  type        = string
}

variable "domain_admin_password" {
  description = "Password for domain admin account"
  type        = string
  sensitive   = true
}

variable "avd_ou_path" {
  description = "OU path for AVD session hosts (leave empty for default)"
  type        = string
  default     = ""
}
