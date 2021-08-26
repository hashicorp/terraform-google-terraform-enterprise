output "replicated_console_password" {
  value       = var.node_count > 1 ? "" : module.user_data.replicated_dashboard_password
  description = "Generated password for replicated dashboard."
}

output "lb_address" {
  value       = local.lb_address
  description = "Load Balancer Address."
}

output "health_check_url" {
  value = "${local.base_url}_health_check"

  description = "The URL of the Terraform Enterprise health check endpoint."
}

output "iact_url" {
  value = "${local.base_url}admin/retrieve-iact"

  description = "The URL of the Terraform Enterprise initial admin creation token."
}

output "initial_admin_user_url" {
  value = "${local.base_url}admin/initial-admin-user"

  description = "The URL of the Terraform Enterprise initial admin user."
}

output "url" {
  value = local.base_url

  description = "The URL of Terraform Enterprise."
}

output "network" {
  value       = local.networking_module_enabled ? module.networking[0].network : null
  description = "The network to which TFE is attached."
}

output "service_account_email" {
  value       = module.service_accounts.email
  description = "The email address of the service account associated with the TFE instance."
}

output "subnetwork" {
  value       = local.networking_module_enabled ? module.networking[0].subnetwork : null
  description = "The subnetwork to which TFE is attached."
}

output "dns_configuration_notice" {
  value       = "If you are using external DNS, please make sure to create a DNS record using the lb_address output that has been provided."
  description = "A warning message."
}

output "object_store_bucket" {
  value       = module.object_storage.bucket
  description = "Name of the GCS bucket used for the object store and TFE licence file."
}

output "object_store_bucket_location" {
  value       = module.object_storage.location
  description = "Location of the GCS bucket used for the object store and TFE licence file."
}

output "startup_notice" {
  value       = "Please wait up to ten minutes for the system to fully start up before attempting to log in."
  description = "A warning message."
}
