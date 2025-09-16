terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {
  project = "talant-1-471921"
  region  = "us-central1"
  zone    = "us-central1-a"
}