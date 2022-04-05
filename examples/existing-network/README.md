# EXAMPLE: Deploying Terraform Enterprise behind an existing VPC

## About This Example

This is the same as the Active/Active example except it is provisioned into an existing VPC.

## How to Use This Module

- Read the entire README.md for the [main module](https://github.com/hashicorp/terraform-google-terraform-enterprise).
- Ensure your Google credentials are set correctly
- Add Google Terraform provider blocks for both the `google` and `google-beta` providers as detailed [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference) to a file in this directory ending with `.tf`.
- Create a local `terraform.auto.tfvars` file and instantiate the required inputs as listed in the next section.
- The existing VPC is up to the user to configure appropriately for the TFE deployment:
  - [Network Submodule](../../modules/networking) for reference.
  - The [Firewall](../../modules/networking/main.tf#L34) needs to be configured to allow the load balancer to connect to the instances.
  - The [Service Networking Connection](../../modules/networking/main.tf#L72) needs to be configured to allow postgres and redis to allocate IPs.
  - The VPC must have a reserved subnet for the internal HTTPS load balancer.

Create a Terraform configuration that pulls in this module and specifies values of the required variables:

```hcl
module "tfe_node" {
  source                = "git@github.com:hashicorp/terraform-google-terraform-enterprise.git"
  namespace             = "<Namespace to uniquely identify resources>"
  node_count            = "<Number of TFE nodes to provision>"
  tfe_license_secret_id = "<Secret Manager secret comprising license>
  fqdn                  = "<Fully qualified domain name>"
  ssl_certificate_name  = "<Name of the SSL certificate provisioned in GCP>"
  dns_zone_name         = "<Name of the DNS zone in which a record set will be created>"
  network               = "<The self link of the host project's network to use>"
  subnetwork            = "<The self link of the host project's subnetwork to use>"
  load_balancer         = "PUBLIC"  // for a publically accessible instance.  Omit this line for a private instance, or explicitly set it to "PRIVATE"
}
```

- Run `terraform init` and `terraform apply`

## Post-deployment Tasks

- The build should take approximately 10-15 to deploy.  Once Terraform completes, give the platform another 10 minutes or so prior to attempting to interact with it in order for all containers to start up.
- Unless amended, this example will not create an initial admin user using the IACT, but does output the URL for convenience. Follow the advice in [this document](https://www.terraform.io/docs/enterprise/install/automating-initial-user.html) in order to create the initial admin user, and login to the system using this user in order to configure it for use.
