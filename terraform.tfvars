# Resource Groups
network_rg_name = "UATNETRG"
servers_rg_name = "UATSERVERRG"
avd_rg_name     = "UATAVDRG"

# Network
vnet_name     = "UATSERVERVNET"
avd_vnet_name = "UATAVDVNET"

# Virtual Machines
dc1_name = "UATAD01"
dc2_name = "UATAD02"

# Security - Set your admin password here or via environment variable TF_VAR_admin_password
# admin_password = "YourSecurePasswordHere"

# Azure Key Vault Configuration
key_vault_id = "/subscriptions/f830b735-d380-4c43-b54b-73ba9ff8cd9d/resourceGroups/CUS-UAT-KV-RG/providers/Microsoft.KeyVault/vaults/CUS-UAT-KEYVAULT"

# Domain Admin Password Secret Name (for DC promotion)
domain_admin_password_secret_name = "TerraformDA"

# VM Password Secret Names (optional - for individual VM passwords from Key Vault)
# vm_password_secret_names = {
#   "UATSQL01" = "UATSQL01"
# }

# Common Tags
tags = {
  BuildBy     = "Stormy"
  BuildDate   = "2025-11-10"
  Environment = "UAT"
  Function    = "CoreInfra"
}
