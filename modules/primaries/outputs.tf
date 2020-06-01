output "instance_groups" {
  value = google_compute_instance_group.main

  description = "The groups of compute instances which comprise the primaries."
}

output "instances" {
  value = google_compute_instance.main

  description = "The compute instances which comprise the primaries."
}

output "load_balancer_address" {
  value = google_compute_address.load_balancer

  description = "The internal IP address of the routers of the load balancer."
}
