output "database_name" {
  value = google_sql_database_instance.tfe-psql-db.name
}

output "address" {
  value = google_sql_database_instance.tfe-psql-db.first_ip_address
}

output "user" {
  value = var.postgresql_user
}

output "password" {
  value = local.password
}
