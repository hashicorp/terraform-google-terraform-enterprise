locals {
  domain = trimsuffix(nonsensitive(data.tfe_outputs.base.values.cloud_dns.domain), ".")
}
