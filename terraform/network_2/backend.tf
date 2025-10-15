terraform {
  backend "gcs"{
    bucket = "talant-1-471921"
    prefix = "terraform/2-tier-network/1" # Optional: for organizing state files within the bucket
    }
}