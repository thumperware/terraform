# Static IPv4 address for Ingress Load Balancing
resource "google_compute_global_address" "ingress-ipv4" {
  name       = "${var.service_name}-gke-ingress-ipv4"
  ip_version = "IPV4"
}
