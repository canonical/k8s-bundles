# Copyright 2025 Canonical Ltd.
#
# See LICENSE file for licensing details.

locals {
  _etcd_keys     = keys(module.charmed_etcd_config.config)
  _max_key_count = length(local._etcd_keys)

  etcd_config = local._max_key_count == 1 ? module.charmed_etcd_config.config[local._etcd_keys[0]] : null
}

resource "null_resource" "validate_all_apps_unique" {
  count = local._max_key_count == 1 ? 0 : 1

  provisioner "local-exec" {
    command = <<EOT
      >&2 echo "ERROR: Expected exactly 1 entry for each application"
      >&2 echo "  charmed-etcd: ${local._etcd_keys}"
      exit 1
    EOT
  }
}

output "debug" {
  value = {
    etcd_config = local.etcd_config
  }
}

module "charmed_etcd" {
  source = "git::https://github.com/canonical/charmed-etcd-operator//terraform/charm?ref=3.6/edge"

  model       = var.model
  app_name    = local.etcd_config.app_name
  base        = coalesce(local.etcd_config.base, var.k8s.base)
  constraints = coalesce(local.etcd_config.constraints, var.k8s.constraints)
  channel     = coalesce(local.etcd_config.channel, var.k8s.channel)

  config   = coalesce(local.etcd_config.config, {})
  revision = local.etcd_config.revision
  units    = local.etcd_config.units
  tls      = true
}
