# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

module "aws_integrator" {
  source      = "git::https://github.com/charmed-kubernetes/charm-aws-integrator//terraform?ref=release_1.32"

  model       = var.model
  app_name    = module.aws_integrator_config.config.app_name
  base        = coalesce(module.aws_integrator_config.config.base, var.k8s.base)
  constraints = coalesce(module.aws_integrator_config.config.constraints, var.k8s.constraints)
  channel     = coalesce(module.aws_integrator_config.config.channel, var.k8s.channel)

  config      = coalesce(module.aws_integrator_config.config.config, {})
  resources   = module.aws_integrator_config.config.resources
  revision    = module.aws_integrator_config.config.revision
  units       = module.aws_integrator_config.config.units
}

module "aws_k8s_storage" {
  source      = "git::https://github.com/charmed-kubernetes/aws-k8s-storage//terraform?ref=release_1.32"

  model       = var.model
  app_name    = module.aws_k8s_storage_config.config.app_name
  base        = coalesce(
    module.aws_k8s_storage_config.config.base,
    module.aws_integrator_config.config.base,
    var.k8s.base
  )
  channel     = coalesce(
    module.aws_k8s_storage_config.config.channel,
    module.aws_integrator_config.config.channel,
    var.k8s.channel
  )
  config      = coalesce(module.aws_k8s_storage_config.config.config, {})
  revision    = module.aws_k8s_storage_config.config.revision
}

module "aws_cloud_provider" {
  source      = "git::https://github.com/charmed-kubernetes/charm-aws-cloud-provider//terraform?ref=release_1.32"

  model       = var.model
  app_name    = module.aws_cloud_provider_config.config.app_name
  base        = coalesce(
    module.aws_cloud_provider_config.config.base,
    module.aws_integrator_config.config.base,
    var.k8s.base
  )
  channel     = coalesce(
    module.aws_cloud_provider_config.config.channel,
    module.aws_integrator_config.config.channel,
    var.k8s.channel
  )
  config      = coalesce(module.aws_cloud_provider_config.config.config, {})
  revision    = module.aws_cloud_provider_config.config.revision
}
