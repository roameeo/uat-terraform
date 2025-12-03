variable "rg_name" {
  type        = string
  description = "Name of the network resource group"
}

variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
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
  default     = ["10.48.0.0/16"]
}
