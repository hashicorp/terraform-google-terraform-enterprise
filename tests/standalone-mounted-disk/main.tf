resource "random_pet" "main" {
  length    = 1
  prefix    = "smd"
  separator = "-"
}

module "secrets" {
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
  source                = "../.."
  distribution          = "ubuntu"
  dns_zone_name         = data.google_dns_managed_zone.main.name
  fqdn                  = "${random_pet.main.id}.${trimsuffix(data.google_dns_managed_zone.main.dns_name, ".")}"
  namespace             = random_pet.main.id
  node_count            = 1
  tfe_license_secret_id = module.secrets.license_secret
  ssl_certificate_name  = "wildcard"

  iact_subnet_list       = ["0.0.0.0/0"]
  iact_subnet_time_limit = 60
  labels                 = local.labels
  load_balancer          = "PUBLIC"
  operational_mode       = "disk"
  vm_disk_source_image   = data.google_compute_image.ubuntu.self_link
  vm_machine_type        = "n1-standard-4"
  vm_metadata = {
    "ssh-keys" = "${local.ssh_user}:${tls_private_key.main.public_key_openssh} ${local.ssh_user}"
  }
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
