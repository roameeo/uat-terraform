# Azure Virtual Desktop Configuration
# Host Pool: 5 × Standard_D16ds_v5, 4 sessions per host = 20 total capacity

# Random string for unique resource names
resource "random_string" "unique" {
  length  = 4
  special = false
  upper   = false
}

# Storage Account for FSLogix profiles (Premium Files for better performance)
resource "azurerm_storage_account" "fslogix" {
  name                     = "stfslogixuat${random_string.unique.result}"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Premium"
  account_replication_type = "LRS"
  account_kind             = "FileStorage"
  
  tags = var.tags
}

# File Share for FSLogix profiles (1TB initial quota)
resource "azurerm_storage_share" "fslogix_profiles" {
  name                 = "fslogix-profiles"
  storage_account_id   = azurerm_storage_account.fslogix.id
  quota                = 1024
}

# AVD Host Pool - Pooled with Breadth-First load balancing
resource "azurerm_virtual_desktop_host_pool" "main" {
  name                     = "UAT-HostPool"
  location                 = var.location
  resource_group_name      = var.rg_name
  type                     = "Pooled"
  load_balancer_type       = "BreadthFirst"
  friendly_name            = "UAT Host Pool"
  description              = "UAT Azure Virtual Desktop Host Pool - 5 hosts, 4 sessions each"
  validate_environment     = false
  start_vm_on_connect      = true
  maximum_sessions_allowed = 4

  tags = var.tags
}

# Registration token for session hosts (48 hour expiry)
resource "azurerm_virtual_desktop_host_pool_registration_info" "main" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.main.id
  expiration_date = timeadd(timestamp(), "48h")
}

# AVD Desktop Application Group
resource "azurerm_virtual_desktop_application_group" "main" {
  name                = "UAT-AppGroup"
  location            = var.location
  resource_group_name = var.rg_name
  type                = "Desktop"
  host_pool_id        = azurerm_virtual_desktop_host_pool.main.id
  friendly_name       = "UAT Desktop Application Group"
  description         = "Desktop Application Group for UAT"

  tags = var.tags
}

# AVD Workspace
resource "azurerm_virtual_desktop_workspace" "main" {
  name                = "UAT-Workspace"
  location            = var.location
  resource_group_name = var.rg_name
  friendly_name       = "UAT Workspace"
  description         = "UAT Azure Virtual Desktop Workspace"

  tags = var.tags
}

# Associate Application Group with Workspace
resource "azurerm_virtual_desktop_workspace_application_group_association" "main" {
  workspace_id         = azurerm_virtual_desktop_workspace.main.id
  application_group_id = azurerm_virtual_desktop_application_group.main.id
}

# Session Host NICs (5 hosts)
resource "azurerm_network_interface" "avd_session_hosts" {
  count               = 5
  name                = "avd-uat-${count.index + 1}-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.avd_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  dns_servers = var.dns_servers

  tags = var.tags
}

# Session Host VMs - Standard_D16ds_v5 (16 vCPU, 64 GB RAM, 512 GB disk)
resource "azurerm_windows_virtual_machine" "avd_session_hosts" {
  count               = 5
  name                = "AVD-UAT-${count.index + 1}"
  location            = var.location
  resource_group_name = var.rg_name
  size                = "Standard_D16ds_v5"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.avd_session_hosts[count.index].id
  ]

  os_disk {
    name                 = "AVD-UAT-${count.index + 1}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 512
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "office-365"
    sku       = "win11-25h2-avd-m365"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [admin_password]
  }

  tags = var.tags
}

# Domain Join Extension for Session Hosts
resource "azurerm_virtual_machine_extension" "domain_join_avd" {
  count                      = 5
  name                       = "DomainJoin"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_session_hosts[count.index].id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    Name    = var.domain_name
    User    = "${var.domain_name}\\${var.domain_join_username}"
    Restart = "true"
    Options = "3"
  })

  protected_settings = jsonencode({
    Password = var.domain_admin_password
  })

  tags = var.tags

  depends_on = [
    azurerm_windows_virtual_machine.avd_session_hosts
  ]
}

# DSC Extension to register session hosts with AVD
resource "azurerm_virtual_machine_extension" "avd_dsc" {
  count                      = 5
  name                       = "Microsoft.PowerShell.DSC"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_session_hosts[count.index].id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    modulesUrl            = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip"
    configurationFunction = "Configuration.ps1\\AddSessionHost"
    properties = {
      hostPoolName          = azurerm_virtual_desktop_host_pool.main.name
      registrationInfoToken = azurerm_virtual_desktop_host_pool_registration_info.main.token
      aadJoin               = false
    }
  })

  tags = var.tags

  depends_on = [
    azurerm_virtual_machine_extension.domain_join_avd
  ]
}

