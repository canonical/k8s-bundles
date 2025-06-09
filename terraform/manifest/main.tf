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
        !contains(keys(obj), "expose") || obj.expose == null ? null :

        # if the expose data is utterly empty, return null
        length([
          for k in local._allowed_exposed :
          k if contains(keys(obj.expose), k) && obj.expose[k] != null
        ]) == 0 ? null :

        # Filter the expose data to only include allowed keys
        # and ensure that no null values are included
        {
          for k, v in obj.expose : k => v
          if contains(local._allowed_exposed, k) && v != null
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
