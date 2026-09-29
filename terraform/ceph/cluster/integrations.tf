# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_integration" "ceph_client" {
  model_uuid = var.model_uuid
  application {
    name     = module.ceph_mon.application.name
    endpoint = module.ceph_mon.provides.client
  }
  application {
    name     = module.ceph_csi.app_name
    endpoint = module.ceph_csi.requires.ceph_client
  }
}

resource "juju_integration" "ceph_mon" {
  model_uuid = var.model_uuid
  for_each = module.ceph_osd
  application {
    name     = module.ceph_mon.application.name
    endpoint = module.ceph_mon.provides.osd
  }
  application {
    name     = each.value.application.name
    endpoint = each.value.requires.mon
  }
}

resource "juju_integration" "ceph_k8s_info" {
  model_uuid = var.model_uuid
  application {
    name     = var.k8s.app_name
    endpoint = var.k8s.provides.ceph_k8s_info
  }
  application {
    name     = module.ceph_csi.app_name
    endpoint = module.ceph_csi.requires.kubernetes_info
  }
}
