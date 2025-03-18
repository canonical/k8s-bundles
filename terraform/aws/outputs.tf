# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

output "aws_integrator" {
  description = "Object of the aws-integrator application."
  value       = module.aws_integrator
}

output "aws_k8s_storage" {
  description = "Object of the aws-k8s-storage application."
  value       = module.aws_k8s_storage
}

output "aws_cloud_provider" {
  description = "Object of the aws-cloud-provider application."
  value       = module.aws_cloud_provider
}
