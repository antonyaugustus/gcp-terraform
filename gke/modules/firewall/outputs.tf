output "uc1_public_address" {
    value = google_compute_instance.default.network_interface.0.network_ip
}
output "uc1_private_address" {
    value = google_compute_instance.default.network_interface.0.network_ip
}