# FSLogix Configuration Extension
resource "azurerm_virtual_machine_extension" "fslogix" {
  count                      = 5
  name                       = "FSLogixConfig"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_session_hosts[count.index].id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -Command \"New-Item -Path 'HKLM:\\SOFTWARE\\FSLogix\\Profiles' -Force; New-ItemProperty -Path 'HKLM:\\SOFTWARE\\FSLogix\\Profiles' -Name 'Enabled' -Value 1 -PropertyType DWORD -Force; New-ItemProperty -Path 'HKLM:\\SOFTWARE\\FSLogix\\Profiles' -Name 'VHDLocations' -Value '\\\\${azurerm_storage_account.fslogix.name}.file.core.windows.net\\fslogix-profiles' -PropertyType MultiString -Force; New-ItemProperty -Path 'HKLM:\\SOFTWARE\\FSLogix\\Profiles' -Name 'DeleteLocalProfileWhenVHDShouldApply' -Value 1 -PropertyType DWORD -Force; New-ItemProperty -Path 'HKLM:\\SOFTWARE\\FSLogix\\Profiles' -Name 'SizeInMBs' -Value 30720 -PropertyType DWORD -Force\""
  })

  tags = var.tags

  depends_on = [
    azurerm_virtual_machine_extension.avd_dsc
  ]
}

# AVD Scaling Plan with Power Management
# Note: The scaling plan is commented out for now. You'll need to create it manually in Azure portal
# or configure the required enterprise application permissions first.
# The "Azure Virtual Desktop" service principal needs "Desktop Virtualization Power On Off Contributor" role.
/*
resource "azurerm_virtual_desktop_scaling_plan" "main" {
  name                = "UAT-ScalingPlan"
  location            = var.location
  resource_group_name = var.rg_name
  friendly_name       = "UAT Autoscale Plan"
  description         = "Power management scaling for UAT AVD - 2-5 hosts weekdays, 1 host off-hours"
  time_zone           = "Central Standard Time"
  
  host_pool {
    hostpool_id          = azurerm_virtual_desktop_host_pool.main.id
    scaling_plan_enabled = true
  }

  # Weekday Schedule (Monday-Friday)
  schedule {
    name                                 = "Weekday-EarlyRampUp"
    days_of_week                         = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    ramp_up_start_time                   = "05:30"
    ramp_up_load_balancing_algorithm     = "BreadthFirst"
    ramp_up_minimum_hosts_percent        = 40  # 2 of 5 hosts
    ramp_up_capacity_threshold_percent   = 65
    
    peak_start_time                      = "06:00"
    peak_load_balancing_algorithm        = "BreadthFirst"
    
    ramp_down_start_time                 = "17:00"
    ramp_down_load_balancing_algorithm   = "BreadthFirst"
    ramp_down_minimum_hosts_percent      = 40  # 2 of 5 hosts
    ramp_down_capacity_threshold_percent = 65
    ramp_down_force_logoff_users         = true
    ramp_down_wait_time_minutes          = 30
    ramp_down_notification_message       = "Your session will be logged off in 30 minutes. Please save your work."
    ramp_down_stop_hosts_when            = "ZeroSessions"
    
    off_peak_start_time                  = "19:00"
    off_peak_load_balancing_algorithm    = "BreadthFirst"
  }

  # Weekend Schedule (Saturday-Sunday)
  schedule {
    name                                 = "Weekend-MinimalCapacity"
    days_of_week                         = ["Saturday", "Sunday"]
    ramp_up_start_time                   = "06:00"
    ramp_up_load_balancing_algorithm     = "BreadthFirst"
    ramp_up_minimum_hosts_percent        = 20  # 1 of 5 hosts
    ramp_up_capacity_threshold_percent   = 65
    
    peak_start_time                      = "09:00"
    peak_load_balancing_algorithm        = "BreadthFirst"
    
    ramp_down_start_time                 = "17:00"
    ramp_down_load_balancing_algorithm   = "BreadthFirst"
    ramp_down_minimum_hosts_percent      = 20  # 1 of 5 hosts
    ramp_down_capacity_threshold_percent = 65
    ramp_down_force_logoff_users         = false
    ramp_down_wait_time_minutes          = 30
    ramp_down_notification_message       = "Your session will be logged off in 30 minutes. Please save your work."
    ramp_down_stop_hosts_when            = "ZeroSessions"
    
    off_peak_start_time                  = "20:00"
    off_peak_load_balancing_algorithm    = "BreadthFirst"
  }

  tags = var.tags
}
*/
