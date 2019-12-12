data "google_dns_managed_zone" "dnszone" {
  name = var.dnszone
}

resource "google_dns_record_set" "hostname" {
  name = "${var.hostname}.${data.google_dns_managed_zone.dnszone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.dnszone.name

  rrdatas = [var.address]
}
