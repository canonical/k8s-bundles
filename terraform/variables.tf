# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

variable "manifest_yaml" {
  description = "Absolute path to the manifest yaml file for the charm configurations."
  type        = string
}

variable "cloud_integration" {
  description = "Selection of a cloud integration."
  type        = string
  default     = ""
  nullable    = false

  validation {
    condition = can(regex("^(|openstack|aws)$", var.cloud_integration))
    error_message = "Cloud integration unsupported. Try: '', 'aws', or 'openstack'"
  }
}

variable "csi_integration" {
  description = "Selection of a csi integration"
  type        = list(string)
  default     = []
  nullable    = false

  validation {
    condition = alltrue([
      for v in var.csi_integration : can(regex("^(|ceph)$", v))
    ])
    error_message = "Each item in 'csi_integration' must be either '' or 'ceph'."
  }
}

variable "model" {
  description = <<EOT
Juju Model resource definition.

Schema represented by the juju model resource:
  - name: Name of the model
  - cloud: Cloud name
  - region: Region name (optional)
  - config: Configuration map (optional)
  - constraints: Constraints string (optional)
  - credential: Credential name (optional)

https://registry.terraform.io/providers/juju/juju/0.16.0/docs/resources/model
EOT

  type        = object({
    name         = string
    cloud        = string
    region       = optional(string)
    config       = optional(map(any))
    constraints  = optional(string)
    credential   = optional(string)
  })

  validation {
    condition = (
      var.model.config == null || alltrue([
        for k, v in var.model.config != null ? var.model.config : {}:
        v == null || can(tostring(v)) || can(tonumber(v)) || can(tobool(v))
      ])
    )
    error_message = "Config must be a map where values are only strings, numbers, or bools."
  }
}
