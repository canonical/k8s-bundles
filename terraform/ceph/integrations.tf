# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_integration" "ceph_client" {
  model = var.model
  application {
    name      = module.ceph_mon.app_name
    endpoint  = module.ceph_mon.provides.client
  }
  application {
    name      = module.ceph_csi.app_name
    endpoint  = module.ceph_csi.requires.ceph_client
  }
}

resource "juju_integration" "ceph_mon" {
  model = var.model
  application {
    name      = module.ceph_mon.app_name
    endpoint  = module.ceph_mon.provides.osd
  }
  application {
    name      = module.ceph_osd.app_name
    endpoint  = module.ceph_osd.requires.mon
  }
}

resource "juju_integration" "ceph_k8s_info" {
  model = var.model
  application {
    name      = var.k8s.app_name
    endpoint  = var.k8s.provides.ceph_k8s_info
  }
  application {
    name      = module.ceph_csi.app_name
    endpoint  = module.ceph_csi.requires.kubernetes_info
  }
}
