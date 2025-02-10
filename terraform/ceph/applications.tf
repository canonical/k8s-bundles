# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

module "microceph" {
  source      = "./microceph"

  model       = var.model
  base        = coalesce(module.microceph_config.config.base, var.k8s.config.base)
  constraints = coalesce(module.microceph_config.config.constraints, var.k8s.config.constraints)
  channel     = coalesce(module.microceph_config.config.channel, var.k8s.config.channel)

  config      = coalesce(module.microceph_config.config.config, {})
  resources   = module.microceph_config.config.resources
  revision    = module.microceph_config.config.revision
  units       = module.microceph_config.config.units
}

module "ceph_csi" {
  source      = "git::https://github.com/charmed-kubernetes/ceph-csi-operator//terraform?ref=main"

  model       = var.model
  app_name    = module.ceph_csi_config.config.app_name
  base        = coalesce(module.ceph_csi_config.config.base, var.k8s.config.base)
  channel     = coalesce(module.ceph_csi_config.config.channel, var.k8s.config.channel)

  config      = coalesce(module.ceph_csi_config.config.config, {})
  revision    = module.ceph_csi_config.config.revision
  constraints = module.ceph_csi_config.config.constraints
}
