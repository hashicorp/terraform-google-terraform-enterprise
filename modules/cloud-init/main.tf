locals {
  assistant_host = "http://${var.proxy_address}:23010"
  base_cloud_config = templatefile(
    "${path.module}/templates/base-cloud-config.yaml.tmpl",
    {
      assistant_host  = local.assistant_host
      assistant_token = random_string.setup_token.result
      bootstrap_token = (
        "${random_string.bootstrap_token_id.result}.${random_string.bootstrap_token_suffix.result}"
      )
      cluster_api_endpoint    = "${var.proxy_address}:6443"
      custom_ca_cert_url      = var.custom_ca_cert_url
      distrobution            = var.distribution
      health_url              = "${local.assistant_host}/healthz"
      install_ptfe_sh         = file("${path.module}/files/install-ptfe.sh")
      proxy_conf              = templatefile("${path.module}/templates/proxy.conf.tmpl", { proxy_url = var.proxy_url })
      proxy_url               = var.proxy_url
      ptfe_url                = var.ptfe_url
      ssh_import_id_usernames = var.ssh_import_id_usernames
    }
  )
  main_and_primary_cloud_configs = [
    templatefile(
      "${path.module}/templates/main-cloud-config.yaml.tmpl",
      {
        airgap_installer_url = var.airgap_installer_url
        airgap_package_url   = var.airgap_package_url
        primary_cloud_config = local.primary_cloud_configs[0]
        repl_cidr            = var.repl_cidr
        replicated_conf = templatefile(
          "${path.module}/templates/replicated.conf.tmpl",
          {
            airgap           = var.airgap_package_url != ""
            console_password = random_pet.console_password.id
            proxy_url        = var.proxy_url
            release_sequence = var.release_sequence
          }
        )
        replicated_rli       = var.license_file
        replicated_ptfe_conf = jsonencode(var.application_config)
        weave_cidr           = var.weave_cidr
      }
    ),
    local.primary_cloud_configs[1],
    local.primary_cloud_configs[2]
  ]
  primary_cloud_configs = [
    for role_id in [0, 1, 2] : templatefile(
      "${path.module}/templates/primary-cloud-config.yaml.tmpl",
      {
        base_cloud_config = local.base_cloud_config
        primary_pki_url   = "${local.assistant_host}/api/v1/pki-download?token=${random_string.setup_token.result}"
        proxy_sh = templatefile(
          "${path.module}/templates/proxy.sh.tmpl",
          { proxy_url = var.proxy_url, repl_cidr = var.repl_cidr }
        )
        role_id     = role_id
        setup_token = random_string.setup_token.result
      }
    )
  ]
  secondary_cloud_config = templatefile(
    "${path.module}/templates/secondary-cloud-config.yaml.tmpl",
    { base_cloud_config = local.base_cloud_config }
  )
}

resource "random_pet" "console_password" {
  length = 3
}

resource "random_string" "bootstrap_token_id" {
  length  = 6
  special = false
  upper   = false
}

resource "random_string" "setup_token" {
  length  = 32
  special = false
  upper   = false
}

resource "random_string" "bootstrap_token_suffix" {
  length  = 16
  upper   = false
  special = false
}

data "template_cloudinit_config" "primaries" {
  count = 3

  part {
    content = local.main_and_primary_cloud_configs[count.index]

    content_type = "text/cloud-config"
  }

  base64_encode = true
  gzip          = true
}

data "template_cloudinit_config" "secondary" {
  part {
    content = local.secondary_cloud_config

    content_type = "text/cloud-config"
  }

  base64_encode = true
  gzip          = true
}
