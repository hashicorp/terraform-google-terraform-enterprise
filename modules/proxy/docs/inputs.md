# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| install\_id | Identifier for install to apply to resources | `string` | n/a | yes |
| primaries | GCP Instance Group for the primaries | `string` | n/a | yes |
| region | GCP Region | `string` | n/a | yes |
| subnet | GCP Subnetwork for Load Balancer | `object({ ip_cidr_range = string, network = string, self_link = string })` | n/a | yes |
| prefix | Prefix for resources | `string` | `"tfe-"` | no |

