output "address" {
  value = google_compute_address.load_balancer_in

  description = "The IP address of the inbound load balancer."
}
