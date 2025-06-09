# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

locals {
  full_map = yamldecode(file("${var.manifest}"))
  default_config = {
    base        = null
    channel     = null
    config      = null
    constraints = null
    resources   = null
    revision    = null
    units       = null
    storage     = null
    expose      = null
  }
  yaml_data = {
    for app, obj in local.full_map : app => merge({app_name = app}, local.default_config, obj)
    if (
      obj != null &&
      (app == var.charm || lookup(obj, "charm", null) == var.charm) &&
      (lookup(obj, "units", null) != 0)
    )
  }
}
