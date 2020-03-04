# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| prefix | The prefix which will be prepended to the names of resources. | `string` | n/a | yes |
| subnetwork\_ip\_cidr\_range | The range of IP addresses to provision in the subnetwork, expressed in CIDR notation. | `string` | `"10.1.0.0/16"` | no |

