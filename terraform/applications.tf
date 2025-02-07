# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

module "k8s" {
  source      = "git::https://github.com/canonical/k8s-operator//charms/worker/k8s/terraform"
  app_name    = module.k8s_config.config.app_name
  channel     = module.k8s_config.config.channel
  # This currently just sets the bootstrap-node-taints to have the right no schedule value
  # but more adjustments will need to be made to properly add this to bootstrap-node-taints
  # if that config value is set.
  config      = merge(
                  module.k8s_config.config.config,
                  {"bootstrap-node-taints": "node-role.kubernetes.io/control-plane:NoSchedule"}
                )
  constraints = module.k8s_config.config.constraints 
  model       = var.model
  resources   = module.k8s_config.config.resources
  revision    = module.k8s_config.config.revision
  base        = module.k8s_config.config.base
  units       = module.k8s_config.config.units
}

module "k8s_worker" {
  source      = "git::https://github.com/canonical/k8s-operator//charms/worker/terraform"
  app_name    = module.k8s_worker_config.config.app_name
  base        = coalesce(module.k8s_worker_config.config.base,        module.k8s_config.config.base)
  constraints = coalesce(module.k8s_worker_config.config.constraints, module.k8s_config.config.constraints)
  channel     = coalesce(module.k8s_worker_config.config.channel,     module.k8s_config.config.channel)
  config      = module.k8s_worker_config.config.config
  model       = var.model
  resources   = module.k8s_worker_config.config.resources
  revision    = module.k8s_worker_config.config.revision
  units       = module.k8s_worker_config.config.units
}

module "openstack" {
  count           = var.cloud_integration == "openstack" ? 1 : 0
  source          = "./openstack"
  model           = var.model
  manifest_yaml   = var.manifest_yaml
  k8s             = {
    app_name   = module.k8s.app_name
    config     = module.k8s_config.config
    provides   = module.k8s.provides
    requires   = module.k8s.requires
  }
}

module "aws" {
  count           = var.cloud_integration == "aws" ? 1 : 0
  source          = "./aws"
  model           = var.model
  manifest_yaml   = var.manifest_yaml
  k8s             = {
    app_name   = module.k8s.app_name
    config     = module.k8s_config.config
    provides   = module.k8s.provides
    requires   = module.k8s.requires
  }
}
