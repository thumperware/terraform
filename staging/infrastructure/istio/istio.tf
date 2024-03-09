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

resource "null_resource" "istio-load-balancer-ip-patch" {
  provisioner "local-exec" {
    command = <<EOH
cat >/tmp/ca.crt <<EOF
${base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)}
EOF
  kubectl \
  --server="https://${data.google_container_cluster.primary.endpoint}" \
  --token="${data.google_client_config.current.access_token}" \
  --certificate_authority=/tmp/ca.crt \
  patch service istio-ingress --patch '{"spec":{"loadBalancerIP": "${google_compute_global_address.istio-ingress-ipv4.address}"}, "status":{"loadBalancer":{"ingress":[{"ip":"${google_compute_global_address.istio-ingress-ipv4.address}"}]}}}' --namespace istio-ingress
EOH
  }
  depends_on = [ helm_release.istio-ingress, google_compute_global_address.istio-ingress-ipv4 ]
}

resource "null_resource" "istio-load-ingress-loadbalancer-ip-patch" {
  provisioner "local-exec" {
    command = <<EOH
cat >/tmp/ca.crt <<EOF
${base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)}
EOF
  kubectl \
  --server="https://${data.google_container_cluster.primary.endpoint}" \
  --token="${data.google_client_config.current.access_token}" \
  --certificate_authority=/tmp/ca.crt \
  patch service istio-ingress --patch '{"status":{"loadBalancer":{"ingress":[{"ip": "${google_compute_global_address.istio-ingress-ipv4.address}" }]}}}' --namespace istio-ingress
EOH
  }
  depends_on = [ helm_release.istio-ingress, google_compute_global_address.istio-ingress-ipv4, null_resource.istio-load-balancer-ip-patch ]
}