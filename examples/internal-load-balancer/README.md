# Terraform Enterprise Clustered: Internal Load Balancer Example

This example deploys TFE Clustered using an internal load balancer, demonstrating
how a Terraform configuration can be designed with no
publicly-accessible endpoints.

Because there is no public endpoint on the deployment, this example is
limited in utility unless the user has the ability to access internal
GCP addresses through a web browser. The [Usage](#usage) section
includes an approach which uses [SSH][ssh] and
[Identity Aware Proxy][iap].

## Background

The default configuration provided by the root module will deploy TFE
Clustered with a external load balancer which enables access globally
from the public Internet. If access must be restricted to users within a
GCP VPC, an internal load balancer must be used instead.

## Features

This example provisions TFE Clustered infrastructure using the internal
load balancer submodule.

The instructions include the creation of a self-signed SSL certificate
which will be applied to the load balancer, based on the
[GCP Using Self-Managed SSL Certificates article][gcp-self-managed-certs].
Alternative certificate files can be specified using
`var.ssl_certificate_file` and `var.ssl_certificate_private_key_file`.

## Requirements

The following requirements must be met in order to execute this example:

- the latest version of Terraform 0.12 is [installed][tf-install] on the
  working machine
- the [Google Cloud SDK][google-cloud-sdk] is installed on the working machine
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

# Initialize the working directory.
terraform init

# Create the infrastructure.
terraform apply

# Forward port 8443 of the working machine to port 443 of the internal load balancer.
gcloud compute ssh "$(terraform output primary_0)" \
  --tunnel-through-iap \
  -- -L "8443:$(terraform output internal_load_balancer_address):443"

# Confirm the application is being served by the internal load balancer.
curl --insecure --location https://localhost:8443/session

# Destroy the infrastructure.
terraform destroy
```

<!-- URLs for links -->

[gcp-self-managed-certs]: https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs
[google-cloud-sdk]: https://cloud.google.com/sdk
[google-provider]: https://registry.terraform.io/providers/hashicorp/google/3.2.0/docs/guides/provider_reference#full-reference
[iap]: https://cloud.google.com/iap
[ssh]: https://en.wikipedia.org/wiki/Secure_Shell
[tf-install]: https://learn.hashicorp.com/terraform/getting-started/install
