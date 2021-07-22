# EXAMPLE: Terraform Enterprise Startup Persona

## About This Example

This example demonstrates how to invoke the root module in the manner
of the Startup persona.

Traits of the Startup persona include:

* Active/Active mode

* a small VM machine type (n1-standard-4)

* Ubuntu 20.04 as the VM image

* a publicly accessible HTTP load balancer with TLS termination

* no proxy server

* no Redis authentication

* no Redis encryption in transit

## How to Use This Module

If this repository has been cloned to a workstation then the
configuration in this directory can be applied. Alternatively, the
following HCL sample demonstrates how to invoke the root module in the
manner of the Startup persona:

```hcl
module "tfe" {
  source = "git@github.com:hashicorp/espd-tfe-gcp.git"

  dns_zone_name        = "<Name of the DNS zone in which a record set will be created>"
  fqdn                 = "<Fully qualified domain name>"
  namespace            = "<Namespace to uniquely identify resources>"
  node_count           = 2
  tfe_license_name     = "<Name of the license>"
  tfe_license_path     = "<Local path to the TFE license>"
  ssl_certificate_name = "<Name of the SSL certificate provisioned in GCP>"

  load_balancer        = "PUBLIC"
  redis_auth_enabled   = false
  vm_disk_source_image = "<Source image for VM disk>"
  vm_machine_type      = "n1-standard-4"
}
```

Refer to the Google provider article on
[authentication](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication)
for instructions on how to authenticate Terraform with GCP.

With authentication configured, run `terraform init` and
`terraform apply` to provision the example infrastructure.

## Required Inputs

`namespace` - Namespace to uniquely identify resources. Used in name prefixes

`tfe_license_path` - Local path to the TFE license

`dns_zone_name` - Name of the DNS zone in which a record set will be
created

`fqdn` - Fully qualified domain name

`ssl_certificate_name` - Name of the SSL certificate provisioned in GCP
