variable "location" {
  type    = string
  default = "centralus"
}

variable "project" {
  type    = string
  default = "new-uat"
}

variable "env" {
  type    = string
  default = "uat"
}

# Names of existing resources you want to import
variable "rg_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnet_name_ad" {
  type    = string
  default = "UATSERVERS"
}

# Existing VM names (domain controllers)
variable "dc1_name" {
  type    = string
  default = "UATAD01"
}

variable "dc2_name" {
  type    = string
  default = "UATAD02"
}

# Common tags
variable "tags" {
  type = map(string)
  default = {
    BuildBy     = "Stormy"
    BuildDate   = "2025-11-10"
    Environment = "UAT"
    Function    = "CoreInfra"
  }
}
