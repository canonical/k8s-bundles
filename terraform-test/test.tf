module "k8s" {
  source        = "../terraform"
  model         = {
    name   = "my-canonical-k8s"
    cloud  = "my-prod-cloud"
    config = {"test": true}
  }
  cloud_integration = var.cloud_integration
  manifest_yaml = var.manifest_yaml
  csi_integration = var.csi_integration
}

variable "cloud_integration" {
  description = "Selection of a cloud integration."
  type        = string
}

variable "csi_integration" {
  description = "Selection of a csi integration."
  type        = list(string)
}

variable "manifest_yaml" {
  description = "Absolute path to the manifest yaml file for the charm configurations."
  type        = string
}

output "debug" {
  value = {
    k8s = module.k8s.debug
  }
}
