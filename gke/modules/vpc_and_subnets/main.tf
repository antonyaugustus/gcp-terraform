terraform {
    required_providers{
        google = {
            source = "hashicorp/google"
            version = "4.74.0"
        }
    }
}

resource "google_compute_network" "vpc" {
    name = var.vpc_name
    description = var.vpc_description
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
    name = var.subnet_name
    description = var.subnet_description
    region = var.region
    network = google_compute_network.vpc.name
    ip_cidr_range = var.cidrBlock
}