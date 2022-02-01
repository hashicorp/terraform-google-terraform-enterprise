output "compute_instance" {
  value = google_compute_instance.proxy

  description = "The proxy Compute instance."
}

output "uri_authority" {
  value = "${google_compute_instance.proxy.network_interface[0].network_ip}:${module.test_proxy_init.squid.http_port}"

  description = "The host and port of the proxy server."
}
