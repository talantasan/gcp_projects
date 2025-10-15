terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
  required_version = ">= 1.3.0"
}


provider "google" {
  project = "talant-1-471921"
  region  = "us-central1"
  zone    = "us-central1-a"
}