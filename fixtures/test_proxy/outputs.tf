output "compute_instance" {
  value = google_compute_instance.proxy

  description = "The proxy Compute instance."
}

output "uri_authority" {
  value = "${google_compute_instance.proxy.network_interface[0].network_ip}:${local.http_port}"

  description = "The host and port of the proxy server."
}
