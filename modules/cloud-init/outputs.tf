output "console_password" {
  value = random_pet.console_password.id

  description = "The generated password for the management console."
}

output "primaries_configs" {
  value = data.template_cloudinit_config.primaries.*.rendered

  description = "The list of cloud-init configurations to apply to the primaries."
}

output "secondaries_config" {
  value = data.template_cloudinit_config.secondaries.rendered

  description = "The cloud-init configuration to apply to the secondaries."
}
