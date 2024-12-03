# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

output "config" {
  value = {
    app_name    = lookup(locals.yaml_data, "app_name", null)
    channel     = lookup(locals.yaml_data, "channel". null)
    config      = lookup(locals.yaml_data, "config", null)
    constraints = lookup(locals.yaml_data, "constraints", null)
    resources   = lookup(locals.yaml_data, "resoruces", null)
    revision    = lookup(locals.yaml_data, "revision", null)
    series      = lookup(locals.yaml_data, "series", null)
    units       = lookup(locals.yaml_data, "units", null)
  }
}
