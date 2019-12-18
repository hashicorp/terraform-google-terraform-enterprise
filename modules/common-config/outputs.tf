output "application_config" {
  value = jsonencode(local.repl_config)
}

output "ca_certs" {
  value = var.ca_certs
}
