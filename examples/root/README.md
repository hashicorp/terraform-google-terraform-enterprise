# Terraform Enterprise Clustered: Root Example

This example deploys TFE Clustered using the root module, demonstrating
how a valid minimal Terraform configuration can be designed.

## Background

The root module provides an opinionated configuration to deploy TFE
Clustered with only a minimum set of required inputs for which there
are no safe default values.

## Features

This example provisions TFE Clustered infrastructure using all of the
default input values, save for the prefix which modified to help
identify the example infrastructure on GCP.

The configuration explicitly configures the oldest versions of
Terraform and the providers which are supported by the module in order
to verify compatibility.

## Requirements

The following requirements must be met to use the
**terraform-enterprise** module:

- the latest version of Terraform 0.12 is [installed][tf-install] on the
  working machine
- a Terraform Enterprise license provided by a HashiCorp
  Account Manager is located on the working machine
- [the Google provider and the Google Beta provider][google-provider]
  are configured with a project, region, zone, and
  [credentials](#credentials)

### Credentials

The Google provider and the Google Beta provider must be configured
with the credentials of a GCP account which is assigned the following
roles within the project:

- Cloud SQL Admin (roles/cloudsql.admin)
- Compute Admin (roles/compute.admin)
- DNS Administrator (roles/dns.admin)
- Service Account Admin (roles/iam.serviceAccountAdmin)
- Service Account Key Admin (roles/iam.serviceAccountKeyAdmin)
- Service Account User (roles/iam.serviceAccountUser)
- Service Networking Admin (roles/servicenetworking.networksAdmin)
- Storage Admin (roles/storage.admin)

## Usage

The following script demonstrates how to execute this example:

```sh
# Define the project ID.
# This value must be replaced with a real project ID.
GOOGLE_PROJECT="tfe-project"

# Define the region and zone.
# These values can be changed as necessary.
GOOGLE_REGION="us-west1"
GOOGLE_ZONE="us-west1-a"

# Initialize the working directory.
terraform init

# Create the infrastructure.
terraform apply

# Obtain the outputs necessary to access the TFE Clustered deployment.
terraform output

# Destroy the infrastructure.
terraform destroy
```

<!-- URLs for links -->

[google-provider]: https://registry.terraform.io/providers/hashicorp/google/3.2.0/docs/guides/provider_reference#full-reference
[tf-install]: https://learn.hashicorp.com/terraform/getting-started/install
