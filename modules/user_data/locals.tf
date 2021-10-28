locals {
  base_settings = {
    archivist_token = {
      value = random_id.archivist_token.hex
    }

    capacity_concurrency = {
      value = var.capacity_concurrency
    }

    capacity_memory = {
      value = var.capacity_memory
    }

    ca_certs = {
      value = var.ca_certs
    }

    cookie_hash = {
      value = random_id.cookie_hash.hex
    }

    custom_image_tag = {
      value = var.custom_image_tag
    }

    enable_active_active = {
      # This will be overwritten if var.enable_active_active == true
      value = "0"
    }

    enable_metrics_collection = {
      value = var.enable_metrics_collection
    }

    enc_password = {
      value = random_id.enc_password.hex
    }

    extra_no_proxy = {
      value = join(",", var.extra_no_proxy)
    }

    hairpin_addressing = {
      value = var.hairpin_addressing ? "1" : "0"
    }

    hostname = {
      value = var.fqdn
    }

    iact_subnet_list = {
      value = join(",", var.iact_subnet_list)
    }

    iact_subnet_time_limit = {
      value = var.iact_subnet_time_limit != null ? tostring(var.iact_subnet_time_limit) : ""
    }

    install_id = {
      value = random_id.install_id.hex
    }

    installation_type = {
      # This will be overwritten if enable_disk == true or enable_external == true
      value = "poc"
    }

    internal_api_token = {
      value = random_id.internal_api_token.hex
    }

    registry_session_encryption_key = {
      value = random_id.registry_session_encryption_key.hex
    }

    registry_session_secret_key = {
      value = random_id.registry_session_secret_key.hex
    }

    root_secret = {
      value = random_id.root_secret.hex
    }

    tbw_image = {
      value = var.custom_image_tag == null ? "default_image" : "custom_image"
    }

    tls_vers = {
      value = var.tls_vers
    }

    trusted_proxies = {
      value = join(",", var.trusted_proxies)
    }

    user_token = {
      value = random_id.user_token.hex
    }
  }

  disk_settings = var.enable_disk ? {
    installation_type = {
      value = "production"
    }

    production_type = {
      value = "disk"
    }

    disk_path = {
      value = var.disk_path
    }
  } : {}

  external_settings = var.enable_external ? {
    installation_type = {
      value = "production"
    }

    production_type = {
      value = "external"
    }

    gcs_bucket = {
      value = var.gcs_bucket
    }

    gcs_credentials = {
      value = var.gcs_credentials
    }

    gcs_project = {
      value = var.gcs_project
    }

    placement = {
      value = "placement_gcs"
    }

    pg_dbname = {
      value = var.pg_dbname
    }

    pg_extra_params = {
      value = var.pg_extra_params
    }

    pg_netloc = {
      value = var.pg_netloc
    }

    pg_password = {
      value = var.pg_password
    }

    pg_user = {
      value = var.pg_user
    }
  } : {}

  active_active_settings = var.enable_active_active ? {
    enable_active_active = {
      value = "1"
    }

    redis_host = {
      value = var.redis_host
    }

    redis_pass = {
      value = var.redis_pass
    }

    redis_port = {
      value = var.redis_port
    }

    redis_use_password_auth = {
      value = var.redis_use_password_auth ? "1" : "0"
    }

    redis_use_tls = {
      value = var.redis_use_tls ? "1" : "0"
    }
  } : {}

  license_file_location = "/etc/ptfe-license.rli"
  settings_pathname     = "/etc/ptfe-settings.json"
  replicated_base_config = {
    BypassPreflightChecks        = true
    DaemonAuthenticationPassword = random_string.password.result
    DaemonAuthenticationType     = "password"
    ImportSettingsFrom           = local.settings_pathname
    LicenseFileLocation          = local.license_file_location
    TlsBootstrapHostname         = var.fqdn
  }

  lib_directory   = "/var/lib/ptfe"
  airgap_pathname = "${local.lib_directory}/ptfe.airgap"

  airgap_config = {
    LicenseBootstrapAirgapPackagePath = local.airgap_pathname
  }

  release_pin_config = {
    ReleaseSequence = var.release_sequence
  }

  # Build tfe config json
  # take all the partials and merge them into the base configs, if false, merging empty map is noop
  settings = jsonencode(merge(
    local.base_settings,
    local.disk_settings,
    local.external_settings,
    local.active_active_settings
    )
  )

  # build replicated config json
  is_airgap                = var.airgap_url == null ? {} : local.airgap_config
  is_pinned                = var.release_sequence != 0 ? local.release_pin_config : {}
  ssl_certificate_pathname = "${local.lib_directory}/certificate.pem"
  ssl_private_key_pathname = "${local.lib_directory}/private-key.pem"
  tls = (var.ssl_certificate_secret == null || var.ssl_private_key_secret == null) ? {
    TlsBootstrapType = "self-signed"
    } : {
    TlsBootstrapCert = local.ssl_certificate_pathname
    TlsBootstrapKey  = local.ssl_private_key_pathname
    TlsBootstrapType = "server-path"
  }

  repl_configs = jsonencode(merge(local.replicated_base_config, local.is_airgap, local.is_pinned, local.tls))

  user_data = templatefile(
    "${path.module}/templates/tfe_vm.sh.tpl",
    {
      airgap_pathname          = local.airgap_pathname
      airgap_url               = var.airgap_url
      ca_certificate_secret    = var.ca_certificate_secret
      custom_image_tag         = var.custom_image_tag
      disk_device_name         = var.disk_device_name
      disk_path                = var.enable_disk ? var.disk_path : null
      docker_config            = filebase64("${path.module}/files/daemon.json")
      bucket_name              = var.gcs_bucket
      lib_directory            = local.lib_directory
      license_file_location    = local.license_file_location
      license_secret           = var.license_secret
      monitoring_enabled       = var.monitoring_enabled
      replicated               = base64encode(local.repl_configs)
      settings                 = base64encode(local.settings)
      enable_active_active     = var.enable_active_active
      namespace                = var.namespace
      proxy_ip                 = var.proxy_ip
      settings_pathname        = local.settings_pathname
      ssl_certificate_pathname = local.ssl_certificate_pathname
      ssl_certificate_secret   = var.ssl_certificate_secret
      ssl_private_key_pathname = local.ssl_private_key_pathname
      ssl_private_key_secret   = var.ssl_private_key_secret
      no_proxy = join(
        ",",
        concat(
          [
            "127.0.0.1",
            "169.254.169.254",
            ".googleapis.com",
            ".google.internal",
            ".googlecloud.com",
          ],
          var.no_proxy
        )
      )
    }
  )
}
