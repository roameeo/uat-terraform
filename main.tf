# Resource Groups Module
module "resource_groups" {
  source           = "./ResourceGroups"
  network_rg_name  = var.network_rg_name
  servers_rg_name  = var.servers_rg_name
  avd_rg_name      = var.avd_rg_name
  location         = var.location
  tags             = var.tags
}

# Network Module
module "network" {
  source          = "./Network"
  rg_name         = module.resource_groups.network_rg_name
  vnet_name       = var.vnet_name
  avd_rg_name     = module.resource_groups.avd_rg_name
  avd_vnet_name   = var.avd_vnet_name
  tags            = var.tags
  location        = var.location

  providers = {
    azurerm      = azurerm
    azurerm.prod = azurerm.prod
  }

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

# AVD Module
module "avd" {
  source                            = "./AVD"
  rg_name                           = module.resource_groups.avd_rg_name
  location                          = var.location
  tags                              = var.tags
  avd_subnet_id                     = module.network.avd_workspaces_subnet_id
  dns_servers                       = ["10.0.2.5", "10.0.2.4"]
  admin_username                    = var.admin_username
  admin_password                    = var.admin_password
  domain_name                       = var.domain_name
  domain_join_username              = var.domain_join_username
  domain_admin_password             = var.domain_admin_password
  key_vault_id                      = var.key_vault_id
  domain_admin_password_secret_name = var.domain_admin_password_secret_name

  depends_on = [module.network, module.compute]
}