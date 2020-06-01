output "address" {
  value = google_compute_address.main

  description = "The internal IP address of the load balancer."
}
