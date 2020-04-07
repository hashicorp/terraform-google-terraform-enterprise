# Terraform Enterprise Clustered: Shared VPC Example

This example deploys TFE Clustered using [Shared VPC][shared-vpc].

## Background

From the GCP article [Shared VPC][shared-vpc]:

> Shared VPC allows an organization to connect resources from multiple
> projects to a common Virtual Private Cloud (VPC) network, so that they
> can communicate with each other securely and efficiently using
> internal IPs from that network.

The GCP article [Provisioning Shared VPC][provisioning-shared-vpc]
should be reviewed for instructions on how to configure a host project
and a service project prior to executing this example.

## Features

This example provisions TFE infrastructure in 3 stages in both the host
project and the service project. For the sake of simplicity, a single
Terraform configuration is used, but in a production setting, these
stages should be managed with separate configurations and linked using
[Terraform remote state][tf-remote-state].

### Service Accounts

The service accounts are created in the service project because
they must be available for assignment to compute instances in the
service project.

### Host

The VPC is created in the host project and the Google APIs Service
Agent of the service project is authorized to use the shared VPC
subnetwork in order to deploy from templates to managed instance groups
any instances attached to the subnetwork.

### Service

The compute resources which comprise the majority of the TFE Clustered
infrastructure are created in the service project as with a single
project deployment.

## Requirements

The following requirements must be met in order to execute this example:

- the latest version of Terraform 0.12 is [installed][tf-install] on the
  working machine
- a Terraform Enterprise license provided by a HashiCorp
  Account Manager is located on the working machine
- the Google provider and the Google Beta provider are configured with
  the credentials of a GCP account which has sufficient permissions to
  provision the infrastructure
- a Shared VPC host project with the Service Networking API enabled
- a Shared VPC service project

### GCP Account Permissions

The GCP account must be an IAM member with the following roles in the
service project:

- Cloud SQL Admin (roles/cloudsql.admin)
- Compute Admin (roles/compute.admin)
- DNS Administrator (roles/dns.admin)
- Service Account Admin (roles/iam.serviceAccountAdmin)
- Service Account Key Admin (roles/iam.serviceAccountKeyAdmin)
- Storage Admin (roles/storage.admin)

## Usage

The following script demonstrates how to execute this example:

```sh
# Define the host project ID and the service project ID.
# These values must be replaced with real Shared VPC project IDs.
HOST_PROJECT="tfe-host-project"
SERVICE_PROJECT="tfe-service-project"

# Define the region and zone.
# These values can be changed as necessary.
GOOGLE_REGION="us-west1"
GOOGLE_ZONE="us-west1-a"

# Initialize the working directory.
terraform init

# Create the service accounts.
GOOGLE_PROJECT="$SERVICE_PROJECT" terraform apply \
-target module.service_account

# Create the VPC.
GOOGLE_PROJECT="$HOST_PROJECT" terraform apply \
-target module.host

# Create the compute resources.
GOOGLE_PROJECT="$SERVICE_PROJeCT" terraform apply \
-target module.service

# Obtain the outputs necessary to access the TFE Clustered deployment.
terraform output

# Destroy the compute resources.
# This step may need to be repeated if destruction of the database
# instance times out.
GOOGLE_PROJECT="$SERVICE_PROJECT" terraform destroy \
-target module.service

# Destroy the VPC.
GOOGLE_PROJECT="$HOST_PROJECT" terraform destroy \
-target module.host

# Destroy the service accounts.
GOOGLE_PROJECT="$SERVICE_PROJECT" terraform destroy \
-target module.service_account
```

[provisioning-shared-vpc]: https://cloud.google.com/vpc/docs/provisioning-shared-vpc
[shared-vpc]: https://cloud.google.com/vpc/docs/shared-vpc
[tf-install]: https://learn.hashicorp.com/terraform/getting-started/install
[tf-remote-state]: https://www.terraform.io/docs/state/remote.html
