terraform {
  backend "gcs"{
    bucket = "talant-1-471921"
    prefix = "terraform/network/1" # Optional: for organizing state files within the bucket
    }
}