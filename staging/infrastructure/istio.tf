locals {
  istio_charts_url = "https://istio-release.storage.googleapis.com/charts"
}

resource "kubernetes_namespace" "istio-ingress" {
  metadata {
    name = "istio-ingress"
    labels = {
      istio-injection = "enabled"
      istio-discovery = "enabled"
    }
  }
}

resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio-base" {
  repository       = local.istio_charts_url
  chart            = "base"
  name             = "istio-base"
  namespace        = "istio-system"
  version          = "1.20.2"
  create_namespace = true
}

resource "helm_release" "istiod" {
  repository       = local.istio_charts_url
  chart            = "istiod"
  name             = "istiod"
  namespace        = "istio-system"
  create_namespace = true
  version          = "1.20.2"
  depends_on       = [helm_release.istio-base]
}

resource "helm_release" "istio-ingress" {
  repository = local.istio_charts_url
  chart      = "gateway"
  name       = "istio-ingress"
  namespace  = "istio-ingress"
  version    = "1.20.2"
  depends_on = [helm_release.istiod]
}