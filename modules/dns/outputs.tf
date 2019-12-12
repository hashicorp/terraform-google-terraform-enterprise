output "domain_name" {
  value = "${var.hostname}.${data.google_dns_managed_zone.dnszone.dns_name}"
}

output "dns_zone" {
  value = "${data.google_dns_managed_zone.dnszone.name}"
}
