# Resource Groups Module
module "resource_groups" {
  source           = "./ResourceGroups"
  network_rg_name  = var.network_rg_name
  servers_rg_name  = var.servers_rg_name
  location         = var.location
  tags             = var.tags
}

# Network Module
module "network" {
  source          = "./Network"
  rg_name         = module.resource_groups.network_rg_name
  vnet_name       = var.vnet_name
  tags            = var.tags
  location        = var.location

  depends_on = [module.resource_groups]
}

# Compute Module
module "compute" {
  source                            = "./Compute"
  rg_name                           = module.resource_groups.servers_rg_name
  dc1_name                          = var.dc1_name
  dc2_name                          = var.dc2_name
  ad_subnet_id                      = module.network.ad_subnet_id
  application_subnet_id             = module.network.application_subnet_id
  sql_subnet_id                     = module.network.sql_subnet_id
  tags                              = var.tags
  admin_password                    = var.admin_password
  domain_name                       = var.domain_name
  domain_admin_password             = var.domain_admin_password
  domain_admin_password_secret_name = var.domain_admin_password_secret_name
  key_vault_id                      = var.key_vault_id
  vm_password_secret_names          = var.vm_password_secret_names
  location                          = var.location

  depends_on = [module.network]
}

# Meraki Module
# Note: vMX deployed as Azure Managed Application from Meraki Dashboard
# Managed by portal, not Terraform - resources are in managed RG: mrg-cisco-meraki-vmx-20251203082153
# module "meraki" {
#   source         = "./Meraki"
#   rg_name        = module.resource_groups.network_rg_name
#   location       = var.location
#   dmz_subnet_id  = module.network.dmz_subnet_id
#   meraki_token   = var.meraki_token
#   vmx_vm_size    = var.vmx_vm_size
#   vmx_hostname   = var.vmx_hostname
#   admin_username = var.admin_username
#   admin_password = var.admin_password
#   tags           = var.tags
#
#   depends_on = [module.network]
# }