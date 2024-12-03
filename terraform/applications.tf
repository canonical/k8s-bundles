# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

module "k8s" {
  source      = "https://github.com/asbalderson/k8s-operator/tree/k8s-terraform/charms/worker/k8s/terraform"
  app_name    = module.k8s_config.outputs.config.app_name
  channel     = module.k8s_config.outputs.config.channel
  # This currently just sets the bootstrap-node-taints to have the right no scheudle value
  # but more adjustments will need to be made to properly add this to bootstrap-node-taints
  # if that config value is set.
  config      = merge(
                  module.k8s_config.outputs.config.config,
                  {"bootstrap-node-taints": "node-role.kubernetes.io/control-plane:NoSchedule"}
                )
  constraints = module.k8s_config.outputs.config.constraints 
  model_name  = var.model
  resources   = module.k8s_config.outputs.config.resources
  revision    = module.k8s_config.outputs.config.revision
  series      = module.k8s_config.outputs.config.series
  units       = module.k8s_config.outputs.config.units
}

module "k8s_worker" {
  source      = "https://github.com/asbalderson/k8s-operator/tree/k8s-terraform/charms/worker/terraform"
  app_name    = module.k8s_worker_config.outputs.config.app_name
  channel     = module.k8s_worker_config.outputs.config.channel 
  config      = module.k8s_worker_config.outputs.config.config
  constraints = module.k8s_worker_config.outputs.config.constraints 
  model_name  = var.model
  resources   = module.k8s_worker_config.outputs.config.resources
  revision    = module.k8s_worker_config.outputs.config.revision
  series      = module.k8s_worker_config.outputs.config.series
  units       = module.k8s_worker_config.outputs.config.units
}
