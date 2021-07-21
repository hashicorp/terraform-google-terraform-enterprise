output "address" {
  value = google_compute_address.internal.address

  description = "The IP address of the load balancer."
}
