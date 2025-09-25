resource "google_compute_network" "custom_network" {
    name                    = "${var.name}-network-1"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "custom_subnet" {
    for_each = { for config in var.configs : config.subnet_name => config }

        name          = each.value.subnet_name
        ip_cidr_range = each.value.cidr_range
        region        = each.value.region
        network       = google_compute_network.custom_network.self_link
}

resource "google_compute_firewall" "allow_ssh_http" {
  name    = "${var.name}-allow-ssh-http"
  network = google_compute_network.custom_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["allow-ssh-http"]
}


resource "google_compute_instance" "vm_instances" {
  for_each = { for config in var.configs : config.vm_name => config }

  name         = each.value.vm_name
  machine_type = "e2-micro"
  zone         = each.value.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.custom_network.self_link
    subnetwork = google_compute_subnetwork.custom_subnet[each.value.subnet_name].self_link
    access_config {}
  }

  metadata = {
    startup-script = <<-EOF
        #!/bin/bash
        sudo apt-get update
        sudo apt-get upgrade -y
        sudo apt-get install -y apache2
        sudo systemctl start apache2
        sudo systemctl enable apache2
        echo "<h1>Hello World</h1> from $(hostname) $(hostname -i)" | sudo tee /var/www/html/index.html
        sudo systemctl restart apache2
    EOF
  }

  tags = ["allow-ssh-http"]
}