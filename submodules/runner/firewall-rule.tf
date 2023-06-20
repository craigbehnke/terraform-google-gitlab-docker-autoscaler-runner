resource "google_compute_firewall" "manager_to_pool" {
  name    = "manager-to-${var.id}-pool"
  network = var.network_name
  project = var.host_project

  # Allow access to the Docker daemon from the runner to the pool instance
  allow {
    protocol = "tcp"
    ports    = ["2375"]
  }

  # Allow SSH access from the runner to the pool instance
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = ["manager"]
  target_tags = ["runner-pool-${var.id}"]
}

# Allow SSH access from the web (cloud console) to the runner
resource "google_compute_firewall" "web_to_pool" {
  count   = var.allow_cloud_console_ssh ? 1 : 0
  name    = "web-to-pool-${var.id}"
  network = var.network_name
  project = var.host_project

  # Allow SSH access from the web
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # All allowed traffic must come from the GCP identity proxy
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["runner-pool-${var.id}"]
}
