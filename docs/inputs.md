# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| dnszone | Name of the managed dns zone to create records into | `string` | n/a | yes |
| license\_file | Replicated license file | `string` | n/a | yes |
| hostname | DNS hostname for load balancer, appended with the zone's domain | `string` | `"tfe"` | no |
| install\_id | Identifier to use in names to identify resources | `string` | `""` | no |
| postgresql\_availability\_type | This specifies whether a PostgreSQL instance should be set up for high availability (REGIONAL) or single zone (ZONAL) | `string` | `"ZONAL"` | no |
| postgresql\_backup\_start\_time | HH:MM format time indicating when backup configuration starts. | `string` | `""` | no |
| prefix | The prefix which will be prepended to the names of resources. | `string` | `"tfe-"` | no |

