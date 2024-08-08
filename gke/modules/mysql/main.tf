# MySQL
resource "google_sql_database_instance" "mysql" {
  name             = var.database_name
  database_version = var.database_version
  region           = var.region

  depends_on = [ google_service_ ]
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project}-vpc"
  auto_create_subnetworks = "false"
}
# F/w
resource "google_compute_firewall" "allow-internal" {
  name    = "${var.company}-fw-allow-internal"
  network = google_compute_network.vpc.name
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  source_ranges = [
    "${var.var_uc1_private_subnet}",
    "${var.var_ue1_private_subnet}",
    "${var.var_uc1_public_subnet}",
    "${var.var_ue1_public_subnet}"
  ]
}
resource "google_compute_firewall" "allow-http" {
  name    = "${var.company}-fw-allow-http"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http"]
}
resource "google_compute_firewall" "allow-bastion" {
  name    = "${var.company}-fw-allow-bastion"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
}
