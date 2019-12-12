output "vpc" {
  value = module.firewall.vpc
}

output "subnet" {
  value = module.firewall.ptfe_subnet
}

output "ptfe_firewall" {
  value = module.firewall.ptfe_firewall
}

output "healthcheck_firewall" {
  value = module.firewall.ptfe_healthchk_firewall
}

output "FrondEnd_IP" {
  value = module.dns-cert.frontend_ip
}

output "DNS_Entry" {
  value = module.dns-cert.dns_entry
}

output "Certificate" {
  value = module.dns-cert.cert
}

output "SSL_Policy" {
  value = module.dns-cert.ssl-policy
}

output "psql_dbuser" {
  value = google_sql_user.tfe-psql-user.name
}

output "storage_bucket" {
  value = google_storage_bucket.tfe-bucket.name
}

output "psql_db_name" {
  value = google_sql_database_instance.tfe-psql-db.name
}

output "psql_db_ip_address" {
  value = google_sql_database_instance.tfe-psql-db.first_ip_address
}

output "dns_zone" {
  value = module.dns-cert.dns_zone
}

