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
