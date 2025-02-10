# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

module "microceph_config" {
  source = "git::https://github.com/canonical/k8s-bundles//terraform/manifest?ref=main"
  manifest = var.manifest_yaml
  app = "ceph_csi"
}

module "ceph_csi_config" {
  source = "git::https://github.com/canonical/k8s-bundles//terraform/manifest?ref=main"
  manifest = var.manifest_yaml
  app = "ceph_csi"
}
