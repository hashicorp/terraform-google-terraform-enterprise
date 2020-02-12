# Terraform Enterprise on GCP

This module is the official way for HashiCorp customers to
provision a Terraform Cluster on GCP. The root module makes all the
decisions for you, and makes deploying a three node cluster as simple
as:

```hcl
module "terraform_enterprise" {
  source  = "hashicorp/terraform-enterprise/google"
  version = "~> 1.0"

  credentials  = "my-service-account-key.json"
  dnszone      = "my-dns-zone"
  license_path = “my-company.rli”
  project      = "my-project"
}
```

Have unique requirements? You can build a bespoke cluster using the
[customization options](#customization-options) listed below.

## Prerequisites

- The latest version of Terraform 0.12
  [installed](https://learn.hashicorp.com/terraform/getting-started/install)
  on your machine
- A Terraform Enterprise license provided by your Account Manager at
  HashiCorp
- A GCP account with sufficient permissions to provision infrastructure

### Permissions

The following permissions are required by the GCP account which will be
used to provision this module:

- Cloud SQL Admin (roles/cloudsql.admin )
- Compute Admin (roles/compute.admin )
- DNS Administrator (roles/dns.admin )
- Service Account Admin (roles/iam.serviceAccountAdmin )
- Service Account Key Admin (roles/iam.serviceAccountKeyAdmin )
- Service Account User (roles/iam.serviceAccountUser )
- Service Networking Admin (roles/servicenetworking.networksAdmin )
- Storage Admin (roles/storage.admin )

## How to Use the Module

1. Clone the [quickstart repository](#) and use it as your working
   directory.

   ```sh
   ~/$ git clone https://github.com/hashicorp/quickstart.git
   Cloning into 'quickstart'...

   ~/$ cd quickstart
   ```

1. Copy the license you received from HashiCorp to the quickstart
   directory.

   ```sh
   ~/quickstart$ cp ~/Downloads/my-company.rli .
   ```

1. Run terraform plan and inspect the results.

   ```sh
   ~/quickstart$ terraform plan -out create.tfplan
   ```

1. Run terraform apply and verify the result.

   ```sh
   ~/quickstart$ terraform apply create.tfplan
   ```

1. Make note of the dashboard_url and dashboard_password outputs, as you
   will need them later to finish configuring the application in your
   browser.

   ```sh
   ~/quickstart$ terraform output dashboard_url
   ~/quickstart$ terraform output dashboard_password
   ```

Wait for GCP to finish provisioning infrastructure, which can take up
to 10 minutes. Once the cluster is ready, you can finish configuring
the application in your browser.

### Customization Options

#### Use Your Own Network

To be completed...

#### Change the Number of Nodes In the Cluster

To be completed...

#### Total Control

You can use the included network, external-services, and cluster
submodules to build a custom cluster that meets your organization’s
requirements.  Need some pointers? The following examples document
common installation patterns:

- [Using the default arguments](https://registry.terraform.io/modules/hashicorp/terraform-enterprise/google/0.1.2/examples/root-example)

- [Using RedHat Enterprise Linux as the operating system](https://registry.terraform.io/modules/hashicorp/terraform-enterprise/google/0.1.2/examples/rhel-production-example)

## What makes up the cluster?

![architecture diagram](https://raw.githubusercontent.com/hashicorp/terraform-google-terraform-enterprise/v0.1.2/assets/gcp_diagram.jpg?raw=true)

More details can be found in the
[GCP Reference Architecture](https://www.terraform.io/docs/enterprise/before-installing/cluster-architecture.html)
from our public docs.

## FAQ

### Why are you using a GLB and an ILB?

To be completed...
