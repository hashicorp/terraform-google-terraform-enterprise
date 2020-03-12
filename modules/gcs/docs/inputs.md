# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| install\_id | Identifier for install to apply to resources | `string` | n/a | yes |
| labels | Labels to apply to the storage bucket | `map(string)` | `{}` | no |
| prefix | Prefix for resources | `string` | `"tfe-"` | no |

