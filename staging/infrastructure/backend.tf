terraform {
  backend "gcs" {
    bucket = "thumperq-terraform-state"
    prefix = "staging/infrastructure"
  }
}