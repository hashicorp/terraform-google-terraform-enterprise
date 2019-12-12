# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cert | certificate for the load balancer | `string` | n/a | yes |
| install\_id | Identifier for install to apply to resources | `string` | n/a | yes |
| instance\_group | primary instance group | `string` | n/a | yes |
| prefix | Prefix for resources | `string` | `"tfe-"` | no |
| ssl\_policy | SSL policy for the cert. Default to TLS 1.2 Only | `string` | `""` | no |

