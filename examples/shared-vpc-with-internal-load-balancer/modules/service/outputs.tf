output "cloud_init" {
  value = module.cloud_init

  description = "The cloud-init configuration of the application."
}

output "dns" {
  value = module.dns

  description = "The DNS configuration of the application."
}

output "internal_load_balancer" {
  value = module.internal_load_balancer

  description = "The internal load balancer of the application."
}

output "primaries" {
  value = module.primaries

  description = "The primaries of the application."
}
