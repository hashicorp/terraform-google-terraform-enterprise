output "install_dashboard_password" {
  value = random_pet.install_dashboard_password.id

  description = "The generated password for the install dashboard."
}

output "primaries_configs" {
  value = data.template_cloudinit_config.primaries.*.rendered

  description = "The list of cloud-init configurations to apply to the primaries."
}

output "secondaries_config" {
  value = data.template_cloudinit_config.secondaries.rendered

  description = "The cloud-init configuration to apply to the secondaries."
}
