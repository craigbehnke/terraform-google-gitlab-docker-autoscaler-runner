resource "google_compute_network" "runner_network" {
  project                 = var.host_project
  name                    = "runner-network"
  auto_create_subnetworks = true
  mtu                     = 1460
}

# Allow SSH access from the web (cloud console) to the manager
resource "google_compute_firewall" "web_to_manager" {
  count   = var.allow_cloud_console_ssh ? 1 : 0
  name    = "web-to-manager"
  network = google_compute_network.runner_network.name
  project = var.host_project

  # Allow SSH access from the web
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # All allowed traffic must come from the GCP identity proxy
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["manager"]
}


module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 5.0"
  project = var.host_project
  name    = "runner-router"
  network = google_compute_network.runner_network.name
  region  = var.region
}