# EXAMPLE: Terraform Enterprise Bank Persona

## About This Example

This example demonstrates how to invoke the root module in the manner
of the Bank persona.

Traits of the Bank persona include:

- Active/Active mode

- a large VM machine type (n1-standard-32)

- Red Hat 7.8 as the VM image

- a privately accessible TCP load balancer with TLS pass-through

- a proxy server with TLS termination

- Redis authentication

- Redis encryption in transit

## How to Use This Module

If this repository has been cloned to a workstation then the
configuration in this directory can be applied. Alternatively, the
following HCL sample demonstrates how to invoke the root module in the
manner of the Bank persona:

```hcl
module "tfe" {
  source = "git@github.com:hashicorp/terraform-google-terraform-enterprise-tfe-gcp.git"

  dns_zone_name        = "<Name of the DNS zone in which a record set will be created>"
  fqdn                 = "<Fully qualified domain name>"
  namespace            = "<Namespace to uniquely identify resources>"
  node_count           = 2
  license_secret       = "<Secret Manager secret comprising license>
  ssl_certificate_name = "<Name of the SSL certificate provisioned in GCP>"

  load_balancer        = "PRIVATE"
  proxy_ip             = "<IP address of the existing proxy>"
  redis_auth_enabled   = true
  vm_disk_source_image = "<Source image for VM disk>"
  vm_machine_type      = "n1-standard-16"
}
```

Refer to the Google provider article on
[authentication](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication)
for instructions on how to authenticate Terraform with GCP.

With authentication configured, run `terraform init` and
`terraform apply` to provision the example infrastructure.

### Accessing the Private Deployment via Web Browser

An SOCKS5 proxy over an SSH channel through GCP's Identity Aware Proxy
can be used to access the TFE deployment from outside of the GCP
network. The following example demonstrates how to establish a SOCKS5
proxy using Bash, gcloud, and jq.

First, define the namespace of the TFE deployment. The following
example uses "bank":

```bash
tfe_namespace='bank'
```

Second, establish the SOCKS5 proxy. The following example creates a
proxy listening to port 5000 and bound to localhost which forwards
traffic through one of the compute instances in the TFE delpoyment:

```bash
read tfe_instance_name tfe_instance_zone < <(echo $( \
  gcloud compute instances list \
    --filter="name:( ${tfe_namespace}-tfe-vm* )" \
    --format='json' \
  | jq --raw-output '.[0].name, .[0].zone' \
)) \
&& gcloud compute ssh \
  --tunnel-through-iap \
  --zone="${tfe_instance_zone}" \
  "${tfe_instance_name}" \
  -- -N -p 22 -D localhost:5000
```

Third, a web browser or the operating system must be configured to use
the SOCKS5 proxy. The instructions to accomplish this vary depending on
the browser or operating system in use, but in Firefox, this can be
configured in:

> Preferences > Network Settings > Manual proxy configuration >
> SOCKS: Host; Port

Fourth, the URL from the login_url Terraform output can be accessed
through the browser to start using the deployment. It is expected that
the browser will issue an untrusted certificate warning as this example
attaches a self-signed certificate to the internal load balancer.

## Required Inputs

`namespace` - Namespace to uniquely identify resources. Used in name prefixes

`license_secret` - The Secret Manager secret which comprises the
Base64 encoded Replicated license file. The Terraform provider calls
this value the secret_id and the GCP UI calls it the name.

`dns_zone_name` - Name of the DNS zone in which a record set will be
created

`fqdn` - Fully qualified domain name
