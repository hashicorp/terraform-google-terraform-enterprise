locals {
  config = {
    ca_certs = {
      value = var.ca_certs
    }

    capacity_memory = {
      value = var.capacity_memory
    }

    custom_image_name = {
      value = var.custom_image_name
    }

    enc_password = {
      value = var.enc_password
    }

    extern_vault_addr = {
      value = var.extern_vault_addr
    }

    extern_vault_enable = {
      value = var.extern_vault_addr == null ? "0" : "1"
    }

    extern_vault_path = {
      value = var.extern_vault_path
    }

    extern_vault_role_id = {
      value = var.extern_vault_role_id
    }

    extern_vault_secret_id = {
      value = var.extern_vault_secret_id
    }

    extern_vault_token_renew = {
      value = var.extern_vault_token_renew
    }

    extra_no_proxy = {
      value = join(",", var.additional_no_proxy)
    }

    gcs_bucket = {
      value = var.storage_bucket_name
    }

    gcs_credentials = {
      # This is required because when we use the value later, it needs to be one line otherwise
      # the templating breaks inside kubernetes. That should be addressed as well, but until then
      # we do it here.
      value = replace(base64decode(var.service_account_storage_key_private_key), "\n", "")
    }

    gcs_project = {
      value = var.storage_bucket_project
    }

    hostname = {
      value = var.dns_fqdn
    }

    iact_subnet_list = {
      value = join(",", var.iact_subnet_list)
    }

    iact_subnet_time_limit = {
      value = var.iact_subnet_time_limit
    }

    installation_type = {
      value = "production"
    }

    pg_dbname = {
      value = var.postgresql_database_name
    }

    postgresql_extra_params = {
      value = join("&", [for key, value in var.postgresql_extra_params : "${key}=${value}"])
    }

    pg_netloc = {
      value = var.postgresql_database_instance_address
    }

    pg_password = {
      value = var.postgresql_user_password
    }

    pg_user = {
      value = var.postgresql_user_name
    }

    placement = {
      value = "placement_gcs"
    }

    production_type = {
      value = "external"
    }

    tbw_image = {
      value = var.tbw_image
    }

    tls_vers = {
      value = var.tls_vers
    }
  }
}
