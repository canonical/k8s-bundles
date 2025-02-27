# Terraform Manifest Module

This module reads a yaml configuration file and exports the values into terraform variables that
can be passed down into other modules. It is specifically tailored for working with
modules for charms defined with the
[juju terraform provider](https://registry.terraform.io/providers/juju/juju/latest/docs). It
simplifies having to pass every individual charm input as a variable in the product level
module for a given product.

## Inputs
| Name       | Type   | Description                                                            | Required |
|------------|--------|------------------------------------------------------------------------|----------|
| `manifest` | string | Absolute path to the yaml file with the config for a Juju application. | true     |
| `app`      | string | Name of the application to load the config for.                        | true     |

## Outputs
All outputs are under `config` as a map of values below:
| Name          | Description                                                                   |
|---------------|-------------------------------------------------------------------------------|
| `app_name`    | Name of the application in Juju.                                              |
| `base`        | Base to deploy the charm as eg. ubuntu@24.04.                                 |
| `channel`     | Channel of the application being deployed.                                    |
| `config`      | Map of the config for the charm, values can be found under the specific charm |
| `constraints` | String of constraints when deploying the charm `cores=2 mem=4069M`            |
| `resources`   | List of resources to deploy with the charm.                                   |
| `revision`    | Specific revision of this charm to deploy.                                    |
| `units`       | Number of units of a charm to deploy                                          |
| `storage`     | Storage configuration of a charm to deploy                                    |

## Usage

This module is meant to be use as a helper for product modules. It is meant to allow the
user to have one manifest yaml file that can allow hold all the configuration for a solution
or deployment while also allowing the developer to not have to maintain the configuration
between each charm and the overall product.

### Defining a `manifest` in terraform

The manifest module will have to be defined for each charm in question. Terraform will
load the config under the app key and output the values. If the key is not found in the
manifest, then the module will return `null` and terraform will ignore the configuration.

```
module "k8s_config" {
  source = "git::https://github.com/canonical/k8s-bundles//terraform/manifest?ref=main"
  manifest = var.manifest_yaml
  app = "k8s_worker"
}
```

These values can the be passed into a resource for a specific charm:

```
module "k8s_worker" {
  source      = "git::https://github.com/canonical/k8s-operator//charms/worker/terraform?ref=main"
  app_name    = module.k8s_worker_config.config.app_name
  channel     = module.k8s_worker_config.config.channel
  config      = module.k8s_worker_config.config.config
  constraints = module.k8s_worker_config.config.constraints
  model  = var.model
  resources   = module.k8s_worker_config.config.resources
  revision    = module.k8s_worker_config.config.revision
  base        = module.k8s_worker_config.config.base
  units       = module.k8s_worker_config.config.units
}
```

### Defining a manifest.yaml

In the implementation of the product module, the user can specify their configuration using
a single manifest file similar to the one below:

``` yaml
k8s:
    units: 3
    base: ubuntu@24.04
    constraints: arch=amd64 cores=2 mem=8G root-disk=16G
    channel: latest/edge
k8s_worker:
    units: 3
    base: ubuntu@24.04
    constraints: arch=amd64 cores=2 mem=8G root-disk=16G
    channel: latest/edge
```

Using the terraform in the above section, the `units`, `base`, `constraints`, and `channel`
forward into the `k8s_worker` deployment.
