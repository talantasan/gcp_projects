resource "google_compute_network" "custom_network" {
    name                    = "${var.name}-network-2"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "custom_subnet" {
    for_each = { for config in var.configs : config.subnet_name => config }

        name          = each.value.subnet_name
        ip_cidr_range = each.value.cidr_range
        region        = each.value.region
        network       = google_compute_network.custom_network.self_link
}


resource "google_compute_instance" "vm_instances" {
  for_each = { for config in var.configs : config.name => config }

  name         = each.value.name
  machine_type = "e2-micro"
  zone         = each.value.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.custom_network.self_link
    access_config {}
  }

metadata = {
    startup-script = <<-EOT
        #!/bin/bash
        apt-get update
        apt-get install -y apache2
        systemctl start apache2
        systemctl enable apache2
    EOT
    }
}