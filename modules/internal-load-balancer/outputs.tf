output "in_address" {
  value = google_compute_address.internal_load_balancer_in

  description = "The IP address of the load balancer for inbound traffic."
}
