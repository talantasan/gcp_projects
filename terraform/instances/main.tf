resource "google_compute_instance" "vm_instance" {
    name         = "talant-vm1"
    machine_type = "e2-micro"
    zone         = "us-central1-a"

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-12"
        }
    }

    network_interface {
        network = "default"
        access_config {}
    }

    metadata_startup_script = <<-EOT
        #!/bin/bash
        sudo su
        echo "Hello, World!" > /var/log/startup-script.log
        apt-get update
        apt-get install -y apache2
        echo "Hello, World from $(hostname) $(hostname -i) > /var/www/html/index.html"
        systemctl start apache2
    EOT

    tags = ["http-server"]
}

resource "google_compute_firewall" "allow_http" {
    name    = "allow-http"
    network = "default"

    allow {
        protocol = "tcp"
        ports    = ["80"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["http-server"]
}

