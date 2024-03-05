# istio
provider "google" {
  project = var.project_id
  region  = var.region
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
  host                   = "https://${var.k8s_cluster_endpoint}"
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}