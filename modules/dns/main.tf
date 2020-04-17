locals {
  application_url = "https://${local.fqdn}"
  fqdn            = trimsuffix(local.record_set_name, ".")
  record_set_name = "${var.hostname}.${var.managed_zone_dns_name}"
}

resource "google_dns_record_set" "main" {
  managed_zone = var.managed_zone
  name         = local.record_set_name
  rrdatas      = [var.vpc_external_load_balancer_address]
  ttl          = 300
  type         = "A"
}
