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
  source                = "./Compute"
  rg_name               = module.resource_groups.servers_rg_name
  dc1_name              = var.dc1_name
  dc2_name              = var.dc2_name
  ad_subnet_id          = module.network.ad_subnet_id
  application_subnet_id = module.network.application_subnet_id
  tags                  = var.tags
  admin_password        = var.admin_password
  location              = var.location

  depends_on = [module.network]
}