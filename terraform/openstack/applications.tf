# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

locals {
  _integrator_keys       = keys(module.openstack_integrator_config.config)
  _cinder_keys           = keys(module.cinder_csi_config.config)
  _cloud_controller_keys = keys(module.openstack_cloud_controller_config.config)
  _max_key_count         = max(length(local._integrator_keys), length(local._cinder_keys), length(local._cloud_controller_keys))

  integrator_config = local._max_key_count == 1 ? module.openstack_integrator_config.config[local._integrator_keys[0]] : null
  cinder_csi_config = local._max_key_count == 1 ? module.cinder_csi_config.config[local._cinder_keys[0]] : null
  cloud_controller_config = local._max_key_count == 1 ? module.openstack_cloud_controller_config.config[local._cloud_controller_keys[0]] : null
}

resource "null_resource" "validate_all_apps_unique" {
  count = local._max_key_count == 1 ? 0 : 1

  provisioner "local-exec" {
    command = <<EOT
      >&2 echo "ERROR: Expected exactly 1 entry for each application"
      >&2 echo "  openstack-integrator: ${local._integrator_keys}"
      >&2 echo "  cinder-csi: ${local._cinder_keys}"
      >&2 echo "  openstack-cloud-controller: ${local._cloud_controller_keys}"
      exit 1
    EOT
  }
}

output "debug" {
  value = {
    integrator_config = local.integrator_config
    cinder_csi_config = local.cinder_csi_config
    cloud_controller_config = local.cloud_controller_config
  }
}

module "openstack_integrator" {
  source      = "git::https://github.com/charmed-kubernetes/charm-openstack-integrator//terraform?ref=main"

  model       = var.model
  app_name    = local.integrator_config.app_name
  base        = coalesce(local.integrator_config.base, var.k8s.base)
  constraints = coalesce(local.integrator_config.constraints, var.k8s.constraints)
  channel     = coalesce(local.integrator_config.channel, var.k8s.channel)

  config      = coalesce(local.integrator_config.config, {})
  resources   = local.integrator_config.resources
  revision    = local.integrator_config.revision
  units       = local.integrator_config.units
}

module "cinder_csi" {
  source      = "git::https://github.com/canonical/cinder-csi-operator//terraform?ref=main"

  model       = var.model
  app_name    = local.cinder_csi_config.app_name
  base        = coalesce(
    local.cinder_csi_config.base,
    local.integrator_config.base,
    var.k8s.base
  )
  channel     = coalesce(
    local.cinder_csi_config.channel,
    local.integrator_config.channel,
    var.k8s.channel
  )
  config      = coalesce(local.cinder_csi_config.config, {})
  revision    = local.cinder_csi_config.revision
}

module "openstack_cloud_controller" {
  source      = "git::https://github.com/charmed-kubernetes/openstack-cloud-controller-operator//terraform?ref=main"

  model       = var.model
  app_name    = local.cloud_controller_config.app_name
  base        = coalesce(
    local.cloud_controller_config.base,
    local.integrator_config.base,
    var.k8s.base
  )
  channel     = coalesce(
    local.cloud_controller_config.channel,
    local.integrator_config.channel,
    var.k8s.channel
  )
  config      = coalesce(local.cloud_controller_config.config, {})
  revision    = local.cloud_controller_config.revision
}
