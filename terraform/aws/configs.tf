# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

module "aws_integrator_config" {
  source = "git::https://github.com/asbalderson/k8s-bundles//terraform/manifest?ref=terraform-bundle-basic"
  manifest = var.manifest_yaml
  app = "aws_integrator"
}

module "aws_k8s_storage_config" {
  source = "git::https://github.com/asbalderson/k8s-bundles//terraform/manifest?ref=terraform-bundle-basic"
  manifest = var.manifest_yaml
  app = "aws_k8s_storage"
}

module "aws_cloud_provider_config" {
  source = "git::https://github.com/asbalderson/k8s-bundles//terraform/manifest?ref=terraform-bundle-basic"
  manifest = var.manifest_yaml
  app = "aws_cloud_provider"
}
