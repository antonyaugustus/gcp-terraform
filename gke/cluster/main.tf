module "vpc_with_subnets" {
    source = "../modules/vpc_and_subnets"

    vpc_name = var.cluster_name
    subnet_name = var.cluster_name

    region = var.region
    cidrBlock = var.cidrBlock
}

module "gke_with_node_group" {
    source = "../modules/gke"

    cluster_name = var.cluster_name
    k8s_version = var.k8s_version
    region = var.region
    nodepools = var.nodepools
    network = module.vpc_with_subnets.vpc_self_link
    subnetwork = module.vpc_with_subnets.subnet_self_link

}