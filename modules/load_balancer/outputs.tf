output "address" {
  value = google_compute_global_address.external.address

  description = "The IP address of the load balancer."
}
