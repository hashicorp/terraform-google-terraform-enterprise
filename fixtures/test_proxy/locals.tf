locals {
  mitmproxy_selected = var.mitmproxy_ca_certificate_secret != null && var.mitmproxy_ca_private_key_secret != null

  http_port = local.mitmproxy_selected ? (
    module.test_proxy_init.mitmproxy.http_port
  ) : module.test_proxy_init.squid.http_port
  service_account        = var.existing_service_account_id == null ? google_service_account.proxy[0] : data.google_service_account.proxy[0]
  service_account_member = "serviceAccount:${local.service_account.email}"
}
