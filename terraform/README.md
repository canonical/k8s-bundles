# K8s Terraform Module

* THIS IS A WORK IN PROGRESS *

This is a module for deploying Canonical k8s using terraform. It uses
a manifest file to pass configuration for the charms forward into the
charm configuration. 

## TODO
- [  ] Set outputs for each charm deployed
- [  ] Add COS integration
- [  ] Find a home for this module
- [  ] Add required subordinate (Landscape, NTP, etc..) see [This private Terraform Plan for details](https://git.launchpad.net/canonical-terraform-modules/tree/services/compute/canonical_k8s_cluster/main.tf#n214)

## Applications
* [k8s](https://charmhub.io/k8s)
* [k8s-worker](https://charmhub.io/k8s-worker)

## Inputs
| Name | Type | Description | Required |
| - | - | - | - |
| `manifest_yaml` | string | Absolute path to the manifest yaml for the deployment | True |
| `model` | string | Name of the Juju model to deploy into | True |

## Outputs
TODO

## Usage

Add the following to your main.tf for the canonical k8s solution:

```
module "k8s" {
  source        = "git::https://github.com/asbalderson/k8s-bundles//terraform?ref=terraform-bundle-basic" 
  model         = "my-canoical-k8s"
  manifest_yaml = "/path/to/manifest.yaml"
}
```

Define your manifest.yaml based on the requirements for your deployment. Specific configuration
options can be found under the charm URLs linked above.

```
k8s:
    units: 2
    base: ubuntu@24.04
    constraints: arch=amd64 cores=2 mem=4096M root-disk=16384M
    channel: 1.31/beta
k8s_worker:
    units: 2
    base: ubuntu@24.04
    constraints: arch=amd64 cores=2 mem=8192M root-disk=16384M
    channel: 1.31/beta
```



