# Resource Groups for UAT Environment

resource "azurerm_resource_group" "network" {
  name     = var.network_rg_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "servers" {
  name     = var.servers_rg_name
  location = var.location
  tags     = var.tags
}
