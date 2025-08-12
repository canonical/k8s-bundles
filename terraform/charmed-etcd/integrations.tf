# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_integration" "etcd_client" {
  model = var.model
  application {
    name     = module.charmed_etcd.app_names.etcd
    endpoint = "etcd-client"
  }
  application {
    name     = var.k8s.app_name
    endpoint = var.k8s.requires.etcd_client
  }
}

resource "juju_integration" "etcd_certificates" {
  model = var.model
  application {
    name     = module.charmed_etcd.app_names.self-signed-certificates
    endpoint = "certificates"
  }
  application {
    name     = var.k8s.app_name
    endpoint = var.k8s.requires.etcd_certificates
  }
}
