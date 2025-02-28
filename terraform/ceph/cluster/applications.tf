
locals {
  mon_config_keys = keys(var.mons)
  has_single_mon_config = length(local.mon_config_keys) == 1
  mon_config = local.has_single_mon_config ? var.mons[local.mon_config_keys[0]] : null

  csi_config_keys = keys(var.csis)
  has_single_csi_config = length(local.csi_config_keys) == 1
  csi_config = local.has_single_csi_config ? var.csis[local.csi_config_keys[0]] : null
}

resource "null_resource" "validate_unique_k8s" {
  count = local.has_single_mon_config ? 0 : 1

  provisioner "local-exec" {
    command = <<EOT
      >&2 echo "ERROR: Expected exactly 1 mon application for ${var.name}, but got ${local.mon_config_keys}"
      exit 1
    EOT
  }
}


module "ceph_mon" {
  source      = "git::https://github.com/canonical/ceph-charms//ceph-mon/terraform?ref=main"
  model       = var.model
  app_name    = local.mon_config.app_name
  base        = coalesce(local.mon_config.base, var.k8s.config.base)
  constraints = coalesce(local.mon_config.constraints, var.k8s.config.constraints)
  channel     = coalesce(local.mon_config.channel, var.k8s.config.channel)

  config    = coalesce(local.mon_config.config, {})
  resources = local.mon_config.resources
  revision  = local.mon_config.revision
  units     = local.mon_config.units
}

module "ceph_osd" {
  source = "git::https://github.com/canonical/ceph-charms//ceph-osd/terraform?ref=main"
  for_each    = var.osds

  model       = var.model
  app_name    = each.value.app_name
  base        = coalesce(each.value.base, var.k8s.config.base)
  constraints = coalesce(each.value.constraints, var.k8s.config.constraints)
  channel     = coalesce(each.value.channel, var.k8s.config.channel)

  config    = coalesce(each.value.config, {})
  resources = each.value.resources
  storage   = coalesce(each.value.storage, {})
  revision  = each.value.revision
  units     = each.value.units
}

module "ceph_csi" {
  source = "git::https://github.com/charmed-kubernetes/ceph-csi-operator//terraform?ref=main"
  model    = var.model
  app_name = local.csi_config.app_name
  base     = local.csi_config.base
  constraints = local.csi_config.constraints
  channel  = coalesce(local.csi_config.channel, var.k8s.config.channel)

  config      = coalesce(local.csi_config.config, {})
  revision    = local.csi_config.revision
}
