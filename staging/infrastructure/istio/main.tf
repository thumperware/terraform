# istio
provider "google" {
  project = var.project_id
  region  = var.region
}

provider "vault"{
  address = var.vault_address
  token  = var.vault_token
  # Temporary workaround for skipping TLS verification just for testing
  skip_tls_verify = true
}

data "vault_generic_secret" "istio_tls_crt" {
  path = "secrets/staging/terraform/istio_tls_crt"
}

data "vault_generic_secret" "istio_tls_key" {
  path = "secrets/staging/terraform/istio_tls_key"
}

data "google_client_config" "current" {}

data "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.region
}

provider "helm" {
  alias = "central"
  kubernetes {
    host                   = data.google_container_cluster.primary.endpoint
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
    token                  = data.google_client_config.current.access_token
  }
}

provider "kubernetes" {
  alias = "central"
  host                   = data.google_container_cluster.primary.endpoint
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}