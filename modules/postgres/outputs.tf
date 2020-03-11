output "database" {
  value = google_sql_database.tfe

  description = "The database in which application data will be stored."
}

output "instance" {
  value = google_sql_database_instance.tfe

  description = "The database compute instance which hosts the database."
}

output "user" {
  value = google_sql_user.tfe

  description = "The database user."
}