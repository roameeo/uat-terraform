variable "network_rg_name" {
  type        = string
  description = "Name of the network resource group"
}

variable "servers_rg_name" {
  type        = string
  description = "Name of the servers resource group"
}

variable "avd_rg_name" {
  type        = string
  description = "Name of the AVD resource group"
}

variable "location" {
  type        = string
  description = "Azure region for resources"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resource groups"
  default     = {}
}
