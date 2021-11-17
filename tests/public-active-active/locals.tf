locals {
  domain = trimsuffix(data.tfe_outputs.base.values.cloud_dns.domain, ".")
}
