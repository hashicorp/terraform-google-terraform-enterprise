# Terraform Enterprise Clustered: Shared VPC with Internal Load Balancer Example

This example deploys Terraform Enterprise Clustered using
[Shared VPC][shared-vpc] and an internal load balancer, demonstrating
how Terraform Enterprise can be deployed with no publicly-accessible endpoints in a GCP best-practices manner.

Because there is no public endpoint on the deployment, this example is
limited in utility unless the user has the ability to access internal
GCP addresses through a web browser. The [Usage](#usage) section
includes an approach which uses [SSH][ssh] and
[Identity Aware Proxy][iap].

## Background

From the GCP article [Shared VPC][shared-vpc]:

> Shared VPC allows an organization to connect resources from multiple
> projects to a common Virtual Private Cloud (VPC) network, so that they
> can communicate with each other securely and efficiently using
> internal IPs from that network.

The GCP article [Provisioning Shared VPC][provisioning-shared-vpc]
should be reviewed for instructions on how to configure a host project
and a service project prior to executing this example.

The default configuration provided by the root module will deploy TFE
Clustered with a external load balancer which enables access globally
from the public Internet. To restrict access to users within the Shared
VPC, an internal load balancer must be used instead.

## Features

This example provisions TFE infrastructure in both the host project and
the service project in order to use Shared VPC.

For the sake of simplicity, a single Terraform configuration is used to
invoke modules which represent each stage of the deployment, but in
a production setting, these stages should be managed with separate
configurations and linked using
[Terraform remote state][tf-remote-state].

The instructions include the creation of a self-signed SSL certificate
which will be applied to the internal load balancer, based on the GCP
article [Using Self-Managed SSL Certificates][gcp-self-managed-certs].
Alternative certificate files can be specified using
`var.ssl_certificate_file` and `var.ssl_certificate_private_key_file`.

The different modules invoked in this configuration are described below.

### Service Account

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
infrastructure are created in the service project, similar to a
single-project deployment. The notable exception is in the use of the
internal load balancer submodule rather than the external load balancer
submodule. This difference in load balancer submodule selection causes
the TFE Clustered deployment to have no external IP address, which
means that only traffic originating from within the Shared VPC network
will be able to access the user interfaces.

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

# Create a certificate private key.
openssl genrsa \
  -out ./files/certificate-private-key.pem 2048

# Create a certificate signing request.
openssl req \
  -new \
  -key ./files/certificate-private-key.pem \
  -out ./files/main.csr \
  -config ./files/csr.conf

# Create a self-signed certificate.
openssl x509 \
  -req \
  -signkey ./files/certificate-private-key.pem \
  -in ./files/main.csr \
  -out ./files/certificate.pem \
  -days 28

cat ./files/certificate.pem ./files/certificate-private-key.pem \
  | tee ./files/bundle.pem

# Initialize the working directory.
terraform init

# Create the service accounts.
GOOGLE_PROJECT="$SERVICE_PROJECT" terraform apply \
  -target module.service_account

# Create the VPC.
GOOGLE_PROJECT="$HOST_PROJECT" terraform apply \
  -target module.host

# Create the compute resources.
GOOGLE_PROJECT="$SERVICE_PROJECT" terraform apply \
  -target module.service

# Obtain the outputs necessary to access the TFE Clustered deployment.
terraform output

# Forward ports 8443 and 8085 of the working machine to ports 443 and
# 8085 of the internal load balancer.
gcloud compute ssh "$(terraform output internal_load_balancer)" \
  --project "$SERVICE_PROJECT" \
  --zone "$GOOGLE_ZONE" \
  --tunnel-through-iap \
  -- \
  -L "8443:$(terraform output internal_load_balancer_address):443" \
  -L "8085:$(terraform output internal_load_balancer_address):8085"

# In a separate terminal or a in a web browser, access the application
# or install dashboard as necessary.
curl --insecure --location https://localhost:8443/session

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

[gcp-self-managed-certs]: https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs
[iap]: https://cloud.google.com/iap
[provisioning-shared-vpc]: https://cloud.google.com/vpc/docs/provisioning-shared-vpc
[shared-vpc]: https://cloud.google.com/vpc/docs/shared-vpc
[ssh]: https://en.wikipedia.org/wiki/Secure_Shell
[tf-install]: https://learn.hashicorp.com/terraform/getting-started/install
[tf-remote-state]: https://www.terraform.io/docs/state/remote.html
