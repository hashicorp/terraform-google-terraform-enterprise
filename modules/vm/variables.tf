variable "active_active" {
  description = "A toggle which controls support for deploying Terraform Enterprise in Active/Active mode."
  type        = bool
}
variable "disk_source_image" {
  description = "The self link of the source image which will be used to provision the disks of the compute instances."
  type        = string
}

variable "namespace" {
  description = "A prefix which will be applied to all resource names."
  type        = string
}

variable "machine_type" {
  description = "The type of compute instances which will be created."
  type        = string
}

variable "disk_size" {
  description = <<-EOD
  The size of the disks to be attached to the compute instances. The value must be expressed in gigabytes.
  EOD
  type        = number
}

variable "disk_type" {
  description = "The type of disks that will be attached to the compute instances."
  type        = string
}

variable "subnetwork" {
  description = "The self link of the subnetwork to which the compute instances will be attached."
  type        = string
}

variable "metadata_startup_script" {
  description = "The startup script which will be executed by the compute instances."
  type        = string
}

variable "labels" {
  description = "Labels which will be attached to all applicable resources."
  type        = map(string)
}

variable "auto_healing_enabled" {
  description = "A toggle to control the automatic healing of the compute instance group."
  type        = bool
}

variable "service_account" {
  description = "The email address of the service account which will be assigned to the compute instances."
  type        = string
}

variable "node_count" {
  description = "The number of compute instances to create."
  type        = number
}
