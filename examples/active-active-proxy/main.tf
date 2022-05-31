resource "random_pet" "main" {
  length = 1
}

# Store TFE License as secret
# ---------------------------
module "secrets" {
  source = "../../fixtures/secrets"
  license = {
    id   = random_pet.main.id
    path = var.license_file
  }
}

# MITM Proxy
# ----------
module "test_proxy" {
  source = "../../fixtures/test_proxy"

  existing_service_account_id     = var.google.service_account
  instance_image                  = data.google_compute_image.ubuntu.id
  labels                          = var.labels
  mitmproxy_ca_certificate_secret = var.ca_certificate_secret_id
  mitmproxy_ca_private_key_secret = var.ca_private_key_secret_id
  name                            = "${random_pet.main.id}-proxy"
  network                         = module.active_active_proxy.network
  subnetwork                      = module.active_active_proxy.subnetwork
}

# Active/Active TFE Architecture
# ------------------------------
module "active_active_proxy" {
  source = "../../"

  ca_certificate_secret_id    = var.ca_certificate_secret_id
  distribution                = "rhel"
  dns_zone_name               = var.dns_zone_name
  existing_service_account_id = var.google.service_account
  fqdn                        = var.fqdn
  iact_subnet_list            = ["${module.test_proxy.compute_instance.network_interface[0].network_ip}/32"]
  iact_subnet_time_limit      = 1440
  labels                      = var.labels
  load_balancer               = "PRIVATE_TCP"
  namespace                   = random_pet.main.id
  node_count                  = var.node_count
  proxy_ip                    = module.test_proxy.proxy_ip
  proxy_port                  = module.test_proxy.proxy_port
  redis_auth_enabled          = true
  ssl_certificate_secret      = var.ssl_certificate_secret
  ssl_private_key_secret      = var.ssl_private_key_secret
  tfe_license_secret_id       = module.secrets.license_secret
  tls_bootstrap_cert_pathname = "/var/lib/terraform-enterprise/certificate.pem"
  tls_bootstrap_key_pathname  = "/var/lib/terraform-enterprise/key.pem"
  vm_disk_source_image        = data.google_compute_image.rhel.self_link
  vm_machine_type             = "n1-standard-32"
}