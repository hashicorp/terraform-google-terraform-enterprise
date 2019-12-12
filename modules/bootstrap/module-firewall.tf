module "firewall" {
  source        = "./modules/firewall-vpc"
  region        = var.region
  name          = "${var.name}-${random_id.db_name_suffix.hex}"
  healthchk_ips = var.healthchk_ips
  subnet_range  = var.subnet_range
}

