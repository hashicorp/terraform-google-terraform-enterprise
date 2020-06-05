# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| prefix | The prefix which will be prepended to the names of resources. | `string` | n/a | yes |
| primaries\_instance\_groups\_self\_links | The self links of the compute instance groups which comprise the primaries. | `list(string)` | n/a | yes |
| secondaries\_instance\_group\_manager\_instance\_group | The compute instance group of the secondaries. | `string` | n/a | yes |
| ssl\_certificate | The content of a SSL/TLS certificate to be attached to the load balancer. The content must be in PEM format. The certificate chain must be no greater than 5 certs long and it must include at least one intermediate cert. | `string` | n/a | yes |
| ssl\_certificate\_private\_key | The content of the write-only private key of var.ssl\_certificate. The content must be in PEM format. | `string` | n/a | yes |
| vpc\_application\_tcp\_port | The application TCP port. | `string` | n/a | yes |
| vpc\_install\_dashboard\_tcp\_port | The install dashboard TCP port. | `string` | n/a | yes |
| vpc\_network\_self\_link | The self link of the network to which resources will be attached. | `string` | n/a | yes |
| vpc\_subnetwork\_self\_link | The self link of the subnetwork to which resources will be attached. The subnetwork must be part of var.vpc\_network\_self\_link. | `string` | n/a | yes |
| labels | A collection of labels which will be applied to resources. | `map(string)` | `{}` | no |

