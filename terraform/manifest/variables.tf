# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

variable "manifest" {
  description = "Absolute path to a yaml file with config for a Juju application."
  type        = string
}

variable "charm" {
  description = "Name of the charm to load configs for."
  type        = string
}
