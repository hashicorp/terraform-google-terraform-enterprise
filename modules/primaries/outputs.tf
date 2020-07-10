output "addresses" {
  value = google_compute_address.main

  description = "The internal IP addresses of the primaries."
}

output "instance_groups" {
  value = google_compute_instance_group.main

  description = "The groups which comprise the primaries."
}

output "instances" {
  value = google_compute_instance.main

  description = "The primaries."
}

output "kubernetes_api_load_balancer_address" {
  value = google_compute_address.kubernetes_api_load_balancer

  description = "The internal IP address of the Kubernetes API load balancer."
}
