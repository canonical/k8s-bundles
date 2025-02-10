# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

output "microceph" {
  description = "Object of the microceph application."
  value       = module.microceph
}

output "ceph_csi" {
  description = "Object of the ceph-csi application."
  value       = module.ceph_csi
}
