output "instance" {
  value = google_compute_instance.main

  description = "The compute instance which acts as the load balancer."
}
