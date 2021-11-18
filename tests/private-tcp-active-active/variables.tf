variable "google" {
  description = "Attributes of the Google Cloud account which will host the test infrastructure."
  type = object({
    credentials = string
    project     = string
    region      = string
    zone        = string
  })
}

variable "tfe" {
  description = "Attributes of the Terraform Enterprise instance which manages the base infrastructure."
  type = object({
    hostname     = string
    organization = string
    token        = string
    workspace    = string
  })
}
