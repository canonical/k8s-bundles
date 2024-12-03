# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

output "config" {
  value = {
    app_name    = lookup(local.yaml_data, "app_name", null)
    channel     = lookup(local.yaml_data, "channel". null)
    config      = lookup(local.yaml_data, "config", null)
    constraints = lookup(local.yaml_data, "constraints", null)
    resources   = lookup(local.yaml_data, "resoruces", null)
    revision    = lookup(local.yaml_data, "revision", null)
    series      = lookup(local.yaml_data, "series", null)
    units       = lookup(local.yaml_data, "units", null)
  }
}
