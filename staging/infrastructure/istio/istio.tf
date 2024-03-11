locals {
  istio_charts_url = "https://istio-release.storage.googleapis.com/charts"
}

resource "kubernetes_secret" "istio-gw-ssl-secret" {
  provider = kubernetes.central
  metadata {
    name = "cacerts"
    namespace = kubernetes_namespace.istio-system.metadata.0.name
  }

  data = {
    "tls.crt" = "${path.module}/certs/server.crt"
    "tls.key" = "${path.module}/certs/server.key"
  }

  type = "Opaque"
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
  depends_on = [helm_release.istiod, google_compute_address.istio-ingressgateway-ipv4]
  values = [templatefile("values.yaml", {
    ip = google_compute_address.istio-ingressgateway-ipv4.address
  })]
}
