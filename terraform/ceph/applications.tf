# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

module "ceph_mon" {
  source = "./ceph_mon"

  model       = var.model
  base        = coalesce(module.ceph_mon_config.config.base, var.k8s.config.base)
  constraints = coalesce(module.ceph_mon_config.config.constraints, var.k8s.config.constraints)
  channel     = coalesce(module.ceph_mon_config.config.channel, var.k8s.config.channel)

  config    = coalesce(module.ceph_mon_config.config.config, {})
  resources = module.ceph_mon_config.config.resources
  revision  = module.ceph_mon_config.config.revision
  units     = module.ceph_mon_config.config.units
}

module "ceph_osd" {
  source = "./ceph_osd"

  model       = var.model
  base        = coalesce(module.ceph_osd_config.config.base, var.k8s.config.base)
  constraints = coalesce(module.ceph_osd_config.config.constraints, var.k8s.config.constraints)
  channel     = coalesce(module.ceph_osd_config.config.channel, var.k8s.config.channel)

  config    = coalesce(module.ceph_osd_config.config.config, {})
  resources = module.ceph_osd_config.config.resources
  storage   = module.ceph_osd_config.config.storage
  revision  = module.ceph_osd_config.config.revision
  units     = module.ceph_osd_config.config.units
}

module "ceph_csi" {
  source = "git::https://github.com/charmed-kubernetes/ceph-csi-operator//terraform?ref=main"

  model    = var.model
  app_name = module.ceph_csi_config.config.app_name
  base     = module.ceph_csi_config.config.base
  channel  = coalesce(module.ceph_csi_config.config.channel, var.k8s.config.channel)

  config      = coalesce(module.ceph_csi_config.config.config, {})
  revision    = module.ceph_csi_config.config.revision
  constraints = module.ceph_csi_config.config.constraints
}
