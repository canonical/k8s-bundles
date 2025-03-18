# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

module "aws_integrator_config" {
  source = "../manifest/"
  manifest = var.manifest_yaml
  charm = "aws-integrator"
}

module "aws_k8s_storage_config" {
  source = "../manifest/"
  manifest = var.manifest_yaml
  charm = "aws-k8s-storage"
}

module "aws_cloud_provider_config" {
  source = "../manifest/"
  manifest = var.manifest_yaml
  charm = "aws-cloud-provider"
}
