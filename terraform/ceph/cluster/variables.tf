# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

variable "name" {
  description = "Unique id of the Ceph Cluster."
  type        = string
}

variable "mons" {
  description = "Map of Ceph Mon Applications."
  type = map
}

variable "osds" {
  description = "Map of Ceph OSD Applications."
  type = map
}

variable "csis" {
  description = "Map of Ceph CSI Applications."
  type = map
}

variable "model" {
  description = "Name of the Juju model to deploy to."
  type        = string
}

variable "k8s" {
  description = "K8s application object"
  type = object({
    app_name    = string
    base        = string
    constraints = string
    channel     = string
    provides    = map(string)
    requires    = map(string)
  })
}
