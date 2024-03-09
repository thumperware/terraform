locals {
  istio_charts_url = "https://istio-release.storage.googleapis.com/charts"
}

resource "kubernetes_namespace" "istio-ingress" {
  provider = kubernetes.central
  metadata {
    name = "istio-ingress"
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
  namespace        = "istio-system"
  version          = "1.20.2"
  create_namespace = true
}

resource "helm_release" "istiod" {
  provider         = helm.central
  repository       = local.istio_charts_url
  chart            = "istiod"
  name             = "istiod"
  namespace        = "istio-system"
  create_namespace = true
  version          = "1.20.2"
  depends_on       = [helm_release.istio-base]
}

resource "helm_release" "istio-ingress" {
  provider   = helm.central
  repository = local.istio_charts_url
  chart      = "gateway"
  name       = "istio-ingress"
  namespace  = kubernetes_namespace.istio-ingress.metadata.0.name
  version    = "1.20.2"
  depends_on = [helm_release.istiod]
}

resource "google_compute_global_address" "istio-ingress-ipv4" {
  name       = "istio-gke-ingress-ipv4"
  ip_version = "IPV4"
}

resource "kubernetes_patch" "istio-ingress-static-ip" {
  kind       = "Service"
  api_version = "v1"
  name       = "istio-ingress"
  namespace  = kubernetes_namespace.istio-ingress.metadata.0.name

  patch = jsonencode({
    spec = {
      loadBalancerIP = google_compute_global_address.istio-ingress-ipv4.address
    }
  })
  depends_on = [ helm_release.istio-ingress, google_compute_global_address.istio-ingress-ipv4 ]
}