resource "google_service_account" "wms-sa" {
  account_id   = "wms-sa"
  display_name = "WMS Service Account"
}
# https://cloud.google.com/iam/docs/understanding-roles
resource "google_project_iam_member" "wms-sa-acr-role" {
  project = var.project_id
  role = "roles/artifactregistry.admin"
  member = "serviceAccount:${google_service_account.wms-sa.email}"
}

resource "google_project_iam_member" "wms-sa-token-creator-role" {
  project = var.project_id
  role = "roles/iam.serviceAccountTokenCreator"
  member = "serviceAccount:${google_service_account.wms-sa.email}"
}

resource "google_project_iam_member" "wms-sa-storage-admin-role" {
  project = var.project_id
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.wms-sa.email}"
}

resource "google_project_iam_member" "wms-sa-storage-object-admin-role" {
  project = var.project_id
  role = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.wms-sa.email}"
}

resource "google_project_iam_member" "wms-sa-sql-client-role" {
  project = var.project_id
  role = "roles/cloudsql.client"
  member = "serviceAccount:${google_service_account.wms-sa.email}"
}