# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

module "ceph_mon_config" {
  source = "git::https://github.com/canonical/k8s-bundles//terraform/manifest?ref=main"
  manifest = var.manifest_yaml
  app = "ceph_mon"
}

module "ceph_osd_config" {
  source = "git::https://github.com/canonical/k8s-bundles//terraform/manifest?ref=main"
  manifest = var.manifest_yaml
  app = "ceph_osd"
}

module "ceph_csi_config" {
  source = "git::https://github.com/canonical/k8s-bundles//terraform/manifest?ref=main"
  manifest = var.manifest_yaml
  app = "ceph_csi"
}
