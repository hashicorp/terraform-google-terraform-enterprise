# Terraform Enterprise: High Availability - Instance Template Submodule

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bootstrap\_token\_id | bootstrap token id | string | n/a | yes |
| bootstrap\_token\_suffix | bootstrap token suffix | string | n/a | yes |
| cluster\_endpoint | the cluster endpoint | string | n/a | yes |
| image\_family | image family | string | n/a | yes |
| install\_type | type of install - poc or production | string | n/a | yes |
| ptfe\_subnet | subnet to deploy into | string | n/a | yes |
| region | The region to install into. | string | n/a | yes |
| release\_sequence | Replicated release sequence | string | n/a | yes |
| repl\_data | console | string | n/a | yes |
| secondary\_machine\_type | Type of machine to use | string | n/a | yes |
| setup\_token | setup token | string | n/a | yes |
| boot\_disk\_size | The size of the boot disk to use for the instances | string | `"40"` | no |
| ca_cert_url | URL to CA certificate file used for the internal `ptfe-proxy` used for outgoing connections| string | `"none"` | no |

## Outputs

| Name | Description |
|------|-------------|
| secondary\_template |  |
