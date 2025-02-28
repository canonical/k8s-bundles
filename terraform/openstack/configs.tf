# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

module "openstack_integrator_config" {
  source = "../manifest/"
  manifest = var.manifest_yaml
  charm = "openstack-integrator"
}

module "cinder_csi_config" {
  source = "../manifest/"
  manifest = var.manifest_yaml
  charm = "cinder-csi"
}

module "openstack_cloud_controller_config" {
  source = "../manifest"
  manifest = var.manifest_yaml
  charm = "openstack-cloud-controller"
}
