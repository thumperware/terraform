locals {
  terraform_state = "thumperq-terraform-state"
}

resource "google_storage_bucket" "terraform_state" {
  name          = local.terraform_state
  location      = "US"
  project = var.project_id

  versioning {
    enabled = true
  }
}