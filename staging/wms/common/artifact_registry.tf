resource "google_artifact_registry_repository" "wms" {
  location      = var.region
  repository_id = "wms"
  description   = "wms docker repository"
  format        = "DOCKER"
}