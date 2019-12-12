# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| creds | Name of credential file | `string` | n/a | yes |
| dnszone | Managed DNZ Zone name | `string` | n/a | yes |
| domain | domain name | `string` | n/a | yes |
| postgresql\_password | Password for Postgres Database | `string` | n/a | yes |
| project | Name of the project to deploy into | `string` | n/a | yes |
| frontenddns | DNS name for load balancer | `string` | `"tfe"` | no |
| healthchk\_ips | List of gcp health check ips to allow through the firewall | `list(string)` | <pre>[<br>  "35.191.0.0/16",<br>  "209.85.152.0/22",<br>  "209.85.204.0/22",<br>  "130.211.0.0/22"<br>]</pre> | no |
| name | Name to pass to your resources | `string` | `"ptfe"` | no |
| postgresql\_dbname | Name of Postgres Database | `string` | `"ptfe"` | no |
| postgresql\_machinetype | Machine type to use for Postgres Database | `string` | `"db-f1-micro"` | no |
| postgresql\_user | Username for Postgres Database | `string` | `"tfepsqluser"` | no |
| primaryhostname | hostname prefix | `string` | `"ptfe-primary"` | no |
| region | The region to install into. | `string` | `"us-central1"` | no |
| subnet\_range | CIDR range for subnet | `string` | `"10.1.0.0/16"` | no |
| zone | Preferred zone | `string` | `"us-central1-a"` | no |

