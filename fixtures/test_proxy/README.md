# FIXTURE: TFE Test Proxy Module

This module creates mitmproxy servers and Squid servers for use in
test modules.

## Example usage

```hcl
module "test_proxy" {
  source = "../../fixtures/test_proxy"

  instance_image = data.google_compute_image.ubuntu.id
  name           = local.name
  network        = module.tfe.network
  subnetwork     = module.tfe.subnetwork

  labels                          = local.labels
  mitmproxy_ca_certificate_secret = data.tfe_outputs.base.values.ca_certificate_secret_id
  mitmproxy_ca_private_key_secret = data.tfe_outputs.base.values.ca_private_key_secret_id
}
```

## Resources

- [google_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account)
- [google_project_iam_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member)
- [google_compute_firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall)
- [google_compute_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance)
