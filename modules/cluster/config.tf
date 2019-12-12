locals {
  common_metadata = {
    //enable-oslogin       = "TRUE"
    bootstrap-token      = "${random_string.bootstrap_token_id.result}.${random_string.bootstrap_token_suffix.result}"
    setup-token          = random_string.setup_token.result
    cluster-api-endpoint = "${module.internal_lb.address}:6443"
    primary-pki-url      = "http://${module.internal_lb.address}:${local.assistant_port}/api/v1/pki-download?token=${random_string.setup_token.result}"
    health-url           = "http://${module.internal_lb.address}:${local.assistant_port}/healthz"
    assistant-host       = "http://${module.internal_lb.address}:${local.assistant_port}"
    assistant-token      = random_string.setup_token.result
    custom-ca-cert-url   = var.ca_bundle_url

    b64-license = filebase64(var.license_file)

    ptfe-install-url   = var.ptfe_install_url
    jq-url             = var.jq_url
    http_proxy_url     = var.http_proxy_url
    airgap-package-url = var.airgap_package_url
    repl-data          = base64encode(random_pet.console_password.id)
    encpasswd          = local.encryption_password
    release-sequence   = var.release_sequence
    pg_user            = var.postgresql_user
    pg_password        = base64encode(var.postgresql_password)
    pg_netloc          = var.postgresql_address
    pg_dbname          = var.postgresql_database
    pg_extra_params    = var.postgresql_extra_params
    gcs_credentials    = var.gcs_credentials
    gcs_project        = var.gcs_project == "" ? var.project : var.gcs_project
    gcs_bucket         = var.gcs_bucket
    weave_cidr         = var.weave_cidr
    repl_cidr          = var.repl_cidr
  }

}
