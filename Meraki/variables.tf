variable "rg_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "centralus"
}

variable "dmz_subnet_id" {
  type        = string
  description = "ID of the DMZ subnet for vMX deployment"
}

variable "meraki_token" {
  type        = string
  description = "Meraki authentication token for vMX"
  sensitive   = true
}

variable "vmx_vm_size" {
  type        = string
  description = "Azure VM size for Meraki vMX"
  default     = "Standard_D3_v2"
}

variable "vmx_hostname" {
  type        = string
  description = "Hostname for the Meraki vMX"
  default     = "UATVMX01"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the vMX"
  default     = "azadmin"
}

variable "admin_password" {
  type        = string
  description = "Admin password for the vMX"
  sensitive   = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
