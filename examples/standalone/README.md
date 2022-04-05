# EXAMPLE: Deploying Terraform Enterprise in Standalone Mode

## About This Example

This example provisions a [Standalone](https://www.terraform.io/docs/enterprise/before-installing/reference-architecture/gcp.html#implementation-modes) TFE instance with minimal required inputs. This is the standard implementation for Terraform Enterprise and will create the base architecture with a single application node.

## How to Use This Module

- Read the entire README.md for the [main module](https://github.com/hashicorp/terraform-google-terraform-enterprise).
- Ensure your Google credentials are set correctly
- Add Google Terraform provider blocks for both the `google` and `google-beta` providers as detailed [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference) to a file in this directory ending with `.tf`.
- Create a local `terraform.auto.tfvars` file and instantiate the required inputs as listed in the next section.
- Set the `node_count` input value to 1 to implement Standalone mode.
- Create a Terraform configuration that pulls in this module and specifies values of the required variables:

```hcl
module "tfe_node" {
  source               = "git@github.com:hashicorp/terraform-google-terraform-enterprise.git"
  namespace            = "<Namespace to uniquely identify resources>"
  node_count           = "<Number of TFE nodes to provision>"
  license_secret       = "<Secret Manager secret comprising license>
  fqdn                 = "<Fully qualified domain name>"
  ssl_certificate_name = "<Name of the SSL certificate provisioned in GCP>"
  dns_zone_name        = "<Name of the DNS zone in which a record set will be created>"
  load_balancer        = "PUBLIC"  // for a publically accessible instance.  Omit this line for a private instance, or explicitly set it to "PRIVATE"
}
```

- Run `terraform init` and `terraform apply`

## Post-deployment Tasks

- The build should take approximately 10-15 to deploy.  Once Terraform completes, give the platform another 10 minutes or so prior to attempting to interact with it in order for all containers to start up.
- Unless amended, this example will not create an initial admin user using the IACT, but does output the URL for convenience. Follow the advice in [this document](https://www.terraform.io/docs/enterprise/install/automating-initial-user.html) in order to create the initial admin user, and login to the system using this user in order to configure it for use.
