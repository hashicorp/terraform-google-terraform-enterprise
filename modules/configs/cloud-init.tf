locals {
  assistant_port = 23010
}

data "template_file" "proxy_sh" {
  template = file("${path.module}/templates/cloud-init/proxy.sh")

  vars = {
    no_proxy  = join(",", compact(["10.0.0.0/8", "127.0.0.1", "169.254.169.254", var.repl_cidr]))
    proxy_url = var.http_proxy_url
  }
}

data "template_file" "aaa_proxy_b64" {
  template = file("${path.module}/templates/cloud-init/00aaa_proxy")

  vars = {
    proxy_url = var.http_proxy_url
  }
}

data "template_file" "cloud_config" {
  count    = var.primary_count
  template = file("${path.module}/templates/cloud-init/cloud-config.yaml")

  vars = {
    airgap_package_url   = var.airgap_package_url
    airgap_installer_url = var.airgap_installer_url
    setup_token          = random_string.setup_token.result
    proxy_url            = var.http_proxy_url
    ptfe_url             = var.installer_url
    role_id              = count.index
    import_key           = var.import_key
    distro               = var.distribution
    aaa_proxy_b64        = base64encode(data.template_file.aaa_proxy_b64.rendered)
    proxy_b64            = base64encode(data.template_file.proxy_sh.rendered)
    bootstrap_token      = "${random_string.bootstrap_token_id.result}.${random_string.bootstrap_token_suffix.result}"
    license_b64          = filebase64(var.license_file)
    rptfeconf            = base64encode(var.common-config.application_config)
    replconf             = base64encode(data.template_file.replicated_config.rendered)
    install_ptfe_sh      = base64encode(file("${path.module}/files/install-ptfe.sh"))
    role                 = count.index == 0 ? "main" : "primary"
    cluster_api_endpoint = "${var.cluster_api_endpoint}:6443"
    assistant_host       = "http://${var.cluster_api_endpoint}:${local.assistant_port}"
    ca_bundle_url        = var.common-config.ca_certs
    weave_cidr           = var.weave_cidr
    repl_cidr            = var.repl_cidr
  }
}

data "template_cloudinit_config" "config" {
  count         = var.primary_count
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloud_config[count.index].rendered
  }
}

data "template_file" "cloud_config_secondary" {
  template = file("${path.module}/templates/cloud-init/cloud-config.yaml")

  vars = {
    proxy_url            = var.http_proxy_url
    ptfe_url             = var.installer_url
    import_key           = var.import_key
    bootstrap_token      = "${random_string.bootstrap_token_id.result}.${random_string.bootstrap_token_suffix.result}"
    cluster_api_endpoint = "${var.cluster_api_endpoint}:6443"
    assistant_host       = "http://${var.cluster_api_endpoint}:${local.assistant_port}"
    setup_token          = random_string.setup_token.result
    install_ptfe_sh      = base64encode(file("${path.module}/files/install-ptfe.sh"))
    role                 = "secondary"
    distro               = var.distribution
    aaa_proxy_b64        = base64encode(data.template_file.aaa_proxy_b64.rendered)
    proxy_b64            = base64encode(data.template_file.proxy_sh.rendered)
    ca_bundle_url        = var.common-config.ca_certs
  }
}

data "template_cloudinit_config" "config_secondary" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloud_config_secondary.rendered
  }
}
