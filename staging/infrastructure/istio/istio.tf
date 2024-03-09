locals {
  istio_charts_url = "https://istio-release.storage.googleapis.com/charts"
}

resource "kubernetes_namespace" "istio-system" {
  provider = kubernetes.central
  metadata {
    name = "istio-system"
    labels = {
      istio-injection = "enabled"
      istio-discovery = "enabled"
    }
  }
}

resource "helm_release" "istio-base" {
  provider         = helm.central
  repository       = local.istio_charts_url
  chart            = "base"
  name             = "istio-base"
  namespace        = kubernetes_namespace.istio-system.metadata.0.name
  version          = "1.20.2"
  depends_on       = [kubernetes_namespace.istio-system]
}

resource "helm_release" "istiod" {
  provider         = helm.central
  repository       = local.istio_charts_url
  chart            = "istiod"
  name             = "istiod"
  namespace        = kubernetes_namespace.istio-system.metadata.0.name
  version          = "1.20.2"
  depends_on       = [helm_release.istio-base]
}

resource "google_compute_address" "istio-ingressgateway-ipv4" {
  name       = "istio-ingressgateway-ipv4"
  ip_version = "IPV4"
  region = var.region
  address_type = "EXTERNAL"
}

resource "helm_release" "istio-ingressgateway" {
  provider   = helm.central
  repository = local.istio_charts_url
  chart      = "gateway"
  name       = "istio-ingressgateway"
  namespace  = kubernetes_namespace.istio-system.metadata.0.name
  version    = "1.20.2"
  depends_on = [helm_release.istiod, google_compute_global_address.istio-ingressgateway-ipv4]
  values = [templatefile("values.yaml", {
    ip = google_compute_global_address.istio-ingressgateway-ipv4.address
  })]
}

# resource "null_resource" "istio-load-balancer-ip-patch" {
#   provisioner "local-exec" {
#     command = <<EOH
# cat >/tmp/ca.crt <<EOF
# ${base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)}
# EOF
#   kubectl \
#   --server="https://${data.google_container_cluster.primary.endpoint}" \
#   --token="${data.google_client_config.current.access_token}" \
#   --certificate_authority=/tmp/ca.crt \
#   patch service istio-ingress --patch '{"spec":{"loadBalancerIP": "${google_compute_global_address.istio-ingress-ipv4.address}"}, "status":{"loadBalancer":{"ingress":[{"ip":"${google_compute_global_address.istio-ingress-ipv4.address}"}]}}}' --namespace istio-ingress
# EOH
#   }
#   depends_on = [ helm_release.istio-ingress ]
# }

# resource "null_resource" "istio-load-ingress-loadbalancer-ip-patch" {
#   provisioner "local-exec" {
#     command = <<EOH
# cat >/tmp/ca.crt <<EOF
# ${base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)}
# EOF
#   kubectl \
#   --server="https://${data.google_container_cluster.primary.endpoint}" \
#   --token="${data.google_client_config.current.access_token}" \
#   --certificate_authority=/tmp/ca.crt \
#   patch service istio-ingress --patch '{"status":{"loadBalancer":{"ingress":[{"ip": "${google_compute_global_address.istio-ingress-ipv4.address}" }]}}}' --namespace istio-ingress
# EOH
#   }
#   depends_on = [ helm_release.istio-ingress, null_resource.istio-load-balancer-ip-patch ]
# }