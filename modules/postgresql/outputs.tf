output "database" {
  value = google_sql_database.main

  description = "The database which stores application data."
}

output "database_instance" {
  value = google_sql_database_instance.main

  description = "The compute instance which hosts the database."
}

output "user" {
  value = google_sql_user.main

  description = "The database user."
}
