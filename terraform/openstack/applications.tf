# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

module "openstack_integrator" {
  source      = "git::https://github.com/charmed-kubernetes/charm-openstack-integrator//terraform?ref=KU-2412/adding-terraform-modules"
  app_name    = module.openstack_integrator_config.config.app_name
  channel     = module.openstack_integrator_config.config.channel
  constraints = module.openstack_integrator_config.config.constraints 
  model       = var.model
  resources   = module.openstack_integrator_config.config.resources
  revision    = module.openstack_integrator_config.config.revision
  base        = module.openstack_integrator_config.config.base
  units       = module.openstack_integrator_config.config.units
}

module "cinder_csi" {
  source      = "git::https://github.com/canonical/cinder-csi-operator//terraform?ref=KU-2415/adding-terraform-modules"
  app_name    = module.cinder_csi_config.config.app_name
  constraints = module.cinder_csi_config.config.constraints
  model       = var.model
  revision    = module.cinder_csi_config.config.revision
  channel     = coalesce(module.cinder_csi_config.config.channel, module.openstack_integrator_config.config.channel)
  base        = coalesce(module.cinder_csi_config.config.base, module.openstack_integrator_config.config.base)
}

module "openstack_cloud_controller" {
  source      = "git::https://github.com/charmed-kubernetes/openstack-cloud-controller-operator//terraform?ref=KU-2413/adding-terraform-modules"
  app_name    = module.openstack_cloud_controller_config.config.app_name
  constraints = module.openstack_cloud_controller_config.config.constraints
  model       = var.model
  revision    = module.openstack_cloud_controller_config.config.revision
  channel     = coalesce(module.openstack_cloud_controller_config.config.channel, module.openstack_integrator_config.config.channel)
  base        = coalesce(module.openstack_cloud_controller_config.config.base, module.openstack_integrator_config.config.base)
}
