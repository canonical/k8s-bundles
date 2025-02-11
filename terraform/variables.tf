# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

variable "manifest_yaml" {
  description = "Absolute path to the manifest yaml file for the charm configurations."
  type        = string
}

variable "model" {
  description = "Name of the Juju model to deploy to."
  type        = string
}

variable "cloud_integration" {
  description = "Selection of a cloud integration"
  type        = string
  default     = ""

  validation {
    condition     = contains(["", "openstack"], var.cloud_integration)
    error_message = "Cloud must be one of '', or 'openstack'"
  }
}
