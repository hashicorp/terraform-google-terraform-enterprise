# FIXTURE: TFE Secrets Module

This module creates the GCP Secret Manager secrets that are
required by the root TFE module and test modules.

Secrets will only be created if their associated variables have
non-null values.

## Example usage

```hcl
resource "tls_private_key" "ssl_certificate" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "secrets" {
  source = "./fixtures/secrets"

  key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-tfe-rg/providers/Microsoft.KeyVault/vaults/my-tfe-kv"

  tfe_license = {
    name = "my-tfe-license"
    path = "/path/to/license.rli"
  }

  # examples of when the value is in a file
  private_key_pem = {
    name  = "my-private-key-pem"
    value = file("/path/to/private-key.pem")
  }
  chained_certificate_pem = {
    name  = "my-chained-cert-pem"
    value = file("/path/to/chained-certificate.pem")
  }

  # examples of when the value comes from the output of a resource
  proxy_public_key = {
    name  = "my-proxy-public-key"
    value = tls_private_key.ssl_certificate.public_key_openssh
  }

  proxy_private_key = {
    name  = "my-proxy-private-key"
    value = tls_private_key.ssl_certificate.private_key_pem
  }
}
```

## Resources

- [google_secret_manager_secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret)
- [google_secret_manager_secret_version](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version)
