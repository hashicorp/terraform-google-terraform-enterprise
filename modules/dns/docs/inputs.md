# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| address | IP Address to associate with the hostname | `string` | n/a | yes |
| dnszone | name of the managed dns zone | `string` | n/a | yes |
| hostname | DNS hostname for load balancer, appended with the zone's domain | `string` | n/a | yes |
| install\_id | Identifier for install to apply to resources | `string` | n/a | yes |
| prefix | Prefix for resources | `string` | `"tfe-"` | no |

