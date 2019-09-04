# Terraform Enterprise HA (Beta) Example

This example assumes you have already set up your gcp project with the required prereqs:

* VPC
* Subnet specifically for Terrafrom Enterprise
* Firewall rules as outlined [in the instructions](https://www.terraform.io/docs/enterprise/beta/gcp.html#infrastructure)
* A valid certificate and ssl policy in gcp. (If you are not going to use a google managed ssl certificate, please [read the instructions here on what to comment out](https://www.terraform.io/docs/enterprise/beta/gcp.html#explanation-of-variables))
* An IP address and DNS entry for the front end load balancer
* A DNS Zone in gcp
* A license file provided by your Technical Account Manager

With this code you can either create a single instance, or a build a cluster:

![basic architecture diagram](https://github.com/hashicorp/terraform-google-terraform-enterprise/blob/v0.0.1-beta/assets/gcp_diagram.jpg?raw=true)

## Change to the example directory

```bash
cd examples/root-example
```

## Install Terraform

Install Terraform if it is not already installed (visit [terraform.io](https://terraform.io) for other distributions):

```bash
../terraform-install.sh
```

## Set the desired options in the module block

You'll need to update the following settings to your set up:

* project: name of the project
* creds: json file name
* publicip: The IP address to attach to the load balancer
* domain: domain to use
* dnszone: the name of the dns zone in gcp
* cert: the api url of the google certficiate to use
* sslpolicy: name of the ssl policy to use
* subnet: subnet to deploy into (this should be reserved for tfe)

 This example is set to spin up a single instance, but the `primary_count` and `secondary_count` can be updated to build a cluster instead.  

## Run Terraform

```bash
terraform init
terraform apply
```

## Wait for the application to load

The replicated console url will output along with the password.

![output](https://github.com/hashicorp/terraform-google-terraform-enterprise/blob/master/examples/root-example/output_example.png?raw=true)

You can log into that dashboard at that url and wait for the application to be ready. This can take up to 30 minutes! Once complete use the `Open` link to set up the admin user and initial organization.

![application started](https://github.com/hashicorp/terraform-google-terraform-enterprise/blob/master/examples/root-example/app_started.png?raw=true)
