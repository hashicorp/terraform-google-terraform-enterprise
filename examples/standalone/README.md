# EXAMPLE: Deploying Terraform Enterprise in Standalone Mode

## About This Example

This example provisions a [Standalone](https://www.terraform.io/docs/enterprise/before-installing/reference-architecture/gcp.html#implementation-modes) TFE instance with minimal required inputs. This is the standard implementation for Terraform Enterprise and will create the base architecture with a single application node.

## How to Use This Module

Set the `node_count` input value to 1 to implement Standalone mode.

Create a Terraform configuration that pulls in this module and specifies values of the required variables:

```hcl
module "tfe_node" {
  source               = "git@github.com:hashicorp/terraform-google-terraform-enterprise.git"
  namespace            = "<Namespace to uniquely identify resources>"
  node_count           = "<Number of TFE nodes to provision>"
  license_secret       = "<Secret Manager secret comprising license>
  fqdn                 = "<Fully qualified domain name>"
  ssl_certificate_name = "<Name of the SSL certificate provisioned in GCP>"
  dns_zone_name        = "<Name of the DNS zone in which a record set will be created>"
}
```

- Run `terraform init` and `terraform apply`

## Required inputs

`namespace` - Namespace to uniquely identify resources. Used in name prefixes

`license_secret` - The Secret Manager secret which comprises the
Base64 encoded Replicated license file. The Terraform provider calls
this value the secret_id and the GCP UI calls it the name.

`fqdn` - Fully qualified domain name

`ssl_certificate_name` - Name of the SSL certificate provisioned in GCP

`node_count` - Number of TFE nodes to provision. A number greater than 1 will enable Active/Active

`dns_zone_name` - Name of the DNS zone in which a record set will be created
