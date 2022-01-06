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

  license = {
    id = "my-tfe-license"
    path = "/path/to/license.rli"
  }

  # examples of when the value is in a file
  ca_certificate = {
    id  = "my-ca-certificate"
    value = file("/path/to/ca-certificate.pem")
  }

  # examples of when the value comes from the output of a resource
  ssl_certificate = {
    id  = "my-ssl-certificate"
    value = tls_private_key.ssl_certificate.public_key_pem
  }

  ssl_private_key = {
    id  = "my-ssl-private-key"
    value = tls_private_key.ssl_certificate.private_key_pem
  }
}
```

## Resources

- [google_secret_manager_secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret)
- [google_secret_manager_secret_version](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version)
