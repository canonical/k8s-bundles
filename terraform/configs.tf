# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

module "k8s_config" {
  source = "git::https://github.com/canonical/k8s-bundles//terraform/manifest?ref=main"
  manifest = var.manifest_yaml
  charm = "k8s"
}

module "k8s_worker_config" {
  source = "git::https://github.com/canonical/k8s-bundles//terraform/manifest?ref=main"
  manifest = var.manifest_yaml
  charm = "k8s_worker"
}
