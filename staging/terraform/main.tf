# Vault
provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "gcp_apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "storage.googleapis.com",
    "compute.googleapis.com",
    "cloudkms.googleapis.com"])

  project = var.project_id
  service = each.key

  disable_dependent_services = true
}