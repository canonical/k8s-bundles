# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

module "ceph_mon_config" {
  source   = "../manifest/"
  manifest = var.manifest_yaml
  app      = "ceph_mon-${var.index}"
}

module "ceph_osd_config" {
  source   = "../manifest/"
  manifest = var.manifest_yaml
  app      = "ceph_osd-${var.index}"
}

module "ceph_csi_config" {
  source   = "../manifest/"
  manifest = var.manifest_yaml
  app      = "ceph_csi-${var.index}"
}
