# Resource Groups
network_rg_name = "UATNETRG"
servers_rg_name = "UATSERVERRG"

# Network
vnet_name     = "UATSERVERVNET"

# Virtual Machines
dc1_name = "UATAD01"
dc2_name = "UATAD02"

# Security - Set your admin password here or via environment variable TF_VAR_admin_password
# admin_password = "YourSecurePasswordHere"

# Azure Key Vault Configuration
key_vault_id = "/subscriptions/f830b735-d380-4c43-b54b-73ba9ff8cd9d/resourceGroups/CUS-UAT-KV-RG/providers/Microsoft.KeyVault/vaults/CUS-UAT-KEYVAULT"

# Domain Admin Password Secret Name (for DC promotion)
domain_admin_password_secret_name = "TerraformDA"

# VM Password Secret Names (for individual VM passwords from Key Vault)
vm_password_secret_names = {
  "UATAD01"    = "UATAD01"
  "UATAD02"    = "UATAD02"
  "UATATLAS01" = "UATATLAS01"
  "UATIIS01"   = "UATIIS01"
  "UATMULTI01" = "UATMULTI01"
  "UATSQL01"   = "UATSQL01"
}

# Meraki vMX Configuration
meraki_token = "c1e2203eb8dbe5a2aba404fa27a6e74f/4ed9e72dd788f56f5b6511b40225768730c208a7f352e7ea51482f403c79fe5e495ae819752480fc82d4579518383d9c3303963d4ab2da2ef1fb217a8ec69c0d/ccf71c54467ab6084ca403f4f2352d6ca5194b4ee82d2301961c38f27832e9ba"
vmx_vm_size  = "Standard_D3_v2"
vmx_hostname = "UATVMX01"

# Common Tags
tags = {
  BuildBy     = "Stormy"
  BuildDate   = "2025-11-10"
  Environment = "UAT"
  Function    = "CoreInfra"
}
