# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.


locals {
  cluster_keys = toset([for app, obj in module.ceph_mon_config.config: obj.cluster-name])
  clusters = {for key in local.cluster_keys: key => {
    mons   = {for mon, obj in module.ceph_mon_config.config: mon => obj if obj.cluster-name == key}
    osds   = {for osd, obj in module.ceph_osd_config.config: osd => obj if obj.cluster-name == key}
    csis   = {for csi, obj in module.ceph_csi_config.config: csi => obj if obj.cluster-name == key}
  }}
}

module "ceph-cluster" {
  source = "./cluster/"
  for_each = local.clusters

  name = each.key
  mons = each.value.mons
  osds = each.value.osds
  csis = each.value.csis
  model = var.model
  k8s = var.k8s
}

output "debug" {
  value = {
    cluster_keys = local.cluster_keys
    clusters = local.clusters
  }
}
