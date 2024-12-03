# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_integration" "k8s_cluster_integration" {
  model = var.model
  application {
    name      = module.k8s.app_name
    endpoint  = module.k8s.outputs.provides.k8s_cluster
  }
  application {
    name      = module.k8s_worker.app_name
    endpoint  = module.k8s_worker.outputs.requires.cluster
  }
}

resource "juju_integration" "k8s_containerd" {
  model = var.model
  application {
    name      = module.k8s.app_name
    endpoint  = module.k8s.outputs.provides.containerd
  }
  application {
    name      = module.k8s_worker.app_name
    endpoint  = module.k8s_worker.outputs.requires.containerd
  }
}


resource "juju_integration" "k8s_cos_worker_tokens" {
  model = var.model
  application {
    name      = module.k8s.app_name
    endpoint  = module.k8s.outputs.provides.cos_worker_tokens
  }
  application {
    name      = module.k8s_worker.app_name
    endpoint  = module.k8s_worker.outputs.requires.cos_tokens
  }
}
