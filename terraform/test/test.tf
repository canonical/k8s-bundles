module "k8s" {
  source        = "git::https://github.com/canonical/k8s-bundles//terraform?ref=main" 
  model         = {
    name   = "my-canonical-k8s"
    cloud  = "prod-k8s-openstack"
    config = {"test": true}
  }
  cloud_integration = var.cloud_integration
  manifest_yaml = var.manifest_yaml
}

variable "cloud_integration" {
  description = "Selection of a cloud integration."
  type        = string
}

variable "manifest_yaml" {
  description = "Absolute path to the manifest yaml file for the charm configurations."
  type        = string
}
