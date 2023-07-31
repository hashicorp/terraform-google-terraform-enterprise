# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  base_configs = {
    hostname = {
      value = var.hostname
    }

    production_type = {
      value = var.production_type
    }

    # Alphabetical starting here
    archivist_token = {
      value = random_id.archivist_token.hex
    }

    backup_token = {
      value = var.backup_token
    }

    capacity_concurrency = {
      value = var.capacity_concurrency != null ? tostring(var.capacity_concurrency) : null
    }

    capacity_memory = {
      value = var.capacity_memory != null ? tostring(var.capacity_memory) : null
    }

    capacity_cpus = {
      value = var.capacity_cpus != null ? tostring(var.capacity_cpus) : null
    }

    cookie_hash = {
      value = random_id.cookie_hash.hex
    }

    consolidated_services = {
      value = var.consolidated_services != null ? var.consolidated_services ? "1" : "0" : null
    }

    custom_image_tag = {
      value = var.custom_agent_image_tag != null ? null : var.custom_image_tag
    }

    custom_agent_image_tag = {
      value = var.custom_agent_image_tag
    }

    disk_path = {
      value = var.disk_path
    }

    enc_password = {
      value = var.extern_vault_enable != null ? var.extern_vault_enable ? null : random_id.enc_password.hex : random_id.enc_password.hex
    }

    extra_no_proxy = {
      value = var.extra_no_proxy != null ? join(",", var.extra_no_proxy) : null
    }

    hairpin_addressing = {
      value = var.hairpin_addressing != null ? var.hairpin_addressing ? "1" : "0" : null
    }

    force_tls = {
      value = var.force_tls != null ? var.force_tls ? "1" : "0" : null
    }

    iact_subnet_list = {
      value = var.iact_subnet_list != null ? join(",", var.iact_subnet_list) : null
    }

    iact_subnet_time_limit = {
      value = var.iact_subnet_time_limit
    }

    install_id = {
      value = random_id.install_id.hex
    }

    internal_api_token = {
      value = random_id.internal_api_token.hex
    }

    metrics_endpoint_enabled = {
      value = var.metrics_endpoint_enabled != null ? var.metrics_endpoint_enabled ? "1" : "0" : null
    }

    metrics_endpoint_port_http = {
      value = var.metrics_endpoint_port_http != null ? tostring(var.metrics_endpoint_port_http) : null
    }

    metrics_endpoint_port_https = {
      value = var.metrics_endpoint_port_https != null ? tostring(var.metrics_endpoint_port_https) : null
    }

    placement = {
      value = (var.production_type == "external" && var.s3_bucket != null) ? "placement_s3" : (
        var.production_type == "external" && var.azure_account_name != null) ? "placement_azure" : (
      var.production_type == "external" && var.gcs_bucket != null) ? "placement_gcs" : null
    }

    registry_session_encryption_key = {
      value = random_id.registry_session_encryption_key.hex
    }

    registry_session_secret_key = {
      value = random_id.registry_session_secret_key.hex
    }

    restrict_worker_metadata_access = {
      value = var.restrict_worker_metadata_access != null ? var.restrict_worker_metadata_access ? "1" : "0" : null
    }

    root_secret = {
      value = random_id.root_secret.hex
    }

    run_pipeline_mode = {
      value = var.custom_image_tag != null ? "legacy" : "agent"
    }

    tbw_image = {
      value = var.custom_image_tag != null ? "custom_image" : null
    }

    tls_ciphers = {
      value = var.tls_ciphers
    }

    tls_vers = {
      value = var.tls_vers
    }

    trusted_proxies = {
      value = var.trusted_proxies != null ? join(",", var.trusted_proxies) : null
    }

    user_token = {
      value = random_id.user_token.hex
    }
  }
}

