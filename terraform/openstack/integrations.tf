# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_integration" "cinder_openstack_client" {
  model = var.model
  application {
    name      = module.openstack_integrator.app_name
    endpoint  = module.openstack_integrator.provides.clients
  }
  application {
    name      = module.cinder_csi.app_name
    endpoint  = module.cinder_csi.requires.openstack
  }
}

resource "juju_integration" "cloud_controller_openstack_client" {
  model = var.model
  application {
    name      = module.openstack_integrator.app_name
    endpoint  = module.openstack_integrator.provides.clients
  }
  application {
    name      = module.openstack_cloud_controller.app_name
    endpoint  = module.openstack_cloud_controller.requires.openstack
  }
}

resource "juju_integration" "external_cloud_provider" {
  model = var.model
  application {
    name      = var.k8s.app_name
    endpoint  = var.k8s.requires.external_cloud_provider
  }
  application {
    name      = module.openstack_cloud_controller.app_name
    endpoint  = module.openstack_cloud_controller.provides.external_cloud_provider
  }
}

resource "juju_integration" "cloud_controller_kube_control" {
  model = var.model
  application {
    name      = var.k8s.app_name
    endpoint  = var.k8s.provides.kube_control
  }
  application {
    name      = module.openstack_cloud_controller.app_name
    endpoint  = module.openstack_cloud_controller.requires.kube_control
  }
}

resource "juju_integration" "cinder_csi_kube_control" {
  model = var.model
  application {
    name      = var.k8s.app_name
    endpoint  = var.k8s.provides.kube_control
  }
  application {
    name      = module.cinder_csi.app_name
    endpoint  = module.cinder_csi.requires.kube_control
  }
}

resource "juju_integration" "openstack_external_load_balancer" {
  model = var.model
  application {
    name      = var.k8s.app_name
    endpoint  = var.k8s.requires.external_load_balancer
  }
  application {
    name      = module.openstack_integrator.app_name
    endpoint  = module.openstack_integrator.provides.lb_consumers
  }
}
