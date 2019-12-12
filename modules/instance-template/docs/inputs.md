# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| airgap\_installer\_url | n/a | `any` | n/a | yes |
| airgap\_package\_url | n/a | `any` | n/a | yes |
| assistant-host | n/a | `any` | n/a | yes |
| assistant-token | n/a | `any` | n/a | yes |
| b64-license | n/a | `any` | n/a | yes |
| bootstrap\_token\_id | bootstrap token id | `string` | n/a | yes |
| bootstrap\_token\_suffix | bootstrap token suffix | `string` | n/a | yes |
| cluster\_endpoint | the cluster endpoint | `string` | n/a | yes |
| credentials\_file | n/a | `any` | n/a | yes |
| encryption\_password | n/a | `any` | n/a | yes |
| gcs\_bucket | n/a | `any` | n/a | yes |
| gcs\_credentials | n/a | `any` | n/a | yes |
| gcs\_project | n/a | `any` | n/a | yes |
| http\_proxy\_url | HTTP(S) proxy url | `string` | n/a | yes |
| image\_family | image family | `string` | n/a | yes |
| jq\_url | Location of the jq package | `string` | n/a | yes |
| postgresql\_address | n/a | `any` | n/a | yes |
| postgresql\_database | n/a | `any` | n/a | yes |
| postgresql\_extra\_params | n/a | `any` | n/a | yes |
| postgresql\_password | n/a | `any` | n/a | yes |
| postgresql\_user | n/a | `any` | n/a | yes |
| prefix | Prefix for resource names | `string` | n/a | yes |
| project | n/a | `any` | n/a | yes |
| ptfe\_install\_url | Location of the ptfe install tool zip file | `string` | n/a | yes |
| ptfe\_subnet | subnet to deploy into | `string` | n/a | yes |
| region | The region to install into. | `string` | n/a | yes |
| release\_sequence | Replicated release sequence | `string` | n/a | yes |
| repl\_cidr | n/a | `any` | n/a | yes |
| repl\_data | console | `string` | n/a | yes |
| secondary\_machine\_type | Type of machine to use | `string` | n/a | yes |
| setup\_token | setup token | `string` | n/a | yes |
| weave\_cidr | n/a | `any` | n/a | yes |
| boot\_disk\_size | The size of the boot disk to use for the instances | `string` | `40` | no |
| ca\_bundle\_url | URL to CA certificate file used for the internal `ptfe-proxy` used for outgoing connections | `string` | `"none"` | no |

