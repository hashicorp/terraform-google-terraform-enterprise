locals {
  is_airgap = var.airgap_package_url != ""
}

data "template_file" "replicated_config" {
  template = file("${path.module}/templates/replicated/replicated.conf")

  vars = {
    airgap           = local.is_airgap
    proxy_url        = var.http_proxy_url
    console_password = random_pet.console_password.id
    release_sequence = var.release_sequence
  }
}
