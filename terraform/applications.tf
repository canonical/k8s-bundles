# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

module "k8s" {
  source      = "git::https://github.com/asbalderson/k8s-operator//charms/worker/k8s/terraform?ref=k8s-terraform"
  app_name    = module.k8s_config.config.app_name
  channel     = module.k8s_config.config.channel
  # This currently just sets the bootstrap-node-taints to have the right no scheudle value
  # but more adjustments will need to be made to properly add this to bootstrap-node-taints
  # if that config value is set.
  config      = merge(
                  module.k8s_config.config.config,
                  {"bootstrap-node-taints": "node-role.kubernetes.io/control-plane:NoSchedule"}
                )
  constraints = module.k8s_config.config.constraints 
  model  = var.model
  resources   = module.k8s_config.config.resources
  revision    = module.k8s_config.config.revision
  base        = module.k8s_config.config.base
  units       = module.k8s_config.config.units
}

module "k8s_worker" {
  source      = "git::https://github.com/asbalderson/k8s-operator//charms/worker/terraform?ref=k8s-terraform"
  app_name    = module.k8s_worker_config.config.app_name
  channel     = module.k8s_worker_config.config.channel 
  config      = module.k8s_worker_config.config.config
  constraints = module.k8s_worker_config.config.constraints 
  model  = var.model
  resources   = module.k8s_worker_config.config.resources
  revision    = module.k8s_worker_config.config.revision
  base        = module.k8s_worker_config.config.base
  units       = module.k8s_worker_config.config.units
}
