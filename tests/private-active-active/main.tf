resource "random_pet" "main" {
  length    = 1
  prefix    = "praa"
  separator = "-"
}

module "test_proxy" {
  source = "../../fixtures/test_proxy"

  instance_image              = data.google_compute_image.ubuntu.id
  name                        = local.name
  network                     = module.tfe.network
  subnetwork                  = module.tfe.subnetwork
  existing_service_account_id = local.existing_service_account_id

  labels = local.labels
}

module "tfe" {
  source = "../.."

  distribution                = "rhel"
  dns_zone_name               = data.google_dns_managed_zone.main.name
  fqdn                        = "private-active-active.${data.google_dns_managed_zone.main.dns_name}"
  namespace                   = random_pet.main.id
  existing_service_account_id = local.existing_service_account_id
  node_count                  = 2
  tfe_license_secret_id       = data.tfe_outputs.base.values.license_secret_id
  ssl_certificate_name        = data.tfe_outputs.base.values.wildcard_region_ssl_certificate_name
  labels                      = local.labels
  iact_subnet_list            = ["${module.test_proxy.compute_instance.network_interface[0].network_ip}/32"]
  iact_subnet_time_limit      = 1440
  load_balancer               = "PRIVATE"
  proxy_ip                    = module.test_proxy.proxy_ip
  proxy_port                  = module.test_proxy.proxy_port
  redis_auth_enabled          = true
  vm_disk_source_image        = data.google_compute_image.rhel.self_link
  vm_machine_type             = "n1-standard-16"
}
