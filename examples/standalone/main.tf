module "tfe" {
  source = "../../"

  namespace            = var.namespace
  node_count           = 1
  license_secret       = var.license_secret
  fqdn                 = var.fqdn
  ssl_certificate_name = var.ssl_certificate_name
  dns_zone_name        = var.dns_zone_name
  load_balancer        = "PUBLIC"
}
