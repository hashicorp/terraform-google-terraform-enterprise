output "script" {
  value = local.user_data

  description = "The rendered user-data script."
}

output "replicated_dashboard_password" {
  value = random_string.password.result

  description = "The password for accessing the Replicated dashboard."
}

output "user_token" {
  value = local.base_configs.user_token

  description = "The IACT."
}
