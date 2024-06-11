resource "google_project_service" "compute-engine" {
  disable_on_destroy = false
  project            = var.host_project
  service            = "compute.googleapis.com"

  depends_on = [google_project_service.os-login]
}

resource "google_project_service" "iam-credentials" {
  disable_on_destroy = false
  project            = var.host_project
  service            = "iamcredentials.googleapis.com"
}

resource "google_project_service" "logging" {
  disable_on_destroy = false
  project            = var.host_project
  service            = "logging.googleapis.com"
}

resource "google_project_service" "monitoring" {
  disable_on_destroy = false
  project            = var.host_project
  service            = "monitoring.googleapis.com"
}

resource "google_project_service" "network-management" {
  disable_on_destroy = false
  project            = var.host_project
  service            = "networkmanagement.googleapis.com"
}

resource "google_project_service" "os-config" {
  disable_on_destroy = false
  project            = var.host_project
  service            = "osconfig.googleapis.com"

  depends_on = [
    google_project_service.os-login,
    google_project_service.compute-engine
  ]
}

resource "google_project_service" "os-login" {
  disable_on_destroy = false
  project            = var.host_project
  service            = "oslogin.googleapis.com"
}

resource "google_project_service" "service-usage" {
  disable_on_destroy = false
  project            = var.host_project
  service            = "serviceusage.googleapis.com"
}

resource "google_project_service" "storage" {
  disable_on_destroy = false
  project            = var.host_project
  service            = "storage.googleapis.com"
}

resource "google_project_service" "storage-component" {
  disable_on_destroy = false
  project            = var.host_project
  service            = "storage-component.googleapis.com"
}
