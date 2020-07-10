output "install_dashboard_password" {
  value = module.service.cloud_init.install_dashboard_password

  description = "The generated password for the install dashboard."
}

output "internal_load_balancer" {
  value = module.service.internal_load_balancer.instance.name

  description = "The name of the internal load balancer compute instance."
}

output "internal_load_balancer_address" {
  value = module.service.internal_load_balancer.instance.network_interface[0].network_ip

  description = "The internal IP address of the internal load balancer compute instance."
}
