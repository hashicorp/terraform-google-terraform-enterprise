# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| install\_id | Identifier for install to apply to resources | `string` | n/a | yes |
| subnet\_ip\_range | IP Range in CIDR syntax for the subnet to allow access to for health checks | `string` | n/a | yes |
| vpc\_name | Name of Google Compute Network to install firewall to | `string` | n/a | yes |
| firewall\_ports | Additional ports to allow through the firewall | `list(string)` | `[]` | no |
| healthcheck\_ips | List of gcp health check ips to allow through the firewall | `list(string)` | <pre>[<br>  "35.191.0.0/16",<br>  "209.85.152.0/22",<br>  "209.85.204.0/22",<br>  "130.211.0.0/22"<br>]</pre> | no |
| prefix | Name to attach to your VPC | `string` | `"tfe-"` | no |

