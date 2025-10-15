resource "google_compute_network" "vpc_network" {
    name                    = "${var.name}-2-tier-network"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public_subnet" {
    name          = "${var.name}-public-subnet"
    network       = google_compute_network.vpc_network.id
    ip_cidr_range = "10.0.1.0/24"
    region        = "us-central1"
}

resource "google_compute_subnetwork" "private_subnets" {
    count                 = 1
    name                  = "${var.name}-private-subnet-${count.index + 1}"
    network               = google_compute_network.vpc_network.id
    ip_cidr_range         = "10.0.${count.index + 2}.0/24"
    region                = var.region[count.index]
    private_ip_google_access = true
}

resource "google_compute_firewall" "allow_ssh_public" {
    name    = "${var.name}-allow-ssh"
    network = google_compute_network.vpc_network.name
    direction = "INGRESS"

    allow {
        protocol = "tcp"
        ports    = ["22"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["public"]
}

resource "google_compute_firewall" "allow_ssh_internal" {
    name    = "${var.name}-allow-ssh-internal"
    network = google_compute_network.vpc_network.name
    direction = "INGRESS"

    allow {
        protocol = "tcp"
        ports    = ["22"]
    }
    source_ranges = ["10.0.0.0/8"]  # Default VPC CIDR; adjust if using custom VPC
    target_tags = ["private"]
}


# Public Instance Creation
resource "google_compute_instance" "public_instance" {
    name         = "${var.name}-public-instance"
    machine_type = var.machine_type
    zone         = "us-central1-a"

    boot_disk {
        initialize_params {
            image = "projects/debian-cloud/global/images/family/debian-12"
        }
    }

    network_interface {
        subnetwork = google_compute_subnetwork.public_subnet.id

        access_config {
            # Ephemeral public IP
        }
    }
    tags = ["public"]
}

resource "google_compute_instance" "private_instance" {
    name         = "${var.name}-private-instance"
    machine_type = var.machine_type
    zone         = "us-central1-a"

    boot_disk {
        initialize_params {
            image = "projects/debian-cloud/global/images/family/debian-12"
        }
    }

    # Enable OS Login
    metadata = {
        enable-oslogin = "TRUE"
    }

    network_interface {
        subnetwork = google_compute_subnetwork.private_subnets[0].id
    }
    tags = ["private"]

    metadata_startup_script = <<-EOF
        #!/bin/bash
        sudo apt-get update
        sudo apt-get install -y apache2
        sudo systemctl start apache2
        sudo systemctl enable apache2
        echo '<h1>Hello from $(hostname) $(hostname -i)</h1>' | sudo tee -a /var/www/html/index.html
        sudo systemctl restart apache2
    EOF
}

