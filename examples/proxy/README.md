# Terraform Enterprise Clustered: Proxy Example

This example deploys TFE Clustered using a proxy server.

## Background

From the Wikipedia article [Proxy Server][proxy-server]:

> ...a proxy server is a server application or appliance that acts as
> an intermediary for requests from clients seeking resources from
> servers that provide those resources.

The GCP article [Configuring a VM as a Network Proxy][proxy-vm]
provides more details about configuring a proxy server within GCP.

## Features

This example provisions TFE infrastructure along with extra compute
resources which configure the proxy server.

A compute instance which is designated as the proxy server is configured
to run [Squid][squid] as a service. A firewall rule allows all ingress
traffic from the primaries and the secondaries to the proxy server;
that traffic is subsequently forwarded to the external network by
Squid. The URL of the proxy server is used in the cloud-init
configurations of the primaries and the secondaries to define the
`http_proxy` environment variable for the installation and operation of
TFE.

## Requirements

The following requirements must be met in order to execute this example:

- the latest version of Terraform 0.12 is [installed][tf-install] on the
  working machine
- a Terraform Enterprise license provided by a HashiCorp
  Account Manager is located on the working machine
- the Google provider and the Google Beta provider are configured with
  the credentials of a GCP account which has sufficient permissions to
  provision the infrastructure

### GCP Account Permissions

The GCP account must be an IAM member with the following roles in the
project to which TFE will be deployed:

- Cloud SQL Admin (roles/cloudsql.admin)
- Compute Admin (roles/compute.admin)
- DNS Administrator (roles/dns.admin)
- Service Account Admin (roles/iam.serviceAccountAdmin)
- Service Account Key Admin (roles/iam.serviceAccountKeyAdmin)
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

[proxy-server]: https://en.wikipedia.org/wiki/Proxy_server
[proxy-vm]: https://cloud.google.com/vpc/docs/special-configurations#proxyvm
[squid]: http://www.squid-cache.org/
[tf-install]: https://learn.hashicorp.com/terraform/getting-started/install
