resource "random_string" "default_enc_password" {
  length  = 32
  upper   = true
  special = false
}

locals {
  encryption_password = var.encryption_password != "" ? var.encryption_password : random_string.default_enc_password.result

  base_config = {
    hostname = {
      value = var.external_name
    }

    enc_password = {
      value = local.encryption_password
    }

    ca_certs = {
      value = var.ca_certs
    }

    tls_vers = {
      value = var.tls_versions
    }

    capacity_memory = {
      value = var.worker_memory
    }

    extra_no_proxy = {
      value = var.extra_no_proxy
    }

    tbw_image = {
      value = var.custom_image != "" ? "custom_image" : "default_image"
    }

    custom_image_name = {
      value = var.custom_image
    }

    iact_subnet_list = {
      value = var.iact_subnet_list
    }

    iact_subnet_time_limit = {
      value = var.iact_subnet_time_limit
    }
  }

  external_vault_config = {
    extern_value_enable = {
      value = "1"
    }

    extern_vault_addr = {
      value = var.external_vault_addr
    }

    extern_vault_role_id = {
      value = var.external_vault_role_id
    }

    extern_vault_secret_id = {
      value = var.external_vault_secret_id
    }

    extern_vault_path = {
      value = var.external_vault_path
    }

    extern_vault_token_renew = {
      value = var.external_vault_token_renew
    }
  }

  use_ex_vault = var.external_vault_addr != "" ? local.external_vault_config : {}
  repl_config  = merge(local.base_config, var.services_config.config)
}

