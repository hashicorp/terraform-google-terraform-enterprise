locals {
  http_proxy_account = "serviceAccount:${google_service_account.http_proxy.email}"
  http_proxy_port    = "3128"
  name               = "${random_pet.main.id}-proxy"

  labels = {
    oktodelete  = "true"
    terraform   = "true"
    department  = "engineering"
    product     = "terraform-enterprise"
    repository  = "terraform-google-terraform-enterprise"
    description = "private-tcp-active-active"
    environment = "test"
    team        = "tf-on-prem"
  }
}
