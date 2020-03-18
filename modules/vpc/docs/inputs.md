# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| prefix | The prefix which will be prepended to the names of resources. | `string` | n/a | yes |
| health\_check\_address\_ranges | The list of GCP health check IP address ranges from which health check traffic will be authorized to flow, expressed in CIDR notation. | `list(string)` | <pre>[<br>  "35.191.0.0/16",<br>  "209.85.152.0/22",<br>  "209.85.204.0/22",<br>  "130.211.0.0/22"<br>]</pre> | no |
| vpc\_subnetwork\_ip\_cidr\_range | The range of IP addresses to provision in the subnetwork, expressed in CIDR notation. | `string` | `"10.1.0.0/16"` | no |

