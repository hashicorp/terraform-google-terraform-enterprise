output "url" {
  value = "http://${google_compute_instance.main.network_interface[0].network_ip}:${local.port}"

  description = "The URL of the proxy server."
}
