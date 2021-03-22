# EXAMPLE: Deploying Terraform Enterprise with external DNS

## About This Example

This example provisions a Standalone TFE instance with external DNS.

## How to Use This Module

- To use externally configured DNS, set the variable `dns_create_record` to `false`.
- External DNS record must be updated to use the IP address provided in the `lb_address` output.
- Create a Terraform configuration that pulls in this module and specifies values of the required variables:

```hcl
provider "google" {
  project = "<your GCP project>"
  region  = "<your GCP region>"
}

provider "google-beta" {
  project = "<your GCP project>"
  region  = "<your GCP region>"
}

module "tfe_node" {
  source               = "git@github.com:hashicorp/espd-tfe-gcp.git"
  namespace            = "<Namespace to uniquely identify resources>"
  node_count           = "<Number of TFE nodes to provision>"
  tfe_license_path     = "<Local path to the TFE license>"
  tfe_license_name     = "<Name of the license>"
  fqdn                 = "<Fully qualified domain name>"
  ssl_certificate_name = "<Name of the SSL certificate provisioned in GCP>"
  dns_zone_name        = "<Name of the DNS zone in which a record set will be created>"
  dns_create_record    = "<Bool, input false to skip creation of internal DNS>"
}
```

- Run `terraform init` and `terraform apply`

## Required inputs

`namespace` - Namespace to uniquely identify resources. Used in name prefixes

`tfe_license_path` - Local path to the TFE license

`tfe_license_name` - Name of the license

`fqdn` - Fully qualified domain name

`ssl_certificate_name` - Name of the SSL certificate provisioned in GCP

`node_count` - Number of TFE nodes to provision. A number greater than 1 will enable Active/Active

`dns_zone_name` - Name of the DNS zone in which a record set will be created

`dns_create_record` - Bool, input false to skip creation of internal DNS
