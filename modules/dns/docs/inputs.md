# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| external\_load\_balancer\_address | The public IP address of the external load balancer. | `string` | n/a | yes |
| managed\_zone | The name of the managed DNS zone in which the application will be accessible. | `string` | n/a | yes |
| managed\_zone\_dns\_name | The fully qualified DNS name of the managed zone set by var.managed\_zone. | `string` | n/a | yes |
| hostname | The hostname for the external load balancer. | `string` | `"tfe"` | no |

