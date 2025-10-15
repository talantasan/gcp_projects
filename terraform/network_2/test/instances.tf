# VPC network
resource "google_compute_network" "vpc" {
  name                    = "ssh-demo-vpc"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "ssh-demo-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
}

# Firewall rule: Allow SSH (port 22) from within the VPC
resource "google_compute_firewall" "allow_ssh_internal" {
  name    = "allow-ssh-internal"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["10.0.1.0/24"]  # Internal subnet range; adjust if needed
  target_tags   = ["ssh-allowed"]   # Applied to both instances
}

# Public instance
resource "google_compute_instance" "public_instance" {
  name         = "public-instance"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  tags = ["ssh-allowed"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    # Ephemeral external IP
    access_config {}
  }

  # Enable OS Login
  metadata = {
    enable-oslogin = "TRUE"
  }

  # Optional: Service account for advanced permissions
  service_account {
    email  = "default"  # Or create a custom one
    scopes = ["cloud-platform"]
  }
}

# Private instance
resource "google_compute_instance" "private_instance" {
  name         = "private-instance"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  tags = ["ssh-allowed"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    # No external IP (private only)
  }

  # Enable OS Login
  metadata = {
    enable-oslogin = "TRUE"
  }

  # Optional: Service account
  service_account {
    email  = "default"
    scopes = ["cloud-platform"]
  }
}

# Outputs
output "public_instance_external_ip" {
  value = google_compute_instance.public_instance.network_interface[0].access_config[0].nat_ip
}

output "private_instance_internal_ip" {
  value = google_compute_instance.private_instance.network_interface[0].network_ip
}