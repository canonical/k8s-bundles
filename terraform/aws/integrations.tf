# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_integration" "aws_storage_client" {
  model = var.model
  application {
    name      = module.aws_integrator.app_name
    endpoint  = module.aws_integrator.provides.aws
  }
  application {
    name      = module.aws_k8s_storage.app_name
    endpoint  = module.aws_k8s_storage.requires.aws_integration
  }
}

resource "juju_integration" "cloud_controller_aws_integrator" {
  model = var.model
  application {
    name      = module.aws_integrator.app_name
    endpoint  = module.aws_integrator.provides.aws
  }
  application {
    name      = module.aws_cloud_provider.app_name
    endpoint  = module.aws_cloud_provider.requires.aws_integration
  }
}

resource "juju_integration" "external_cloud_provider" {
  model = var.model
  application {
    name      = var.k8s.app_name
    endpoint  = var.k8s.requires.external_cloud_provider
  }
  application {
    name      = module.aws_cloud_provider.app_name
    endpoint  = module.aws_cloud_provider.provides.external_cloud_provider
  }
}

resource "juju_integration" "aws_integration_control_plane" {
  model = var.model
  application {
    name      = module.aws_integrator.app_name
    endpoint  = module.aws_integrator.provides.aws
  }
  application {
    name      = var.k8s.app_name
    endpoint  = var.k8s.requires.aws
  }
}

resource "juju_integration" "aws_integration_worker" {
  model = var.model
  for_each = var.k8s_worker
  application {
    name      = module.aws_integrator.app_name
    endpoint  = module.aws_integrator.provides.aws
  }
  application {
    name      = each.value.app_name
    endpoint  = each.value.requires.aws
  }
}

resource "juju_integration" "aws_cloud_provider_kube_control" {
  model = var.model
  application {
    name      = var.k8s.app_name
    endpoint  = var.k8s.provides.kube_control
  }
  application {
    name      = module.aws_cloud_provider.app_name
    endpoint  = module.aws_cloud_provider.requires.kube_control
  }
}

resource "juju_integration" "aws_k8s_storage_kube_control" {
  model = var.model
  application {
    name      = var.k8s.app_name
    endpoint  = var.k8s.provides.kube_control
  }
  application {
    name      = module.aws_k8s_storage.app_name
    endpoint  = module.aws_k8s_storage.requires.kube_control
  }
}
