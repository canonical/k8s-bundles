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

output "csi_driver_nfs" {
  description = "Object of the csi-driver-nfs application. Null when manila CSI is not enabled."
  value       = one(module.csi_driver_nfs[*])
}

output "manila_csi" {
  description = "Object of the manila-csi application. Null when manila CSI is not enabled."
  value       = one(module.manila_csi[*])
}
