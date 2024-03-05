terraform {
  backend "gcs" {
    bucket = "thumperq-tf-state"
    prefix = "staging/infrastructure/gke"
  }
}