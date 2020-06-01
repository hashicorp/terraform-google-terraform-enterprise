output "internal_load_balancer_address" {
  value = module.internal_load_balancer.address.address

  description = "The address of the internal load balancer."
}

output "primary_0" {
  value = length(module.primaries.instances) > 0 ? module.primaries.instances[0].name : ""

  description = "The name of the first primary compute instance."
}
