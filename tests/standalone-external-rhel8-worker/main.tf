resource "random_pet" "main" {
  length    = 1
  prefix    = "ses"
  separator = "-"
}

# Store TFE License as secret
# ---------------------------
module "secrets" {
  count  = length(var.license_file) > 0 ? 1 : 0
  source = "../../fixtures/secrets"

  license = {
    id   = random_pet.main.id
    path = var.license_file
  }
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  filename = "${path.module}/work/private-key.pem"

  content         = tls_private_key.main.private_key_pem
  file_permission = "0600"
}

module "tfe" {
  source = "../.."

  distribution                = "rhel"
  dns_zone_name               = data.google_dns_managed_zone.main.name
  fqdn                        = "${random_pet.main.id}.${trimsuffix(data.google_dns_managed_zone.main.dns_name, ".")}"
  namespace                   = random_pet.main.id
  node_count                  = 1
  tfe_license_secret_id       = try(module.secrets[0].license_secret, data.tfe_outputs.base.values.license_secret_id)
  ssl_certificate_name        = data.tfe_outputs.base.values.wildcard_ssl_certificate_name
  existing_service_account_id = var.existing_service_account_id
  custom_image_tag            = "${local.repository_location}-docker.pkg.dev/ptfe-testing/${local.repository_name}/rhel-7.9:latest"
  iact_subnet_list            = ["0.0.0.0/0"]
  iact_subnet_time_limit      = 60
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
  vm_disk_source_image = data.google_compute_image.rhel.self_link
  vm_machine_type      = "n1-standard-4"
  vm_metadata = {
    "ssh-keys" = "${local.ssh_user}:${tls_private_key.main.public_key_openssh} ${local.ssh_user}"
  }
}

resource "google_artifact_registry_repository_iam_member" "main" {
  provider   = google-beta
  count      = var.existing_service_account_id == null ? 1 : 0
  location   = local.repository_location
  member     = "serviceAccount:${module.tfe.service_account.email}"
  repository = local.repository_name
  role       = "roles/artifactregistry.reader"
}

resource "null_resource" "wait_for_instances" {
  triggers = {
    self_link = module.tfe.vm_mig.instance_group
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "local_file" "ssh_config" {
  filename = "${path.module}/work/ssh-config"

  content = templatefile(
    "${path.module}/templates/ssh-config.tpl",
    {
      instance      = data.null_data_source.instance.outputs
      identity_file = local_file.private_key_pem.filename
      user          = local.ssh_user
    }
  )
}
