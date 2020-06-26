# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cloud\_init\_license\_file | The pathname of a Replicated license file for the application. | `string` | n/a | yes |
| dns\_managed\_zone | The name of the managed DNS zone in which the application will be accessible. | `string` | n/a | yes |
| dns\_managed\_zone\_dns\_name | The fully qualified DNS name of the managed zone set by var.dns\_managed\_zone. | `string` | n/a | yes |
| service\_project | The ID of the Shared VPC service project. | `string` | n/a | yes |
| labels | A collection of labels which will be applied to resources. | `map(string)` | `{}` | no |
| prefix | The prefix which will be prepended to the names of resources. | `string` | `"tfe-vpc-"` | no |
| ssl\_bundle\_file | The pathname of an SSL certificate and private key bundle to be used for application traffic authentication. The file must be in PEM format. | `string` | `"./files/bundle.pem"` | no |

