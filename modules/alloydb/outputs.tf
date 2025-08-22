# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "netloc" {
  value = google_alloydb_instance.default.ip_address

  description = "The private IP address of the AlloyDB cluster."
}
output "dbname" {
  value = var.dbname

  description = "The name of the AlloyDB cluster."
}
output "user" {
  value = google_alloydb_user.tfe.user_id

  description = "The name of the AlloyDB database user."
}
output "password" {
  value = google_alloydb_user.tfe.password

  description = "The password of the AlloyDB database user."
}
