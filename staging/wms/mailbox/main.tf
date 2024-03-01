# Mailbox
provider "google" {
  project = var.project_id
  region  = var.region
}


module "mailbox_srv"{
  source="../shared"

  project_id = var.project_id
  project_name = var.project_name
  region = var.region
  zone = var.zone
  pg_username = var.pg_username
  pg_password = var.pg_password
  service_name = var.service_name
}