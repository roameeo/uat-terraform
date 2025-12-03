# Public IP for vMX WAN interface (Meraki Dashboard connectivity)
resource "azurerm_public_ip" "vmx_wan" {
  name                = "${var.vmx_hostname}-WAN-PIP"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Network Security Group for vMX
resource "azurerm_network_security_group" "vmx" {
  name                = "${var.vmx_hostname}-NSG"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags

  # Allow Meraki Dashboard communication
  security_rule {
    name                       = "Allow-Meraki-Dashboard"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  # Allow VPN traffic inbound
  security_rule {
    name                       = "Allow-VPN-Inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_ranges    = ["500", "4500"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow ESP for IPsec
  security_rule {
    name                       = "Allow-ESP"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Esp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow HTTPS management
  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# WAN Network Interface (Internet-facing)
resource "azurerm_network_interface" "vmx_wan" {
  name                 = "${var.vmx_hostname}-WAN-NIC"
  location             = var.location
  resource_group_name  = var.rg_name
  ip_forwarding_enabled = true
  tags                 = var.tags

  ip_configuration {
    name                          = "wan"
    subnet_id                     = var.dmz_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vmx_wan.id
    primary                       = true
  }
}

# LAN Network Interface (Internal network)
resource "azurerm_network_interface" "vmx_lan" {
  name                 = "${var.vmx_hostname}-LAN-NIC"
  location             = var.location
  resource_group_name  = var.rg_name
  ip_forwarding_enabled = true
  tags                 = var.tags

  ip_configuration {
    name                          = "lan"
    subnet_id                     = var.dmz_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Associate NSG with WAN interface
resource "azurerm_network_interface_security_group_association" "vmx_wan" {
  network_interface_id      = azurerm_network_interface.vmx_wan.id
  network_security_group_id = azurerm_network_security_group.vmx.id
}

# Meraki vMX Virtual Machine
resource "azurerm_linux_virtual_machine" "vmx" {
  name                = var.vmx_hostname
  location            = var.location
  resource_group_name = var.rg_name
  size                = var.vmx_vm_size
  admin_username      = var.admin_username
  tags                = var.tags

  # Disable password authentication for security
  disable_password_authentication = false
  admin_password                  = var.admin_password

  # Network interfaces - WAN must be primary
  network_interface_ids = [
    azurerm_network_interface.vmx_wan.id,
    azurerm_network_interface.vmx_lan.id
  ]

  os_disk {
    name                 = "${var.vmx_hostname}-OSDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 30
  }

  # Meraki vMX image from Azure Marketplace
  plan {
    name      = "meraki-vmx-medium"
    product   = "meraki-vmx"
    publisher = "cisco"
  }

  source_image_reference {
    publisher = "cisco"
    offer     = "meraki-vmx"
    sku       = "meraki-vmx-medium"
    version   = "latest"
  }

  # Custom data with Meraki authentication token
  custom_data = base64encode(jsonencode({
    authentication_token = var.meraki_token
  }))

  # Boot diagnostics
  boot_diagnostics {
    storage_account_uri = null
  }
}
