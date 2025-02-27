# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

module "k8s_config" {
  source = "./manifest/"
  manifest = var.manifest_yaml
  app = "k8s"
}

module "k8s_worker_config" {
  source = "./manifest/"
  manifest = var.manifest_yaml
  app = "k8s_worker"
}
