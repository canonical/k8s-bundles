# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

module "openstack_integrator" {
  source      = "git::https://github.com/charmed-kubernetes/charm-openstack-integrator//terraform?ref=release_1.32"

  model       = var.model
  app_name    = module.openstack_integrator_config.config.app_name
  base        = coalesce(module.openstack_integrator_config.config.base, var.k8s.base)
  constraints = coalesce(module.openstack_integrator_config.config.constraints, var.k8s.constraints)
  channel     = coalesce(module.openstack_integrator_config.config.channel, var.k8s.channel)

  config      = coalesce(module.openstack_integrator_config.config.config, {})
  resources   = module.openstack_integrator_config.config.resources
  revision    = module.openstack_integrator_config.config.revision
  units       = module.openstack_integrator_config.config.units
}

module "cinder_csi" {
  source      = "git::https://github.com/charmed-kubernetes/cinder-csi-operator//terraform?ref=release_1.32"

  model       = var.model
  app_name    = module.cinder_csi_config.config.app_name
  base        = coalesce(module.cinder_csi_config.config.base,        module.openstack_integrator_config.config.base,        var.k8s.base)
  channel     = coalesce(module.cinder_csi_config.config.channel,     module.openstack_integrator_config.config.channel,     var.k8s.channel)

  config      = coalesce(module.cinder_csi_config.config.config, {})
  revision    = module.cinder_csi_config.config.revision
}

module "openstack_cloud_controller" {
  source      = "git::https://github.com/charmed-kubernetes/openstack-cloud-controller-operator//terraform?ref=release_1.32"

  model       = var.model
  app_name    = module.openstack_cloud_controller_config.config.app_name
  base        = coalesce(module.openstack_cloud_controller_config.config.base,        module.openstack_integrator_config.config.base,        var.k8s.base)
  channel     = coalesce(module.openstack_cloud_controller_config.config.channel,     module.openstack_integrator_config.config.channel,     var.k8s.channel)

  config      = coalesce(module.openstack_cloud_controller_config.config.config, {})
  revision    = module.openstack_cloud_controller_config.config.revision
}
