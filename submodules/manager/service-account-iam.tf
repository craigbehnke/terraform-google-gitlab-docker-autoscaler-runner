# Create the service account
resource "google_service_account" "manager-sa" {
  account_id   = "manager-sa"
  display_name = "Manager VM Service Account"
  project      = var.host_project
}

# Grant access for the service account to use storage, pull images from the registry, and interact with cloud build
resource "google_project_iam_member" "manager-sa-storage" {
  project = var.host_project
  role    = "roles/storage.objectAdmin"
  member  = google_service_account.manager-sa.member
}

resource "google_project_iam_member" "manager-sa-registry" {
  project = var.host_project
  role    = "roles/artifactregistry.reader"
  member  = google_service_account.manager-sa.member
}

resource "google_project_iam_member" "manager-sa-compute-admin" {
  project = var.host_project
  role    = "roles/compute.instanceAdmin.v1"
  member  = google_service_account.manager-sa.member
}

resource "google_project_iam_member" "manager-sa-secret-viewer" {
  project = var.host_project
  role    = "roles/secretmanager.secretAccessor"
  member  = google_service_account.manager-sa.member
}

resource "google_project_iam_member" "manager-sa-metrics" {
  project = var.host_project
  role    = "roles/monitoring.metricWriter"
  member  = google_service_account.manager-sa.member
}

resource "google_project_iam_member" "manager-sa-logs" {
  project = var.host_project
  role    = "roles/logging.logWriter"
  member  = google_service_account.manager-sa.member
}

resource "google_project_iam_member" "manager-sa-service-account-user" {
  # checkov:skip=CKV_GCP_49: This is needed to properly execute the manager
  # checkov:skip=CKV_GCP_41: This is needed to properly execute the manager
  project = var.host_project
  role    = "roles/iam.serviceAccountUser"
  member  = google_service_account.manager-sa.member
}

resource "google_project_iam_member" "manager-sa-os-login" {
  project = var.host_project
  role    = "roles/compute.osLogin"
  member  = google_service_account.manager-sa.member
}

resource "google_project_iam_member" "manager-sa-token-creator" {
  # checkov:skip=CKV_GCP_49: This is needed to interact with the gcs bucket (see https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runnerscachegcs-section)
  # checkov:skip=CKV_GCP_41: This is needed to interact with the gcs bucket (see https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runnerscachegcs-section)
  project = var.host_project
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = google_service_account.manager-sa.member
}