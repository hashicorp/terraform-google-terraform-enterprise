module "tfe" {
  source = "../../"

  namespace            = var.namespace
  node_count           = 1
  tfe_license_path     = var.tfe_license_path
  tfe_license_name     = var.tfe_license_name
  fqdn                 = var.fqdn
  ssl_certificate_name = var.ssl_certificate_name
  dns_zone_name        = var.dns_zone_name
  load_balancer        = "PUBLIC"
}
