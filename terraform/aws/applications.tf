# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

locals {
  _integrator_keys       = keys(module.aws_integrator_config.config)
  _storage_keys          = keys(module.aws_k8s_storage_config.config)
  _cloud_controller_keys = keys(module.aws_cloud_provider_config.config)
  _max_key_count         = max(length(local._integrator_keys), length(local._storage_keys), length(local._cloud_controller_keys))

  integrator_config = local._max_key_count == 1 ? module.aws_integrator_config.config[local._integrator_keys[0]] : null
  storage_config = local._max_key_count == 1 ? module.aws_k8s_storage_config.config[local._storage_keys[0]] : null
  cloud_controller_config = local._max_key_count == 1 ? module.aws_cloud_provider_config.config[local._cloud_controller_keys[0]] : null
}

resource "null_resource" "validate_all_apps_unique" {
  count = local._max_key_count == 1 ? 0 : 1

  provisioner "local-exec" {
    command = <<EOT
      >&2 echo "ERROR: Expected exactly 1 entry for each application"
      >&2 echo "  aws-integrator: ${local._integrator_keys}"
      >&2 echo "  aws-k8s-storage: ${local._storage_keys}"
      >&2 echo "  aws-cloud-provider: ${local._cloud_controller_keys}"
      exit 1
    EOT
  }
}

output "debug" {
  value = {
    integrator_config = local.integrator_config
    storage_config = local.storage_config
    cloud_controller_config = local.cloud_controller_config
  }
}

module "aws_integrator" {
  source      = "git::https://github.com/charmed-kubernetes/charm-aws-integrator//terraform?ref=main"

  model       = var.model
  app_name    = local.integrator_config.app_name
  base        = coalesce(local.integrator_config.base, var.k8s.base)
  constraints = coalesce(local.integrator_config.constraints, var.k8s.constraints)
  channel     = coalesce(local.integrator_config.channel, var.k8s.channel)

  config      = coalesce(local.integrator_config.config, {})
  resources   = local.integrator_config.resources
  revision    = local.integrator_config.revision
  units       = local.integrator_config.units
}

module "aws_k8s_storage" {
  source      = "git::https://github.com/charmed-kubernetes/aws-k8s-storage//terraform?ref=main"

  model       = var.model
  app_name    = local.storage_config.app_name
  base        = coalesce(
    local.storage_config.base,
    local.integrator_config.base,
    var.k8s.base
  )
  channel     = coalesce(
    local.storage_config.channel,
    local.integrator_config.channel,
    var.k8s.channel
  )
  config      = coalesce(local.storage_config.config, {})
  revision    = local.storage_config.revision
}

module "aws_cloud_provider" {
  source      = "git::https://github.com/charmed-kubernetes/charm-aws-cloud-provider//terraform?ref=main"

  model       = var.model
  app_name    = local.cloud_controller_config.app_name
  base        = coalesce(
    local.cloud_controller_config.base,
    local.integrator_config.base,
    var.k8s.base
  )
  channel     = coalesce(
    local.cloud_controller_config.channel,
    local.integrator_config.channel,
    var.k8s.channel
  )
  config      = coalesce(local.cloud_controller_config.config, {})
  revision    = local.cloud_controller_config.revision
}
