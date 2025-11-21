# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.rg_name
  location            = var.location
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# Subnets
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

# AVD Virtual Network
resource "azurerm_virtual_network" "avd_vnet" {
  name                = var.avd_vnet_name
  resource_group_name = var.avd_rg_name
  location            = var.location
  address_space       = var.avd_vnet_address_space
  tags                = var.tags
}

# AVD Subnets
resource "azurerm_subnet" "avd_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.avd_rg_name
  virtual_network_name = azurerm_virtual_network.avd_vnet.name
  address_prefixes     = ["10.1.0.0/26"]
}

resource "azurerm_subnet" "avd_workspaces" {
  name                 = "UATAVDWKSP"
  resource_group_name  = var.avd_rg_name
  virtual_network_name = azurerm_virtual_network.avd_vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}

# AVD Bastion Public IP
resource "azurerm_public_ip" "avd_bastion" {
  name                = "uatavdvnet-bastion"
  location            = var.location
  resource_group_name = var.avd_rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# AVD Bastion Host
resource "azurerm_bastion_host" "avd_bastion" {
  name                = "UATAVDVNET-Bastion"
  location            = var.location
  resource_group_name = var.avd_rg_name
  sku                 = "Basic"
  tags                = var.tags

  ip_configuration {
    name                 = "IPCONF"
    subnet_id            = azurerm_subnet.avd_bastion.id
    public_ip_address_id = azurerm_public_ip.avd_bastion.id
  }
}

# VNET Peering: Server VNET to AVD VNET
resource "azurerm_virtual_network_peering" "server_to_avd" {
  name                      = "ServerVNET-to-AVDVNET"
  resource_group_name       = var.rg_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = azurerm_virtual_network.avd_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
}

# VNET Peering: AVD VNET to Server VNET
resource "azurerm_virtual_network_peering" "avd_to_server" {
  name                      = "AVDVNET-to-ServerVNET"
  resource_group_name       = var.avd_rg_name
  virtual_network_name      = azurerm_virtual_network.avd_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
}

# Data source for VPN Production VNET
data "azurerm_virtual_network" "vpn_prod" {
  name                = "vpn_prod_vnet-1"
  resource_group_name = "vpn_prod"
  provider            = azurerm.prod
}

# VNET Peering: AVD VNET to VPN Production VNET
resource "azurerm_virtual_network_peering" "avd_to_vpn_prod" {
  name                      = "AVDVNET-to-VPNProd"
  resource_group_name       = var.avd_rg_name
  virtual_network_name      = azurerm_virtual_network.avd_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.vpn_prod.id
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
}

# VNET Peering: VPN Production VNET to AVD VNET
resource "azurerm_virtual_network_peering" "vpn_prod_to_avd" {
  name                      = "VPNProd-to-AVDVNET"
  resource_group_name       = data.azurerm_virtual_network.vpn_prod.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.vpn_prod.name
  remote_virtual_network_id = azurerm_virtual_network.avd_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  provider                  = azurerm.prod
}
