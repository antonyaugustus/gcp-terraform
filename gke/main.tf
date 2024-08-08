terraform {
  backend "local" {}
}

provider "google" {}

module "cluster" {
    source = "./cluster"
    region = var.region
    cluster_name = var.cluster_name
    k8s_version = var.k8s_version
}