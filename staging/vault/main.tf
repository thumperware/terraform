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
}