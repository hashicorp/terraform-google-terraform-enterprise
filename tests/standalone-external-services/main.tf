resource "random_pet" "main" {
  length    = 1
  prefix    = "ses"
  separator = "-"
}

resource "google_secret_manager_secret" "license" {
  replication {
    automatic = true
  }
  secret_id = random_pet.main.id
}

resource "google_secret_manager_secret_version" "license" {
  secret      = google_secret_manager_secret.license.id
  secret_data = filebase64(var.license_file)
}

module "tfe" {
  source = "../.."

  dns_zone_name        = data.google_dns_managed_zone.main.name
  fqdn                 = "${random_pet.main.id}.${trimsuffix(data.google_dns_managed_zone.main.dns_name, ".")}"
  namespace            = random_pet.main.id
  node_count           = 1
  license_secret       = google_secret_manager_secret.license.secret_id
  ssl_certificate_name = "wildcard"

  iact_subnet_list       = ["0.0.0.0/0"]
  iact_subnet_time_limit = 60
  labels = {
    department  = "engineering"
    description = "standalone-external-services-scenario-deployed-from-circleci"
    environment = random_pet.main.id
    oktodelete  = "true"
    product     = "terraform-enterprise"
    repository  = "hashicorp-terraform-google-terraform-enterprise"
    team        = "terraform-enterprise-on-prem"
    terraform   = "true"
  }
  load_balancer        = "PUBLIC"
  operational_mode     = "external"
  vm_disk_source_image = data.google_compute_image.ubuntu.self_link
  vm_machine_type      = "n1-standard-4"
}
