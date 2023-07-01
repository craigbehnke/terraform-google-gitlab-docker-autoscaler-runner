resource "google_service_account" "pool-sa" {
  account_id   = "${var.id}-pool-sa"
  display_name = "${var.name} Pool VM Service Account"
  project      = var.host_project
}

resource "google_project_iam_member" "pool-sa-storage" {
  project = var.host_project
  role    = "roles/storage.objectAdmin"
  member  = google_service_account.pool-sa.member
}

resource "google_project_iam_member" "pool-sa-metrics" {
  project = var.host_project
  role    = "roles/monitoring.metricWriter"
  member  = google_service_account.pool-sa.member
}

resource "google_project_iam_member" "pool-sa-logs" {
  project = var.host_project
  role    = "roles/logging.logWriter"
  member  = google_service_account.pool-sa.member
}

resource "google_project_iam_member" "pool-sa-token-creator" {
  # checkov:skip=CKV_GCP_49: This is needed to interact with the gcs bucket (see https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runnerscachegcs-section)
  # checkov:skip=CKV_GCP_41: This is needed to interact with the gcs bucket (see https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runnerscachegcs-section)
  project = var.host_project
  # tfsec:ignore:google-iam-no-project-level-service-account-impersonation
  role   = "roles/iam.serviceAccountTokenCreator"
  member = google_service_account.pool-sa.member
}