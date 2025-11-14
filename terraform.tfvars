# Resource Groups
network_rg_name = "UATNETRG"
servers_rg_name = "UATSERVERRG"

# Network
vnet_name = "UATSERVERVNET"

# Virtual Machines
dc1_name = "UATAD01"
dc2_name = "UATAD02"

# Security - Set your admin password here or via environment variable TF_VAR_admin_password
# admin_password = "YourSecurePasswordHere"

# Common Tags
tags = {
  BuildBy     = "Stormy"
  BuildDate   = "2025-11-10"
  Environment = "UAT"
  Function    = "CoreInfra"
}
