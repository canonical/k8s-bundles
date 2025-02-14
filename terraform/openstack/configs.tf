# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

module "openstack_integrator_config" {
  source = "../manifest"
  manifest = var.manifest_yaml
  app = "openstack_integrator"
}

module "cinder_csi_config" {
  source = "../manifest"
  manifest = var.manifest_yaml
  app = "cinder_csi"
}

module "openstack_cloud_controller_config" {
  source = "../manifest"
  manifest = var.manifest_yaml
  app = "openstack_cloud_controller"
}
