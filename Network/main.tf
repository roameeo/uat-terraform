resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.rg_name
  location            = var.location
  address_space       = var.vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "ad" {
  name                 = var.subnet_name_ad
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_ad_prefix]
}
