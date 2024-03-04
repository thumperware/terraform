# Terraform
provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "gcp_serviceusage_api" {
  project = var.project_id
  service = "serviceusage.googleapis.com"

  disable_dependent_services = true
}
resource "google_project_service" "gcp_apis" {
  for_each = toset([
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "storage.googleapis.com",
    "artifactregistry.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "cloudkms.googleapis.com",
    "container.googleapis.com",
    "sqladmin.googleapis.com"])

  project = var.project_id
  service = each.key

  disable_dependent_services = true

  depends_on = [ google_project_service.gcp_serviceusage_api ]
}