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
  namespace        = kubernetes_namespace.istio_system.metadata.0.name
  version          = "1.20.2"
  create_namespace = true
}

resource "helm_release" "istiod" {
  provider         = helm.central
  repository       = local.istio_charts_url
  chart            = "istiod"
  name             = "istiod"
  namespace        = kubernetes_namespace.istio_system.metadata.0.name
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