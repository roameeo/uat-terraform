module "network" {
  source          = "./network"
  rg_name         = var.rg_name
  vnet_name       = var.vnet_name
  subnet_name_ad  = var.subnet_name_ad
  tags            = var.tags
  location        = var.location
}

module "compute" {
  source        = "./compute"
  rg_name       = var.rg_name
  dc1_name      = var.dc1_name
  dc2_name      = var.dc2_name
  ad_subnet_id  = module.network.ad_subnet_id
  tags          = var.tags
}