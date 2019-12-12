# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| credentials | Path to GCP credentials .json file | `string` | n/a | yes |
| dnszone | Name of the managed dns zone to create records into | `string` | n/a | yes |
| license\_file | Replicated license file | `string` | n/a | yes |
| project | Name of the project to deploy into | `string` | n/a | yes |
| hostname | DNS hostname for load balancer, appended with the zone's domain | `string` | `"tfe"` | no |
| install\_id | Identifier to use in names to identify resources | `string` | `""` | no |
| prefix | Prefix to apply to all resources names | `string` | `"tfe-"` | no |
| region | The region to install into. | `string` | `"us-central1"` | no |

