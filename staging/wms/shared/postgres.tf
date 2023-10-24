data "google_compute_network" "vpc" {
  name = "${var.project_id}-vpc"
}

data "google_compute_global_address" "private_ip_address" {
  name          = "${var.project_id}-private-ip-address"
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = data.google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [data.google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "instance" {
  name             = "${var.service_name}-db"
  database_version = "POSTGRES_14"
  region           = var.region
  deletion_protection = false
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
      private_network = data.google_compute_network.vpc.self_link
      require_ssl = false
    }
  }
  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_user" "users" {
  name     = var.pg_username
  password = var.pg_password
  instance = google_sql_database_instance.instance.name
}