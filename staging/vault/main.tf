# Vault
provider "google" {
  project = var.project_id
  region  = var.region
}

module "vault" {
  source         = "terraform-google-modules/vault/google"
  project_id     = var.project_id
  region         = var.region
  kms_keyring    = google_kms_key_ring.vault_keyring.name
  kms_crypto_key = google_kms_crypto_key.vault_crypto_key.name
  depends_on = [ google_project_service.gcp_apis ]
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