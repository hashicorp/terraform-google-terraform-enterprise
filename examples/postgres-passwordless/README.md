# PostgreSQL Passwordless Authentication Example

This example demonstrates deploying Terraform Enterprise with PostgreSQL IAM authentication (passwordless authentication) enabled on Google Cloud Platform.

## About This Example

This configuration deploys a single-node TFE instance in external mode with:

- Google Cloud SQL PostgreSQL instance with IAM authentication enabled
- Dedicated service account for database authentication
- Cloud SQL Client IAM role assignment
- PostgreSQL connection using IAM authentication instead of passwords

## Prerequisites

- GCP project with appropriate APIs enabled
- DNS zone configured in Cloud DNS
- SSL certificate available in Certificate Manager
- Terraform Enterprise license file

## Usage

To run this example, you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money. Run `terraform destroy` when you don't need these resources.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |
| google | ~> 5.0 |
| random | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| google | ~> 5.0 |
| random | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| dns_zone_name | The name of the DNS zone in which a record will be created. | `string` | n/a | yes |
| existing_service_account_id | The ID of the logging service account to use for compute resources deployed. | `string` | `null` | no |
| fqdn | The fully qualified domain name which will be assigned to the DNS record. | `string` | n/a | yes |
| license_file | The local path to the Terraform Enterprise license. | `string` | n/a | yes |
| project_id | The GCP project ID where resources will be created. | `string` | n/a | yes |
| ssl_certificate_name | The name of an existing SSL certificate which will be used to authenticate connections to the load balancer. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| database_service_account | The email of the service account used for PostgreSQL IAM authentication. |
| health_check_url | The URL of the Terraform Enterprise health check endpoint. |
| iact_notice | Login advice message. |
| iact_url | IACT URL |
| initial_admin_user_url | The URL of the initial admin user. |
| login_url | The URL for the Terraform Enterprise login. |
| tfe_url | The URL of the Terraform Enterprise application. |

## IAM Authentication Details

This example creates a dedicated service account for database authentication and grants it the `roles/cloudsql.client` role. The TFE application will use this service account to authenticate to PostgreSQL using Google Cloud IAM instead of traditional username/password authentication.

The PostgreSQL connection will use the following authentication method:
- Connection string includes `authtype=gcp_iam` parameter
- No password is required or stored
- Authentication is handled through Google Cloud IAM tokens

## Security Benefits

Using IAM authentication provides several security benefits:
- No passwords to manage or rotate
- Authentication tied to Google Cloud IAM
- Automatic token refresh
- Audit trail through Cloud Logging
- Fine-grained access control through IAM roles