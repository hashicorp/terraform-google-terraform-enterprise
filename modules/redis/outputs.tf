output "host" {
  value = google_redis_instance.redis.host

  description = "The hostname of the Redis endpoint."
}

output "port" {
  value = google_redis_instance.redis.port

  description = "The port number of the Redis endpoint."
}

output "password" {
  value = google_redis_instance.redis.auth_string

  description = "The password to the Redis instance."
}
