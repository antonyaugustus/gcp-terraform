resource "google_compute_instance" "default" {
  name         = "${format("%s", "${var.company}-${var.env}-${var.region_map["${var.region_name}"]}-instance1")}"
  machine_type = "n1-standard-1"
  zone = "${format("%s", "${var.region_name}-b")}"
  tags         = ["ssh", "http"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  labels { 
    webserver = "true"
  }
  metadata {
    startup-script = <<script
    apt-get -y update
    apt-get -y install nginx
    export HOSTNAME=$(hostname | tr -d '\n')
    export PRIVATE_IP=$(curl -sF -H 'Metadata-Flavor: Google'
    http://metadata/computeMetadata/v1/instance/network-interfaces/0/ip | tr -d '\n')
    echo "Welcome to $HOSTNAME - $PRIVATE_IP" > /usr/share/nginx/www/index.html
    service nginx start
    SCRIPT
  }

  network_interface {
    network = google_compute_subnetwork.public_subnet.name
    access_config {
        
    }
  }
}