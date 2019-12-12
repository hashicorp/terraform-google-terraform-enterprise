output "frontend_ip" {
  value = "${google_compute_global_address.frontend_ip.address}"
}

output "cert" {
  value = "${google_compute_managed_ssl_certificate.frontendcert.self_link}"
}

output "dns_entry" {
  value = "${var.hostname}.${data.google_dns_managed_zone.dnszone.dns_name}"
}

output "ssl-policy" {
  value = "${google_compute_ssl_policy.ptfe-ssl-policy.name}"
}

output "dns_zone" {
  value = "${data.google_dns_managed_zone.dnszone.name}"
}
