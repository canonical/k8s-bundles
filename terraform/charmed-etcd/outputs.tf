# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

output "charmed_etcd" {
  description = "Object of the charmed-etcd application."
  value       = module.charmed_etcd
}

