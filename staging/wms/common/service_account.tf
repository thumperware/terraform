resource "google_service_account" "wms-sa" {
  account_id   = "wms-sa"
  display_name = "WMS Service Account"
}

locals {
  wms-sa-roles = [
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
resource "google_project_iam_member" "wms-sa-iam-member" {
  project = var.project_id
  count = length(local.wms-sa-roles)
  role = element(local.wms-sa-roles, count.index)
  member = "serviceAccount:${google_service_account.wms-sa.email}"
}
