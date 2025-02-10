resource "juju_integration" "microceph-identity" {
  count = (var.keystone-endpoints-offer-url != null) ? 1 : 0
  model = var.model

  application {
    name     = juju_application.microceph.name
    endpoint = "identity-service"
  }

  application {
    offer_url = var.keystone-endpoints-offer-url
  }
}

resource "juju_integration" "microceph-traefik-rgw" {
  count = (var.ingress-rgw-offer-url != null) ? 1 : 0
  model = var.model

  application {
    name     = juju_application.microceph.name
    endpoint = "traefik-route-rgw"
  }

  application {
    offer_url = var.ingress-rgw-offer-url
  }
}

resource "juju_integration" "microceph-cert-distributor" {
  count = (var.cert-distributor-offer-url != null) ? 1 : 0
  model = var.model

  application {
    name     = juju_application.microceph.name
    endpoint = "receive-ca-cert"
  }

  application {
    offer_url = var.cert-distributor-offer-url
  }
}
