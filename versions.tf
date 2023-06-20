terraform {
  required_version = ">= 1.0"

  required_providers {
    ct = {
      source  = "poseidon/ct"
      version = "0.13.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.67.0"
    }
  }
}

provider "google" {
  region = var.region
  zone   = var.zone
}