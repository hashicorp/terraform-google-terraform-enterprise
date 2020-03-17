output "console_password" {
  value = random_pet.console_password.id

  description = "The generated password for the management console."
}

output "primary_configs" {
  value = data.template_cloudinit_config.primaries.*.rendered

  description = "The list of cloud-init configurations to apply to the primary compute instances."
}

output "secondary_config" {
  value = data.template_cloudinit_config.secondary.rendered

  description = "The cloud-init configuration to apply to the secondary compute instances."
}
