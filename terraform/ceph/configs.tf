# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

module "ceph_mon_config" {
  source   = "../manifest/"
  manifest = var.manifest_yaml
  charm    = "ceph-mon"
}

module "ceph_osd_config" {
  source   = "../manifest/"
  manifest = var.manifest_yaml
  charm    = "ceph-osd"
}

module "ceph_csi_config" {
  source   = "../manifest/"
  manifest = var.manifest_yaml
  charm    = "ceph-csi"
}
