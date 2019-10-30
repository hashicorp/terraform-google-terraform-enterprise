# Terraform Enterprise: High Availability for Google (BETA)

![Terraform Logo](https://github.com/hashicorp/terraform-google-terraform-enterprise/blob/master/assets/TerraformLogo.png?raw=true)

## Description

This module installs Terraform Enterprise HA BETA onto 1 or more gcp instances in DEMO mode. All data is stored on the instance(s) and is not preserved.

An Ubuntu Bionic (18.04 LTS) image is chosen by default, but this config supports previous version of Ubuntu as well as Red Hat Enterprise Linux 7.2-7.7 (v8 is not supported.)

## Architecture

![basic diagram](https://github.com/hashicorp/terraform-google-terraform-enterprise/blob/v0.0.1-beta/assets/gcp_diagram.jpg?raw=true)
_example architecture_

Please contact your Technical Account Manager for more information, and support for any issues you have.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| certificate | Path to Certificate file or GCP certificate link | string | n/a | yes |
| credentials\_file | Path to credential file | string | n/a | yes |
| dns\_zone | Managed DNS Zone name | string | n/a | yes |
| domain | domain name | string | n/a | yes |
| frontend\_dns | DNS name for load balancer | string | n/a | yes |
| license\_file | License file | string | n/a | yes |
| project | Name of the project to deploy into | string | n/a | yes |
| public\_ip | the public IP for the load balancer to use | string | n/a | yes |
| ssl\_policy | SSL policy for the cert | string | n/a | yes |
| subnet | name of the subnet to install into | string | n/a | yes |
| airgap\_installer\_url | URL to replicated's airgap installer package | string | `"https://install.terraform.io/installer/replicated-v5.tar.gz"` | no |
| airgap\_package\_url | airgap url | string | `"none"` | no |
| boot\_disk\_size | The size of the boot disk to use for the instances | string | `"40"` | no |
| ca\_bundle\_url | URL to Custom CA bundle used for outgoing connections | string | `"none"` | no |
| dns\_project | Name of project where the DNS zone resides | string | `""` | no |
| encryption\_password | encryption password for the vault unseal key. save this! | string | `""` | no |
| gcs\_bucket | Name of the gcp storage bucket | string | `""` | no |
| gcs\_credentials | Base64 encoded credentials json to access your gcp storage bucket. Run base64 -i <creds.json> -o <credsb64.json> and then copy the contents of the file into the variable | string | `""` | no |
| gcs\_project | Project name where the bucket resides, if left blank will use project provided above | string | `""` | no |
| http\_proxy\_url | HTTP(S) proxy url | string | `"none"` | no |
| image\_family | The image family, choose from ubuntu-1604-lts, ubuntu-1804-lts, or rhel-7 | string | `"ubuntu-1804-lts"` | no |
| jq\_url | Location of the jq package | string | `"https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64"` | no |
| postgresql\_address | Database connection url | string | `""` | no |
| postgresql\_database | Database name | string | `""` | no |
| postgresql\_extra\_params | Extra connection parameters such as ssl=true | string | `""` | no |
| postgresql\_password | Base64 encoded database password | string | `""` | no |
| postgresql\_user | Database username | string | `"none"` | no |
| prefix | Resource and instance prefix | string | `"tfe"` | no |
| primary\_count | Number of primary nodes to run, must be odd number - 3 or 5 recommended. | string | `"3"` | no |
| primary\_machine\_type | Type of machine to use | string | `"n1-standard-4"` | no |
| ptfe\_install\_url | Location of the ptfe install tool zip file | string | `"https://install.terraform.io/installer/ptfe.zip"` | no |
| region | The region to install into. | string | `"us-central1"` | no |
| release\_sequence | Replicated release sequence | string | `"latest"` | no |
| repl\_cidr | Specify a non-standard CIDR range for the replicated services. The default is 10.96.0.0/12 | string | `""` | no |
| secondary\_count | Number of secondary nodes to run | string | `"0"` | no |
| secondary\_machine\_type | Type of machine to use for secondary nodes, if unset, will default to primary_machine_type | string | `"n1-standard-4"` | no |
| weave\_cidr | Specify a non-standard CIDR range for weave. The default is 10.32.0.0/12 | string | `""` | no |
| zone | Preferred zone | string | `"us-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| application\_endpoint | The URI to access the Terraform Enterprise Application. |
| application\_health\_check | The URI for the Terraform Enterprise Application health check. |
| installer\_dashboard\_password | The password to access the installer dashboard. |
| installer\_dashboard\_url | The URL to access the installer dashboard. |
| primary\_public\_ip | The Public IP for the load balancer to use. |
