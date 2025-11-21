# Network Security Groups
resource "azurerm_network_security_group" "uatad01" {
  name                = "UATAD01-nsg"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "uatmulti01" {
  name                = "UATMULTI01-nsg"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags
}

# Public IPs
resource "azurerm_public_ip" "uatad01" {
  name                = "UATAD01-ip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interfaces
resource "azurerm_network_interface" "uatad01" {
  name                = "uatad01600"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "IPCONFIG1"
    subnet_id                     = var.ad_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface_security_group_association" "uatad01" {
  network_interface_id      = azurerm_network_interface.uatad01.id
  network_security_group_id = azurerm_network_security_group.uatad01.id
}

resource "azurerm_network_interface" "uatad02" {
  name                = "uatad02958"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "IPCONFIG1"
    subnet_id                     = var.ad_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "uatmulti01" {
  name                = "uatmulti01871"
  location            = var.location
  resource_group_name = var.rg_name
  dns_servers         = ["10.0.2.5", "10.0.2.4"]

  ip_configuration {
    name                          = "IPCONFIG1"
    subnet_id                     = var.application_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "uatiis01" {
  name                = "uatiis01871"
  location            = var.location
  resource_group_name = var.rg_name
  dns_servers         = ["10.0.2.5", "10.0.2.4"]

  ip_configuration {
    name                          = "IPCONFIG1"
    subnet_id                     = var.application_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "uatatlas01" {
  name                = "uatatlas01872"
  location            = var.location
  resource_group_name = var.rg_name
  dns_servers         = ["10.0.2.5", "10.0.2.4"]

  ip_configuration {
    name                          = "IPCONFIG1"
    subnet_id                     = var.application_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "uatmulti01" {
  network_interface_id      = azurerm_network_interface.uatmulti01.id
  network_security_group_id = azurerm_network_security_group.uatmulti01.id
}

# Optionally load per-VM admin passwords from Azure Key Vault
data "azurerm_key_vault_secret" "vm_passwords" {
  for_each     = var.key_vault_id != null && length(var.vm_password_secret_names) > 0 ? var.vm_password_secret_names : {}
  name         = each.value
  key_vault_id = var.key_vault_id
}

locals {
  # Map VM name => password value when Key Vault is configured; empty otherwise
  admin_passwords = var.key_vault_id != null && length(var.vm_password_secret_names) > 0 ? {
    for vm_name, _ in var.vm_password_secret_names :
    vm_name => data.azurerm_key_vault_secret.vm_passwords[vm_name].value
  } : {}
}

# Virtual Machines
resource "azurerm_windows_virtual_machine" "uatad01" {
  name                = var.dc1_name
  location            = var.location
  resource_group_name = var.rg_name
  size                = "Standard_D2ds_v6"
  admin_username      = "azadmin"
  admin_password      = try(local.admin_passwords[var.dc1_name], var.admin_password)
  license_type        = "Windows_Server"

  network_interface_ids = [
    azurerm_network_interface.uatad01.id,
  ]

  os_disk {
    name                 = "UATAD01_OsDisk_1_02eb907362e24ddb8b88ddfc0a219148"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 127
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  lifecycle {
    ignore_changes = [admin_password]
  }
}

resource "azurerm_windows_virtual_machine" "uatad02" {
  name                = var.dc2_name
  location            = var.location
  resource_group_name = var.rg_name
  size                = "Standard_D2ds_v6"
  admin_username      = "azadmin"
  admin_password      = try(local.admin_passwords[var.dc2_name], var.admin_password)
  license_type        = "Windows_Server"

  network_interface_ids = [
    azurerm_network_interface.uatad02.id,
  ]

  os_disk {
    name                 = "UATAD02_OsDisk_1_141e7ef277424a359a2a91f3d9c7d308"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 127
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  lifecycle {
    ignore_changes = [admin_password]
  }
}

resource "azurerm_windows_virtual_machine" "uatmulti01" {
  name                = "UATMULTI01"
  location            = var.location
  resource_group_name = var.rg_name
  size                = "Standard_D4as_v6"
  admin_username      = "azadmin"
  admin_password      = try(local.admin_passwords["UATMULTI01"], var.admin_password)
  license_type        = "Windows_Server"

  network_interface_ids = [
    azurerm_network_interface.uatmulti01.id,
  ]

  os_disk {
    name                 = "UATMULTI01_OsDisk_1_dd4f35cabe854be9b0160868e28e5d02"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 127
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  boot_diagnostics {}

  lifecycle {
    ignore_changes = [admin_password]
  }

  tags = {
    "Build by"    = "Stormy Winters"
    "Build date"  = "11/10/2025"
    "Contact"     = "Glenn Redfern"
    "Environment" = "UAT"
    "Function"    = "File/Print/CA/Multi use"
    "Owner"       = "Cloud Admins"
  }
}

# Data Disks
resource "azurerm_managed_disk" "uatmulti01_data" {
  name                 = "UATMULTI01_DataDisk_0"
  location             = var.location
  resource_group_name  = var.rg_name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 1024
}

resource "azurerm_virtual_machine_data_disk_attachment" "uatmulti01_data" {
  managed_disk_id    = azurerm_managed_disk.uatmulti01_data.id
  virtual_machine_id = azurerm_windows_virtual_machine.uatmulti01.id
  lun                = 0
  caching            = "ReadOnly"
}

resource "azurerm_windows_virtual_machine" "uatiis01" {
  name                = "UATIIS01"
  location            = var.location
  resource_group_name = var.rg_name
  size                = "Standard_D4as_v6"
  admin_username      = "azadmin"
  admin_password      = try(local.admin_passwords["UATIIS01"], var.admin_password)
  license_type        = "Windows_Server"

  network_interface_ids = [
    azurerm_network_interface.uatiis01.id,
  ]

  os_disk {
    name                 = "UATIIS01_OsDisk_1_dd4f35cabe854be9b0160868e28e5d02"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 127
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  boot_diagnostics {}

  lifecycle {
    ignore_changes = [admin_password]
  }

  tags = {
    "Build by"    = "Stormy Winters"
    "Build date"  = "11/17/2025"
    "Contact"     = "Glenn Redfern"
    "Environment" = "UAT"
    "Function"    = "UAT IIS Server"
     "Owner"       = "Cloud Admins"
  }
}

resource "azurerm_windows_virtual_machine" "uatatlas01" {
  name                = "UATATLAS01"
  location            = var.location
  resource_group_name = var.rg_name
  size                = "Standard_D4as_v6"
  admin_username      = "azadmin"
  admin_password      = try(local.admin_passwords["UATNAV01"], var.admin_password)
  license_type        = "Windows_Server"

  network_interface_ids = [
    azurerm_network_interface.uatatlas01.id,
  ]

  os_disk {
    name                 = "UATATLAS01_OsDisk_1_dd4f35cabe854be9b0160868e28e5d02"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 127
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  boot_diagnostics {}

  lifecycle {
    ignore_changes = [admin_password]
  }

  tags = {
    "Build by"    = "Stormy Winters"
    "Build date"  = "11/17/2025"
    "Contact"     = "Glenn Redfern"
    "Environment" = "UAT"
    "Function"    = "UAT NAV Server"
     "Owner"       = "Cloud Admins"
  }
}

# Network Interface for UATSQL01
resource "azurerm_network_interface" "uatsql01" {
  name                = "uatsql01873"
  location            = var.location
  resource_group_name = var.rg_name
  dns_servers         = ["10.0.2.5", "10.0.2.4"]

  ip_configuration {
    name                          = "IPCONFIG1"
    subnet_id                     = var.sql_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "uatsql01" {
  name                = "UATSQL01"
  location            = var.location
  resource_group_name = var.rg_name
  size                = "Standard_E4as_v6"
  admin_username      = "azadmin"
  admin_password      = try(local.admin_passwords["UATSQL01"], var.admin_password)
  license_type        = "Windows_Server"

  network_interface_ids = [
    azurerm_network_interface.uatsql01.id,
  ]

  os_disk {
    name                 = "UATSQL01_OsDisk_1"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 127
  }

  source_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "sql2022-ws2022"
    sku       = "standard-gen2"
    version   = "latest"
  }

  boot_diagnostics {}

  lifecycle {
    ignore_changes = [admin_password]
  }

  tags = {
    "Build by"    = "Stormy Winters"
    "Build date"  = "11/19/2025"
    "Contact"     = "Glenn Redfern"
    "Environment" = "UAT"
    "Function"    = "UAT SQL Server"
    "Owner"       = "Cloud Admins"
  }
}

# Domain Join Extensions for Member Servers
resource "azurerm_virtual_machine_extension" "domain_join_uatmulti01" {
  count                      = var.domain_admin_password_secret_name != null || var.domain_admin_password != null ? 1 : 0
  name                       = "DomainJoin"
  virtual_machine_id         = azurerm_windows_virtual_machine.uatmulti01.id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    Name    = var.domain_name
    OUPath  = ""
    User    = "${var.domain_name}\\terraform.adm"
    Restart = "true"
    Options = "3"
  })

  protected_settings = jsonencode({
    Password = local.domain_admin_pwd
  })

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "domain_join_uatiis01" {
  count                      = var.domain_admin_password_secret_name != null || var.domain_admin_password != null ? 1 : 0
  name                       = "DomainJoin"
  virtual_machine_id         = azurerm_windows_virtual_machine.uatiis01.id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    Name    = var.domain_name
    OUPath  = ""
    User    = "${var.domain_name}\\terraform.adm"
    Restart = "true"
    Options = "3"
  })

  protected_settings = jsonencode({
    Password = local.domain_admin_pwd
  })

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "domain_join_uatatlas01" {
  count                      = var.domain_admin_password_secret_name != null || var.domain_admin_password != null ? 1 : 0
  name                       = "DomainJoin"
  virtual_machine_id         = azurerm_windows_virtual_machine.uatatlas01.id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    Name    = var.domain_name
    OUPath  = ""
    User    = "${var.domain_name}\\terraform.adm"
    Restart = "true"
    Options = "3"
  })

  protected_settings = jsonencode({
    Password = local.domain_admin_pwd
  })

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "domain_join_uatsql01" {
  count                      = var.domain_admin_password_secret_name != null || var.domain_admin_password != null ? 1 : 0
  name                       = "DomainJoin"
  virtual_machine_id         = azurerm_windows_virtual_machine.uatsql01.id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    Name    = var.domain_name
    OUPath  = ""
    User    = "${var.domain_name}\\terraform.adm"
    Restart = "true"
    Options = "3"
  })

  protected_settings = jsonencode({
    Password = local.domain_admin_pwd
  })

  tags = var.tags
}