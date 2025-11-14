variable "rg_name" {
  type        = string
  description = "Name of the network resource group"
}

variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "subnet_name_ad" {
  type        = string
  description = "Name of the servers subnet"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "centralus"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space for the virtual network"
  default     = ["10.0.0.0/22"]
}

variable "subnet_ad_prefix" {
  type        = string
  description = "Address prefix for the servers subnet"
  default     = "10.0.2.0/24"
}
