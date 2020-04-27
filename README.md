# Terraform Enterprise Clustered on Google Cloud Platform

The **terraform-enterprise** Terraform module is the official way for
HashiCorp customers to provision [Terraform Enterprise Clustered][tfe]
on Google Cloud Platform (GCP).

![architecture diagram][architecture-diagram]

*Terraform Enterprise Clustered architecture*

More details can be found in the
[clustered architecture overview][tfe-clustered-architecture].

This README is best viewed on the
[Terraform Registry][tf-registry], where the submodules,
examples, inputs, and outputs are browseable.

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

The **terraform-enterprise** module can be used through the quickstart
method or by including it in a Terraform configuration.

### Quickstart

The quickstart method provides a ready-to-apply Terraform configuration
which includes the **terraform-enterprise** module. More information is
available in the [quickstart repository][quickstart].

### Terraform Configuration

There are two ways to use the **terraform-enterprise** module in a
Terraform configuration.

The **root** module can be included to provide a minimal, opinionated
deployment with limited inputs.

```hcl
module "terraform_enterprise" {
  source  = "hashicorp/terraform-enterprise/google"
  version = "VERSION"

  # insert the required inputs here
}
```

*~/work/main.tf*

If the **root** module does not satisfy a particular use case then the
submodules can be included directly and composed together in a custom
manner.

In both cases, the [module version][tf-module-version] should be
constrained following Terraform best practices.

The [Terraform Registry][tf-registry] includes the list of module
versions, the required inputs, as well as documentation and
examples which demonstrate how to compose the submodules.

When the Terraform configuration is completed, the
working directory must be initialized and then the configuration may be
applied to provision the infrastructure.

```sh
~/work$ terraform init
```

*Initializing the working directory*

```sh
~/work$ terraform apply
```

*Applying the configuration*

Once the infrastructure has been provisioned, the configuration of
Terraform Enterprise must be completed through the installer dashboard
in a web browser. The dashboard URL and password are output by the root
module. These outputs should be forwarded when using the root module or
reproduced when using the submodules.

```sh
~/work$ terraform output dashboard_url
~/work$ terraform output dashboard_password
```

*Reading the outputs*

Because the compute instances are created without external IP
addresses, a method alternative to a direct [SSH][ssh] connection must
be used to establish a remote connection with any of the instances. Two
simple alternative methods are to use
[SSH from the browser][ssh-in-browser] or [Identity-Aware Proxy][iap].

```sh
~/work$ gcloud compute ssh <tfe-instance> --tunnel-through-iap
```

*Example of connecting to an instance through IAP*

## Support

Any Enterprise questions should be directed to
[HashiCorp Support][hashicorp-support] or the
[Terraform community forum][tf-community-forum].

[GitHub issue][github-issues] should be used to report bugs in the
**terraform-enterprise** module.

<!-- URLs for links -->

[architecture-diagram]: https://raw.githubusercontent.com/hashicorp/terraform-google-terraform-enterprise/v0.1.2/assets/gcp_diagram.jpg?raw=true
[github-issues]: https://github.com/hashicorp/terraform-google-terraform-enterprise/issues
[google-provider]: https://registry.terraform.io/providers/hashicorp/google/3.2.0/docs/guides/provider_reference#full-reference
[hashicorp-support]: https://support.hashicorp.com/
[iap]: https://cloud.google.com/iap
[quickstart]: https://github.com/hashicorp/terraform-google-terraform-enterprise-quickstart
[ssh]: https://en.wikipedia.org/wiki/Secure_Shell
[ssh-in-browser]: https://cloud.google.com/compute/docs/ssh-in-browser
[tf-community-forum]: https://discuss.hashicorp.com/c/terraform-core
[tf-install]: https://learn.hashicorp.com/terraform/getting-started/install
[tf-module-version]: https://www.terraform.io/docs/configuration/modules.html#module-versions
[tf-registry]: https://registry.terraform.io/modules/hashicorp/terraform-enterprise/google
[tfe-clustered-architecture]: https://www.terraform.io/docs/enterprise/before-installing/cluster-architecture.html
[tfe]: https://www.terraform.io/docs/enterprise/index.html
