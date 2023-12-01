resource "helm_release" "nats_server"{
    name = "nats-server"
    repository = "https://nats-io.github.io/k8s/helm/charts/"
    chart = "nats"
    namespace = "default"
    # values = [
    #     "${file("nats/values.yaml")}"
    # ]
}