resource "google_compute_instance" "apache_instance" {
    name         = "${var.name}-apache-web-server"
    machine_type = "e2-micro"
    zone         = "us-central1-a" # Replace with your desired zone

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-12" # Or your preferred image
        }
    }

    network_interface {
        network = "default" # Or your custom VPC network
        access_config {
            // Ephemeral IP
        }
    }

    tags = ["http-server"] # Used for firewall rules

    metadata = {
        startup-script-url = "gs://${google_storage_bucket.startup_script_bucket.name}/startup-script.sh"
    }

    service_account {
        email  = google_service_account.vm_service_account.email
        scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    }
}

resource "google_compute_firewall" "allow_http" {
    name    = "${var.name}-allow-http-80"
    network = "default" # Or your custom VPC network

    allow {
        protocol = "tcp"
        ports    = ["80"]
    }

    allow {
        protocol = "tcp"
        ports    = ["22"]
    }

    source_ranges = ["0.0.0.0/0"] # Allow traffic from all IP addresses
    target_tags   = ["http-server"] # Apply this rule to instances with the "http-server" tag
}

resource "google_storage_bucket" "startup_script_bucket" {
    name     = var.startup_script_bucket_name
    location = "US"
    force_destroy = true

    lifecycle_rule {
        action {
            type = "Delete"
        }
        condition {
            age = 30
        }
    }
}

resource "null_resource" "copy_startup_script" {
    provisioner "local-exec" {
        command = "gsutil cp ./startup-script.sh gs://${var.startup_script_bucket_name}/startup-script.sh"
    }
}

resource "google_service_account" "vm_service_account" {
    account_id   = "${var.name}-vm-sa"
    display_name = "Service Account for VM"
}

resource "google_storage_bucket_iam_member" "vm_access_bucket" {
    bucket = google_storage_bucket.startup_script_bucket.name
    role   = "roles/storage.objectAdmin"
    member = "serviceAccount:${google_service_account.vm_service_account.email}"
}