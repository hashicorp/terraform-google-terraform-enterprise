output "compute_instance" {
  value = google_compute_instance.proxy

  description = "The proxy Compute instance."
}

output "proxy_ip" {
  value = google_compute_instance.proxy.network_interface[0].network_ip

  description = "The listening port for redis."
}

output "proxy_port" {
  value = local.http_port

  description = "The listening ip for redis."
}