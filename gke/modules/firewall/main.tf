##  
resource "google_compute_global_address" "global_addr" {
    provider = google-beta
    name = "private-ip-db-address"
    purpose = "VPC_PEERING"
    address_type = "INTERNAL"
    network = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "name" {
    provider = google_beta
    network = google_compute_network.vpc.id
    service = "servicenetworking.googleapis.com"
    reserved_peering_ranges = [google_compute_global_address.global_addr.name]
}

## DNS
resource "google_compute_address" "this" {
    name = "example"
    region = var.region
}

resource "google_dns_record_set" "wordpress" {
    name = "example.com"
    type = "A"
    ttl = 300
    managed_zone = "example-com"

    rrdatas = [ "example.com." ]
}

## Firewall
resource "google_compute_firewall" "wordpress_ingress" {
    name = "example-http"
    network = google_compute_address.this.id
    allow {
        protocol = "icmp"
    }
    allow {
      protocol = "tcp"
      ports = [ "80", "443" ]
    }
    source_ranges = [ "0.0.0.0/0" ]
}

resource "google_compute_firewall" "wordpress_ingress_ssh" {
  name = "example-ssh"
  network = google_compute_address.this.id

  allow {
    protocol = "tcp"
    ports = [ "22" ]
  }
  source_ranges = [ "192.168.1.33/32" ]
}
