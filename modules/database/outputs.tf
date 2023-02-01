# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "netloc" {
  value = google_sql_database_instance.tfe.private_ip_address

  description = "The private IP address of the SQL database instance."
}
output "dbname" {
  value = google_sql_database.tfe.name

  description = "The name of the PostgreSQL database."
}
output "user" {
  value = google_sql_user.tfe.name

  description = "The name of the PostgreSQL database user."
}
output "password" {
  value = google_sql_user.tfe.password

  description = "The password of the PostgreSQL database user."
}
