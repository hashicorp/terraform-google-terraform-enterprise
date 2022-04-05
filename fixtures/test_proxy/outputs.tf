output "compute_instance" {
  value = google_compute_instance.proxy

  description = "The proxy Compute instance."
}

output "proxy_ip" {
  value = google_compute_instance.proxy.network_interface[0].network_ip
}

output "proxy_port" {
  value = local.http_port
}