resource "google_service_account" "sa" {
  account_id   = "infrastructure-sa"
  display_name = "Service Account"
}

locals {
  sa-roles = [
    "roles/artifactregistry.admin",
    "roles/iam.serviceAccountTokenCreator",
    "roles/storage.admin",
    "roles/storage.objectAdmin",
    "roles/cloudsql.client",
    "roles/cloudtrace.agent",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ]
}

# https://cloud.google.com/iam/docs/understanding-roles
resource "google_project_iam_member" "sa-iam-member" {
  project = var.project_id
  count = length(local.sa-roles)
  role = element(local.sa-roles, count.index)
  member = "serviceAccount:${google_service_account.sa.email}"
}
