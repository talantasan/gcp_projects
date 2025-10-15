resource "google_compute_network" "mynetwork" {
  name                    = "mynetwork"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "mynetwork-allow-http-ssh-rdp-icmp" {
  name      = "mynetwork-allow-http-ssh-rdp-icmp"
  direction = "INGRESS"
  priority  = 1000
  network   = google_compute_network.mynetwork.self_link
  allow {
    protocol = "tcp"
    ports    = ["80", "22", "3389"]
  }

  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

# Create the mynet-vm-1 instance
module "mynet-vm-1" {
  source           = "./instance"
  instance_name    = "mynet-vm-1"
  instance_zone    = "asia-east1-a"
  instance_network = google_compute_network.mynetwork.self_link
}

# Create the mynet-vm-2" instance
module "mynet-vm-2" {
  source           = "./instance"
  instance_name    = "mynet-vm-2"
  instance_zone    = "us-east1-c"
  instance_network = google_compute_network.mynetwork.self_link
}
