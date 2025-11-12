variable "rg_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnet_name_ad" {
  type    = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "location" {
  type    = string
  default = "centralus"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/22"]
}

variable "subnet_ad_prefix" {
  type    = string
  default = "10.0.2.0/24"
}
