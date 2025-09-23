resource "google_compute_instance" "apache_instance" {
    name         = "talant-apache-web-server"
    machine_type = "e2-micro"
    zone         = "us-central1-a" # Replace with your desired zone

    boot_disk {
    initialize_params {
        image = "debian-cloud/debian-11" # Or your preferred image
        }
    }

    network_interface {
    network = "default" # Or your custom VPC network
    access_config {
        // Ephemeral IP
        }
    }

    metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install apache2 -y
    sudo systemctl enable apache2
    sudo systemctl start apache2
    echo "<h1>Hello from Talant Apache2 web server $(hostname) $(hostname -i)!</h1>" | sudo tee /var/www/html/index.html
    sudo systemctl restart apache2
    EOF

    tags = ["http-server"] # Used for firewall rules
}

resource "google_compute_firewall" "allow_http" {
    name    = "talant-allow-http-80"
    network = "default" # Or your custom VPC network

    allow {
    protocol = "tcp"
    ports    = ["80"]
    }

    source_ranges = ["0.0.0.0/0"] # Allow traffic from all IP addresses
    target_tags   = ["http-server"] # Apply this rule to instances with the "http-server" tag
}