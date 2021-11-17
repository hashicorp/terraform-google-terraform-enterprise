variable "iact_subnet_list" {
  default     = []
  description = <<-EOD
  A list of IP address ranges which will be authorized to access the IACT. The ranges must be expressed
  in CIDR notation.
  EOD
  type        = list(string)
}

variable "tfe_organization" {
  description = "The name of the TFE organization which contains the base workspace."
  type        = string
}

variable "tfe_workspace" {
  description = "The name of the TFE workspace which contains the base state."
  type        = string
}
