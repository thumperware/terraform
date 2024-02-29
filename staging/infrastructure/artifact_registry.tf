resource "google_artifact_registry_repository" "artifacts" {
  location      = var.region
  repository_id = "artifacts"
  description   = "docker repository"
  format        = "DOCKER"
}