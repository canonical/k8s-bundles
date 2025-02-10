# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.
# This Terraform module was highly inspired by
# https://github.com/canonical/snap-openstack/blob/main/cloud/etc/deploy-microceph/main.tf

resource "juju_application" "microceph" {
  name  = var.app_name
  model = var.model

  charm {
    name     = "microceph"
    channel  = var.channel
    revision = var.revision
    base     = var.base
  }

  config      = var.config
  constraints = var.constraints
}

# juju_offer.microceph_offer will be created
resource "juju_offer" "microceph_offer" {
  application_name = juju_application.microceph.name
  endpoint         = "ceph"
  model            = var.model
}
