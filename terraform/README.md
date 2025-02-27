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
  cloud_integration = "openstack"
  manifest_yaml = "/path/to/manifest.yaml"
}
```

Define your manifest.yaml based on the requirements for your deployment. Specific configuration options can be found under the charm URLs linked above.

```yaml
k8s:
  units: 3
  base: ubuntu@24.04
  constraints: arch=amd64 cores=2 mem=4096M root-disk=16384M
  channel: 1.32/stable
k8s_worker:
  units: 2
  base: ubuntu@24.04
  constraints: arch=amd64 cores=2 mem=8192M root-disk=16384M
  channel: 1.32/stable
```

Run a plan to ensure everything look correct:

```sh
terraform plan
```

And apply with:

```sh
terraform apply
```

<!--LINKS -->
[Juju Model Resource]: https://registry.terraform.io/providers/juju/juju/0.16.0/docs/resources/model
[private-details]: https://git.launchpad.net/canonical-terraform-modules/tree/services/compute/canonical_k8s_cluster/main.tf#n214
