# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

module "charmed_etcd_config" {
  source   = "../manifest/"
  manifest = var.manifest_yaml
  charm    = "charmed-etcd"
}

