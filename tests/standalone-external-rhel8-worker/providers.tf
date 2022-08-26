provider "tfe" {
  hostname = try(var.tfe.hostname, var.tfe_hostname)
  token    = try(var.tfe.token, var.tfe_token)
}
