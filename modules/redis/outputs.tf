output "host" {
  value = google_redis_instance.redis.host
}

output "port" {
  value = google_redis_instance.redis.port
}

output "password" {
  value = google_redis_instance.redis.auth_string
}
