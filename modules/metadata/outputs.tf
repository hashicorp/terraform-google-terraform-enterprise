output "install_dashboard_password" {
  value = random_pet.install_dashboard_password.id

  description = "The generated password for the install dashboard."
}

output "primaries" {
  value = local.primaries

  description = "The metadatas for the primaries."
}

output "secondaries" {
  value = local.secondaries

  description = "The metadata for the secondaries."
}
