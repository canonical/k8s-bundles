# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

output "openstack_integrator" {
  description = "Object of the openstack-integrator application."
  value       = module.openstack_integrator
}

output "cinder_csi" {
  description = "Object of the cinder-csi application."
  value       = module.cinder_csi
}

output "openstack_cloud_controller" {
  description = "Object of the openstack-cloud-controller application."
  value       = module.openstack_cloud_controller
}
