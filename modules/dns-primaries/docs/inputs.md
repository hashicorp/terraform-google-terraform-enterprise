# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| dnszone | Name of the DNS Zone to add records to | `string` | n/a | yes |
| install\_id | Identifier for install to apply to resources | `string` | n/a | yes |
| primaries | Information about primaries to add DNS | <pre>list(<br>    object({<br>      hostname = string,<br>      address  = string,<br>    })<br>  )</pre> | n/a | yes |
| prefix | Prefix for resources | `string` | `"tfe-"` | no |

