# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_integration" "cinder_openstack_client" {
  model = var.model
  application {
    name     = module.openstack_integrator.app_name
    endpoint = module.openstack_integrator.provides.clients
  }
  application {
    name     = module.cinder_csi.app_name
    endpoint = module.cinder_csi.requires.openstack
  }
}

resource "juju_integration" "cloud_controller_openstack_client" {
  model = var.model
  application {
    name     = module.openstack_integrator.app_name
    endpoint = module.openstack_integrator.provides.clients
  }
  application {
    name     = module.openstack_cloud_controller.app_name
    endpoint = module.openstack_cloud_controller.requires.openstack
  }
}

resource "juju_integration" "external_cloud_provider" {
  model = var.model
  application {
    name     = var.k8s.app_name
    endpoint = var.k8s.requires.external_cloud_provider
  }
  application {
    name     = module.openstack_cloud_controller.app_name
    endpoint = module.openstack_cloud_controller.provides.external_cloud_provider
  }
}

resource "juju_integration" "cloud_controller_kube_control" {
  model = var.model
  application {
    name     = var.k8s.app_name
    endpoint = var.k8s.provides.kube_control
  }
  application {
    name     = module.openstack_cloud_controller.app_name
    endpoint = module.openstack_cloud_controller.requires.kube_control
  }
}

resource "juju_integration" "cinder_csi_kube_control" {
  model = var.model
  application {
    name     = var.k8s.app_name
    endpoint = var.k8s.provides.kube_control
  }
  application {
    name     = module.cinder_csi.app_name
    endpoint = module.cinder_csi.requires.kube_control
  }
}

resource "juju_integration" "openstack_external_load_balancer" {
  model = var.model
  application {
    name     = var.k8s.app_name
    endpoint = var.k8s.requires.external_load_balancer
  }
  application {
    name     = module.openstack_integrator.app_name
    endpoint = module.openstack_integrator.provides.lb_consumers
  }
}

# manila-csi + csi-driver-nfs integrations — only created when csi_integration includes "manila"

locals {
  # Empty map when manila is disabled; prevents for_each from iterating when unused
  _manila_workers = local._manila_enabled ? var.k8s_worker : {}
}

resource "juju_integration" "csi_driver_nfs_kube_control" {
  count = local._manila_enabled ? 1 : 0
  model = var.model
  application {
    name     = var.k8s.app_name
    endpoint = var.k8s.provides.kube_control
  }
  application {
    name     = one(module.csi_driver_nfs[*]).app_name
    endpoint = one(module.csi_driver_nfs[*]).requires.kube_control
  }
}

resource "juju_integration" "csi_driver_nfs_juju_info" {
  for_each = local._manila_workers
  model    = var.model
  application {
    name     = each.value.app_name
    # juju-info is an implicit Juju relation not exposed in the k8s-worker module outputs
    endpoint = "juju-info"
  }
  application {
    name     = one(module.csi_driver_nfs[*]).app_name
    endpoint = one(module.csi_driver_nfs[*]).requires.juju_info
  }
}

resource "juju_integration" "manila_csi_kube_control" {
  count = local._manila_enabled ? 1 : 0
  model = var.model
  application {
    name     = var.k8s.app_name
    endpoint = var.k8s.provides.kube_control
  }
  application {
    name     = one(module.manila_csi[*]).app_name
    endpoint = one(module.manila_csi[*]).requires.kube_control
  }
}

resource "juju_integration" "manila_csi_juju_info" {
  for_each = local._manila_workers
  model    = var.model
  application {
    name     = each.value.app_name
    # juju-info is an implicit Juju relation not exposed in the k8s-worker module outputs
    endpoint = "juju-info"
  }
  application {
    name     = one(module.manila_csi[*]).app_name
    endpoint = one(module.manila_csi[*]).requires.juju_info
  }
}

resource "juju_integration" "manila_csi_openstack" {
  count = local._manila_enabled ? 1 : 0
  model = var.model
  application {
    name     = module.openstack_integrator.app_name
    endpoint = module.openstack_integrator.provides.clients
  }
  application {
    name     = one(module.manila_csi[*]).app_name
    endpoint = one(module.manila_csi[*]).requires.openstack
  }
}

