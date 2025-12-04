# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.rg_name
  location            = var.location
  address_space       = var.vnet_address_space
  dns_servers         = ["10.48.2.4", "10.48.2.5"]  # Updated for new address space
  tags                = var.tags
}

# Network Security Groups
resource "azurerm_network_security_group" "ad" {
  name                = "UATAD-NSG"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags

  # DNS
  security_rule {
    name                       = "Allow-DNS-UDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "10.48.0.0/16"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-DNS-TCP"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "10.48.0.0/16"
    destination_address_prefix = "*"
  }

  # Kerberos
  security_rule {
    name                       = "Allow-Kerberos"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "88"
    source_address_prefix      = "10.48.0.0/16"
    destination_address_prefix = "*"
  }

  # LDAP
  security_rule {
    name                       = "Allow-LDAP"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["389", "636", "3268", "3269"]
    source_address_prefix      = "10.48.0.0/16"
    destination_address_prefix = "*"
  }

  # SMB
  security_rule {
    name                       = "Allow-SMB"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "445"
    source_address_prefix      = "10.48.0.0/16"
    destination_address_prefix = "*"
  }

  # RPC
  security_rule {
    name                       = "Allow-RPC"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["135", "49152-65535"]
    source_address_prefix      = "10.48.0.0/16"
    destination_address_prefix = "*"
  }

  # RDP
  security_rule {
    name                       = "Allow-RDP"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.48.0.0/16"
    destination_address_prefix = "*"
  }

  # WinRM
  security_rule {
    name                       = "Allow-WinRM"
    priority                   = 160
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["5985", "5986"]
    source_address_prefix      = "10.48.0.0/16"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "application" {
  name                = "UATAPPLICATION-NSG"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags

  # RDP
  security_rule {
    name                       = "Allow-RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.48.0.0/16"
    destination_address_prefix = "*"
  }

  # WinRM
  security_rule {
    name                       = "Allow-WinRM"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["5985", "5986"]
    source_address_prefix      = "10.48.0.0/16"
    destination_address_prefix = "*"
  }

  # HTTP/HTTPS
  security_rule {
    name                       = "Allow-HTTP-HTTPS"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # SMB
  security_rule {
    name                       = "Allow-SMB"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "445"
    source_address_prefix      = "10.48.0.0/16"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "sql" {
  name                = "UATSQL-NSG"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags

  # SQL Server
  security_rule {
    name                       = "Allow-SQL"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "10.48.0.0/16"
    destination_address_prefix = "*"
  }

  # RDP
  security_rule {
    name                       = "Allow-RDP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.48.0.0/16"
    destination_address_prefix = "*"
  }

  # WinRM
  security_rule {
    name                       = "Allow-WinRM"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["5985", "5986"]
    source_address_prefix      = "10.48.0.0/16"
    destination_address_prefix = "*"
  }

  # SMB
  security_rule {
    name                       = "Allow-SMB"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "445"
    source_address_prefix      = "10.48.0.0/16"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "dmz" {
  name                = "UATDMZ-NSG"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags

  # VPN
  security_rule {
    name                       = "Allow-VPN-IKE"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_ranges    = ["500", "4500"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # HTTPS
  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Subnets
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.48.1.0/26"]
}

resource "azurerm_subnet" "ad" {
  name                 = "UATAD"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.48.2.0/25"]  # 10.48.2.0 - 10.48.2.127
}

resource "azurerm_subnet" "application" {
  name                 = "UATAPPLICATION"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.48.2.128/26"]  # 10.48.2.128 - 10.48.2.191
}

resource "azurerm_subnet" "sql" {
  name                 = "UATSQL"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.48.2.192/26"]  # 10.48.2.192 - 10.48.2.255
}

resource "azurerm_subnet" "dmz" {
  name                 = "UATDMZ"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.48.3.0/26"]  # 10.48.3.0 - 10.48.3.63
}

# NSG Associations
resource "azurerm_subnet_network_security_group_association" "ad" {
  subnet_id                 = azurerm_subnet.ad.id
  network_security_group_id = azurerm_network_security_group.ad.id
}

resource "azurerm_subnet_network_security_group_association" "application" {
  subnet_id                 = azurerm_subnet.application.id
  network_security_group_id = azurerm_network_security_group.application.id
}

resource "azurerm_subnet_network_security_group_association" "sql" {
  subnet_id                 = azurerm_subnet.sql.id
  network_security_group_id = azurerm_network_security_group.sql.id
}

resource "azurerm_subnet_network_security_group_association" "dmz" {
  subnet_id                 = azurerm_subnet.dmz.id
  network_security_group_id = azurerm_network_security_group.dmz.id
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
