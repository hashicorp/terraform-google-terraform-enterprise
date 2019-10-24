# Terraform Enterprise: High Availability - Load Balancer Submodule

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cert | certificate for the load balancer | string | n/a | yes |
| domain | domain | string | n/a | yes |
| frontenddns | front end url name | string | n/a | yes |
| instance\_group | primary instance group | string | n/a | yes |
| prefix | Prefix for resource names | string | n/a | yes |
| primary\_instances | primary instances | list | n/a | yes |
| publicIP | External-facing IP address for PTFE application | string | n/a | yes |
| sslpolicy | SSL policy for the cert | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_endpoint |  |
