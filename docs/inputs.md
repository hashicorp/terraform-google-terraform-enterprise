# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| credentials | Path to GCP credentials .json file | `string` | n/a | yes |
| dnszone | Name of the managed dns zone to create records into | `string` | n/a | yes |
| license\_file | Replicated license file | `string` | n/a | yes |
| project | Name of the project to deploy into | `string` | n/a | yes |
| autoscaler\_cpu\_threshold | The cpu threshold at which the autoscaling group to build another instance | `string` | `"0.7"` | no |
| hostname | DNS hostname for load balancer, appended with the zone's domain | `string` | `"tfe"` | no |
| install\_id | Identifier to use in names to identify resources | `string` | `""` | no |
| max\_secondaries | The maximum number of secondaries in the autoscaling group | `string` | `"3"` | no |
| min\_secondaries | The minimum number of secondaries in the autoscaling group | `string` | `"0"` | no |
| postgresql\_availability\_type | This specifies whether a PostgreSQL instance should be set up for high availability (REGIONAL) or single zone (ZONAL) | `string` | `"ZONAL"` | no |
| postgresql\_backup\_start\_time | HH:MM format time indicating when backup configuration starts. | `string` | `""` | no |
| prefix | Prefix to apply to all resources names | `string` | `"tfe-"` | no |
| region | The region to install into. | `string` | `"us-central1"` | no |

