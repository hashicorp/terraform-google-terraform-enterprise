locals {
  common = {
    ptfe-assistant-host = base64encode(
      "http://${var.vpc_primaries_load_balancer_address}:${var.vpc_cluster_assistant_tcp_port}"
    )
    ptfe-assistant-token = base64encode(random_string.assistant_token.result)
    ptfe-bootstrap-token = base64encode(
      "${random_string.bootstrap_token_id.result}.${random_string.bootstrap_token_suffix.result}"
    )
    ptfe-cluster-api-endpoint = base64encode(
      "${var.vpc_primaries_load_balancer_address}:${var.vpc_kubernetes_tcp_port}"
    )
    ptfe-http-proxy = base64encode(var.http_proxy)
    ptfe-no-proxy = base64encode(
      join(
        ",",
        concat(
          compact(
            [
              "10.0.0.0/8",
              "127.0.0.1",
              "169.254.169.254",
              "metadata",
              "metadata.google.internal",
              var.vpc_primaries_load_balancer_address,
              var.service_cidr
            ]
          ),
          var.no_proxy
        )
      )
    )
    ptfe-url = base64encode(var.ptfe_url)
  }
  main_metadata = {
    ptfe-airgap-installer-url     = base64encode(var.airgap_installer_url)
    ptfe-airgap-package-url       = base64encode(var.airgap_package_url)
    ptfe-auth-token               = base64encode(random_string.auth_token.result)
    ptfe-ca-certs-url             = base64encode(var.ca_certs_url)
    ptfe-capacity-memory          = base64encode(var.capacity_memory)
    ptfe-custom-image-name        = base64encode(var.custom_image_name)
    ptfe-enc-password             = base64encode(var.enc_password)
    ptfe-extern-vault-addr        = base64encode(var.extern_vault_addr)
    ptfe-extern-vault-enable      = base64encode(var.extern_vault_enable)
    ptfe-extern-vault-path        = base64encode(var.extern_vault_path)
    ptfe-extern-vault-role-id     = base64encode(var.extern_vault_role_id)
    ptfe-extern-vault-secret-id   = base64encode(var.extern_vault_secret_id)
    ptfe-extern-vault-token-renew = base64encode(var.extern_vault_token_renew)
    ptfe-gcs-bucket               = base64encode(var.storage_bucket_name)
    # The value must be one line to be compatible with the templating inside Kubernetes.
    # The value must be escaped for jq processing
    ptfe-gcs-credentials = base64encode(
      replace(replace(base64decode(var.service_account_storage_key_private_key), "\n", ""), "\"", "\\\"")
    )
    ptfe-gcs-project                = base64encode(var.storage_bucket_project)
    ptfe-hostname                   = base64encode(var.dns_fqdn)
    ptfe-iact-subnet-list           = base64encode(join(",", var.iact_subnet_list))
    ptfe-iact-subnet-time-limit     = base64encode(var.iact_subnet_time_limit)
    ptfe-install-dashboard-password = base64encode(random_pet.install_dashboard_password.id)
    ptfe-ip-alloc-range             = base64encode(var.ip_alloc_range)
    ptfe-license-url                = base64encode(var.license_url)
    ptfe-pg-dbname                  = base64encode(var.postgresql_database_name)
    ptfe-pg-netloc                  = base64encode(var.postgresql_database_instance_address)
    ptfe-pg-password                = base64encode(var.postgresql_user_password)
    ptfe-pg-user                    = base64encode(var.postgresql_user_name)
    ptfe-postgresql-extra-params = base64encode(
      join("&", [for key, value in var.postgresql_extra_params : "${key}=$){value}"])
    )
    ptfe-release-sequence = base64encode(var.release_sequence)
    ptfe-role             = base64encode("main")
    ptfe-role-id          = base64encode("0")
    ptfe-service-cidr     = base64encode(var.service_cidr)
    ptfe-tbw-image        = base64encode(var.tbw_image)
    ptfe-tls-vers         = base64encode(var.tls_vers)
    ptfe-ui-bind-port     = base64encode(var.vpc_install_dashboard_tcp_port)
  }
  primaries = [
    merge(local.common, local.main_metadata),
    merge(local.common, { "ptfe-role" = base64encode("primary"), "ptfe-role-id" = base64encode("1") }),
    merge(local.common, { "ptfe-role" = base64encode("primary"), "ptfe-role-id" = base64encode("2") }),
  ]
  secondaries = merge(local.common, { "ptfe-role" = base64encode("secondary") })
}

resource "random_pet" "install_dashboard_password" {
  length = 3
}

resource "random_string" "auth_token" {
  length  = 32
  special = false
  upper   = false
}

resource "random_string" "assistant_token" {
  length  = 32
  special = false
  upper   = false
}

resource "random_string" "bootstrap_token_id" {
  length  = 6
  special = false
  upper   = false
}

resource "random_string" "bootstrap_token_suffix" {
  length  = 16
  upper   = false
  special = false
}
