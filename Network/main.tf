# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.rg_name
  location            = var.location
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# Subnets
resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/26"]
}

resource "azurerm_subnet" "ad" {
  name                 = "UATAD"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/25"]  # 10.0.2.0 - 10.0.2.127
}

resource "azurerm_subnet" "application" {
  name                 = "UATAPPLICATION"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.128/26"]  # 10.0.2.128 - 10.0.2.191
}

resource "azurerm_subnet" "sql" {
  name                 = "UATSQL"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.192/26"]  # 10.0.2.192 - 10.0.2.255
}

# Bastion Public IP
resource "azurerm_public_ip" "bastion" {
  name                = "uatservervnet-bastion"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Bastion Host
resource "azurerm_bastion_host" "bastion" {
  name                = "UATSERVERVNET-Bastion"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Basic"
  tags                = var.tags

  ip_configuration {
    name                 = "IPCONF"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}
