# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| prefix | The prefix which will be prepended to the names of resources. | `string` | n/a | yes |
| vpc\_network\_self\_link | The self link of the network to which resources will be attached. | `string` | n/a | yes |
| vpc\_subnetwork\_ip\_cidr\_range | The range of IP addresses in the subnetwork from which traffic will be authorized to flow, expressed in CIDR notation. | `string` | n/a | yes |
| health\_check\_ip\_cidr\_ranges | The list of GCP health check IP address ranges from which health check traffic will be authorized to flow, expressed in CIDR notation. The default ranges were obtained from the GCP Health Checks Overview: https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges. | `list(string)` | <pre>[<br>  "35.191.0.0/16",<br>  "209.85.152.0/22",<br>  "209.85.204.0/22",<br>  "130.211.0.0/22"<br>]</pre> | no |
| ports | A list of additional ports over which traffic will be authorized to flow. | `list(string)` | `[]` | no |

