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
  }

  _allowed_exposed = ["cidrs", "endpoints", "spaces"]
  exposed = {
    for app, obj in local.full_map : app => {
      expose = (
        # if the expose data is not present, return null
        !contains(keys(obj), "expose") || obj.expose == null
          ? null
          : {
            for k, v in obj.expose : k => v
            if contains(local._allowed_exposed, k)
          }
      )
    }
  }
  yaml_data = {
    for app, obj in local.full_map : app => merge(
      {app_name = app},
      local.default_config,
      obj,
      local.exposed[app]
    )
    if (
      obj != null &&
      (app == var.charm || lookup(obj, "charm", null) == var.charm) &&
      (lookup(obj, "units", null) != 0)
    )
  }
}
