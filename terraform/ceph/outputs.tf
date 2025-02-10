# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

output "openstack_integrator" {
  description = "Object of the openstack-integrator application."
  value       = module.openstack_integrator
}

output "ceph_mon" {
  description = "Object of the ceph-mon application."
  value       = module.ceph_mon
}

output "ceph_csi" {
  description = "Object of the ceph-csi application."
  value       = module.ceph_csi
}
