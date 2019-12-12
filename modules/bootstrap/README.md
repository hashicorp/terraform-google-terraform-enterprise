This Module preps your GCP Project for an installation of Terraform Enterprise. This Module will create a VPC, Subnet, GCS Bucket, Postgres Database, Firewalls, and SSL Certificate.

## Pre-Requisites

The following items must be configured prior to using this Module:

- A GCP Project
- Valid GCP Credentials stored in JSON format
- A valid DNS Zone
- A valid Domain
- Enable the servicenetworking.googleapis.com API in your GCP Project
- Enable the cloudresourcemanager.googleapis.com API in your GCP Project

## Required Variables

- `project` -- name of the GCP Project into which you'll install Terraform Enterprise
- `creds` -- path to and name of the JSON Credential file to use
- `domain` -- the Domain to be used
- `dnszone` -- the pre-configured DNS Zone
- `postgresql_password` -- password for your Postgres Database


## Developer quickstart

### Install the gcloud tool

These steps will use the CLI `gcloud` tool, so install that. 

1. On macOS: `brew cask install google-cloud-sdk`


### Establish a Project

The variable PROJECT contains the name of a project to install into, for instance `tfe-staging`. If you need to create a project:
1. `gcloud projects create $PROJECT --enable-cloud-apis`

Then make the project the default:
1. `gcloud config set project $PROJECT`

### Setup DNS

You'll need a DNS Zone to use for the installation. If you have an existing domain but don't have one in the project, the easiest
is to create a new DNS Zone as a subdomain of your existing domain, and then delegate it.

To create the domain:
1. `gcloud dns managed-zones create gcp --dns-name=gcp.mycompany.com --description=tfe`

Then describe the new DNS Zone to find out the name servers:
1. `gcloud dns managed-zones describe gcp`

Now take those nameservers and add them to your existing domain. For instance `gcp NS ns-cloud-a1.googledomains.com.` under `mycompany.com`
