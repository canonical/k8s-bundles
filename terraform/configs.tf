# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

module "k8s_config" {
  source = "git::https://github.com/asbalderson/k8s-bundles//terraform/manifest?ref=terraform-bundle-basic"
  manifest = var.manifest_yaml
  app = "k8s"
}

module "k8s_worker_config" {
  source = "git::https://github.com/asbalderson/k8s-bundles//terraform/manifest?ref=terraform-bundle-basic"
  manifest = var.manifest_yaml
  app = "k8s_worker"
}
