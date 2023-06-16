resource helm_release waypoint {
  name = "waypoint"
  repository = "https://helm.releases.hashicorp.com"
  chart = "waypoint"
  version = "0.1.19"
  namespace = kubernetes_namespace_v1.waypoint.metadata[0].name
  max_history = 3
  values = [
    "${file("values/waypoint.yaml")}"
  ]
}