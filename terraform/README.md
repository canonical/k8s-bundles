# K8s Terraform Module

* THIS IS A WORK IN PROGRESS *

This is a module for deploying Canonical k8s using terraform. It uses
a manifest file to pass configuration for the charms forward into the
charm configuration. 

## TODO
- [  ] Set outputs for each charm deployed
- [  ] Add COS integration
- [  ] Add required subordinate (Landscape, NTP, etc..) see [This private Terraform Plan for details][private-details]

## Applications
* [k8s](https://charmhub.io/k8s)
* [k8s-worker](https://charmhub.io/k8s-worker)

## Inputs
| Name                | Type   | Description                                           | Required |
| ---                 | ---    | ---                                                   | ---   |
| `manifest_yaml`     | string | Absolute path to the manifest yaml for the deployment | True  |
| `model`             | object | Juju model attributes                                 | True  |
| `cloud_integration` | bool   | Enablement of a cloud integration                     | False |

### Model Input:
Juju Model resource definition borrows its schema from [Juju Model Resource].

The schema requires only:
- **name**: Name of the model
- **cloud**: Cloud name

Default fields are:
- **region**: Region name (optional)
- **config**: Configuration map (optional)
- **constraints**: Constraints string (optional)
- **credential**: Credential name (optional)


## Outputs
TODO

## Usage

---
**NOTE**

If the model exists already, it must be imported into the model state to
prevent the model from being destroyed and recreated.

```sh
terraform import module.k8s.juju_model.this "<name of the model>"
```
---


Add the following to your `main.tf` for the canonical k8s solution:


```hcl
module "k8s" {
  source        = "git::https://github.com/canonical/k8s-bundles//terraform?ref=main" 
  model         = {
    name = "my-canonical-k8s"
    cloud = "prod-example-openstack"
  }
  manifest_yaml = "/path/to/manifest.yaml"
}
```

Define your manifest.yaml based on the requirements for your deployment.

This manifest acts like a bundle manifest, as it can define options for 
how each application is deployed like number of units, base, and even config
for that application.  By default, the key value is used as the charm-name as 
well as the application name when deployed.

### A simple cluster

```yaml
k8s:
  units: 3
  base: ubuntu@24.04
  constraints: arch=amd64 cores=2 mem=4096M root-disk=16384M
  channel: 1.33/stable
k8s-worker:
  units: 2
  base: ubuntu@24.04
  constraints: arch=amd64 cores=2 mem=8192M root-disk=16384M
  channel: 1.33/stable
```

Run a plan to ensure everything look correct:

```sh
terraform plan
```

And apply with:

```sh
terraform apply
```

### A multi-worker cluster

In this example, we trade out a noble worker for a jammy worker. 
In this case you can see each must specify they are using the `k8s-worker`
charm. By this mechanism the TF module understands they must still use
the `k8s-worker` terraform modules.

```yaml
k8s:
  units: 3
  base: ubuntu@24.04
  constraints: arch=amd64 cores=2 mem=4096M root-disk=16384M
  channel: 1.33/stable
k8s-worker-noble:
  charm: k8s-worker
  units: 1
  base: ubuntu@24.04
  constraints: arch=amd64 cores=2 mem=8192M root-disk=16384M
  channel: 1.33/stable
k8s-worker-jammy:
  charm: k8s-worker
  units: 1
  base: ubuntu@22.04
  constraints: arch=amd64 cores=2 mem=8192M root-disk=16384M
  channel: 1.33/stable
```


### A single node cluster

In this example, we deploy with a single unit of the k8s charm.

```yaml
k8s:
  units: 1
  base: ubuntu@24.04
  constraints: arch=amd64 cores=2 mem=4096M root-disk=16384M
  channel: 1.33/stable
```

### A cloud integrated cluster

In this example, we deploy with a single unit of the k8s charm but with an 
addition of an openstack set of integrations. This adds to the model
* openstack-integrator (trusted)
* cinder-csi
* openstack-cloud-controller

```yaml
k8s:
  units: 1
  base: ubuntu@24.04
  constraints: arch=amd64 cores=2 mem=4096M root-disk=16384M
  channel: 1.33/stable
openstack-integrator:
  channel: latest/stable
  base: ubuntu@22.04
cinder-csi: {}
openstack-cloud-controller: {}  
```

To use this cloud-integration, update your `main.tf`

```hcl
module "k8s" {
  source        = "git::https://github.com/canonical/k8s-bundles//terraform?ref=main" 
  model         = {
    name  = "my-canonical-k8s"
    cloud = "prod-example-openstack"
  }
  cloud_integration = "openstack"
  manifest_yaml = "/path/to/manifest.yaml"
}
```

### A csi integrated cluster

In this example, we deploy a single unit of the k8s charm, but with an
addition of a ceph cluster integration.  This adds to the model
* ceph-csi
* ceph-mon
* ceph-osd

Each of the ceph applications needs to identify which 
ceph cluster it operates with using the `cluster-name` field 
Also, the `csi_integration` field lets us know the csi-integration
type these apps relate to.

```hcl
k8s:
  units: 1
  base: ubuntu@22.04
  constraints: arch=amd64 cores=2 mem=8192M root-disk=16384M
  channel: 1.33/stable

ceph-csi:
  csi_integration: ceph
  cluster-name: main
  channel: latest/edge
  base: ubuntu@22.04
ceph-mon:
  csi_integration: ceph
  cluster-name: main
  channel: quincy/stable
  base: ubuntu@22.04
  constraints: arch=amd64 cores=2 mem=4096M root-disk=16384M
  units: 1
  config:
    monitor-count: 1
    expected-osd-count: 2
ceph-osd:
  csi_integration: ceph
  cluster-name: main
  channel: quincy/stable
  base: ubuntu@22.04
  constraints: arch=amd64 cores=2 mem=4096M root-disk=16384M
  units: 2
  storage:
    osd-devices: 1G,1
    osd-journals: 1G,1
```

to use this, add a `csi_integration` field to your top-level main.tf

```hcl
module "k8s" {
  source        = "git::https://github.com/canonical/k8s-bundles//terraform?ref=main" 
  model         = {
    name  = "my-canonical-k8s"
    cloud = "prod-example-openstack"
  }
  csi_integration = ["ceph]
  manifest_yaml = "/path/to/manifest.yaml"
}
```

### A multi csi integrated cluster. 

In this example, we deploy a single unit of the k8s charm, but with two
additional ceph cluster integrations.  This adds to the model not only
* ceph-csi
* ceph-mon
* ceph-osd
But a second cluster of ceph as well:
* ceph-csi-alt
* ceph-mon-alt
* ceph-osd-alt

```hcl
k8s:
  units: 1
  base: ubuntu@22.04
  constraints: arch=amd64 cores=2 mem=8192M root-disk=16384M
  channel: 1.33/stable

# Snipped ... apps from the first cluster

ceph-csi-alt:
  csi_integration: ceph
  cluster-name: alt
  charm: ceph-csi
  channel: latest/edge
  base: ubuntu@22.04
ceph-mon-alt:
  csi_integration: ceph
  cluster-name: alt
  charm: ceph-mon
  channel: quincy/stable
  base: ubuntu@22.04
  constraints: arch=amd64 cores=2 mem=4096M root-disk=16384M
  units: 1
  config:
    monitor-count: 1
    expected-osd-count: 2
ceph-osd-alt:
  csi_integration: ceph
  cluster-name: alt
  charm: ceph-osd
  channel: quincy/stable
  base: ubuntu@22.04
  constraints: arch=amd64 cores=2 mem=4096M root-disk=16384M
  units: 2
  storage:
    osd-devices: 1G,1
    osd-journals: 1G,1
```


<!--LINKS -->
[Juju Model Resource]: https://registry.terraform.io/providers/juju/juju/0.16.0/docs/resources/model
[private-details]: https://git.launchpad.net/canonical-terraform-modules/tree/services/compute/canonical_k8s_cluster/main.tf#n214
