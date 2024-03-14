provider "google" {
  project = var.project_id
  region  = var.region
}

provider "vault"{
  address = var.vault_address
  token  = var.vault_token
}

data "vault_generic_secret" "mailbox-pg-username" {
  path = "staging/terraform/wms/mailbox/pg_username"
}

data "vault_generic_secret" "mailbox-pg-password" {
  path = "staging/terraform/wms/mailbox/pg_password"
}

module "mailbox_srv"{
  source="../shared"

  project_id = var.project_id
  region = var.region
  pg_username = data.vault_generic_secret.mailbox-pg-username.data["value"]
  pg_password = data.vault_generic_secret.mailbox-pg-password.data["value"]
  service_name = var.service_name
}