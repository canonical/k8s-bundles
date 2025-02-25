# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_model" "this" {
  name = var.model.name

  cloud {
    name     = var.model.cloud
    region   = var.model.region
  }

  config = merge(
    {  # Remove two keys from the config map if they exist
      for k, v in var.model.config != null ? var.model.config : {} :
        k => v
          if !contains(["fan-config", "container-networking-method"], k)
    },
    {
      fan-config                  = ""
      container-networking-method = "local"
    }
  )

  constraints = var.model.constraints
  credential = var.model.credential

  provisioner "local-exec" {
    # workaround for https://github.com/juju/terraform-provider-juju/issues/667
    command = "juju model-config fan-config=''"
  }
}

resource "juju_integration" "k8s_cluster_integration" {
  model = resource.juju_model.this.name
  application {
    name      = module.k8s.app_name
    endpoint  = module.k8s.provides.k8s_cluster
  }
  application {
    name      = module.k8s_worker.app_name
    endpoint  = module.k8s_worker.requires.cluster
  }
}

resource "juju_integration" "k8s_containerd" {
  model = resource.juju_model.this.name
  application {
    name      = module.k8s.app_name
    endpoint  = module.k8s.provides.containerd
  }
  application {
    name      = module.k8s_worker.app_name
    endpoint  = module.k8s_worker.requires.containerd
  }
}

resource "juju_integration" "k8s_cos_worker_tokens" {
  model = resource.juju_model.this.name
  application {
    name      = module.k8s.app_name
    endpoint  = module.k8s.provides.cos_worker_tokens
  }
  application {
    name      = module.k8s_worker.app_name
    endpoint  = module.k8s_worker.requires.cos_tokens
  }
}
