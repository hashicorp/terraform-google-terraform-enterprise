# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| ip\_cidr\_range | The range from which IP addresses will be assigned to resources, expressed in CIDR notation. The range must be part of var.subnetwork. | `string` | n/a | yes |
| network | The name or the self link of the network to which resources will be attached. | `string` | n/a | yes |
| primaries\_instance\_group | GCP Instance Group for the primaries | `string` | n/a | yes |
| subnetwork | The name or the self link of the subnetwork to which resources will be attached. The subnetwork must be part of var.network. | `string` | n/a | yes |
| subnetwork\_project | The ID of the project in which var.subnetwork exists. | `string` | n/a | yes |
| cluster\_assistant\_port | The port of the Cluster Assistant. | `number` | `23010` | no |
| k8s\_api\_port | The port of the Kubernetes API. | `number` | `6443` | no |
| ports | Only packets addressed to these ports will be forwarded through the proxy. var.k8s\_api\_port will be added to this list. | `list(number)` | <pre>[<br>  80,<br>  443,<br>  23010<br>]</pre> | no |
| prefix | Prefix for resources | `string` | `"tfe-"` | no |

