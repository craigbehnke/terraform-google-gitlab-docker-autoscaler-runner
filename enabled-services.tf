resource "google_project_service" "compute-engine" {
  project = var.host_project
  service = "compute.googleapis.com"
}

resource "google_project_service" "iam-credentials" {
  project = var.host_project
  service = "iamcredentials.googleapis.com"
}

resource "google_project_service" "logging" {
  project = var.host_project
  service = "logging.googleapis.com"
}

resource "google_project_service" "monitoring" {
  project = var.host_project
  service = "monitoring.googleapis.com"
}

resource "google_project_service" "network-management" {
  project = var.host_project
  service = "networkmanagement.googleapis.com"
}

resource "google_project_service" "os-config" {
  project = var.host_project
  service = "osconfig.googleapis.com"
}

resource "google_project_service" "os-login" {
  project = var.host_project
  service = "oslogin.googleapis.com"
}

resource "google_project_service" "service-usage" {
  project = var.host_project
  service = "serviceusage.googleapis.com"
}

resource "google_project_service" "storage" {
  project = var.host_project
  service = "storage.googleapis.com"
}

resource "google_project_service" "storage-component" {
  project = var.host_project
  service = "storage-component.googleapis.com"
}
