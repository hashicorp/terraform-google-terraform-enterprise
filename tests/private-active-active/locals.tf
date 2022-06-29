locals {
  name                        = "${random_pet.main.id}-proxy"
  existing_service_account_id = try(var.google.service_account, var.existing_service_account_id)
  labels = {
    oktodelete  = "true"
    terraform   = "true"
    department  = "engineering"
    product     = "terraform-enterprise"
    repository  = "terraform-google-terraform-enterprise"
    description = "private-active-active"
    environment = "test"
    team        = "tf-on-prem"
  }
}
