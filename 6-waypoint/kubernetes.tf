resource kubernetes_namespace_v1 waypoint {
  metadata {
    name = "waypoint"
  }
}

resource kubernetes_service_v1 waypoint_ext {
  metadata {
    name = "waypoint-ext"
    namespace = kubernetes_namespace_v1.waypoint.metadata[0].name
  }
  spec {
    selector = {
      "app.kubernetes.io/instance" = "waypoint"
      "app.kubernetes.io/name" = "waypoint"
      component = "server"
    }
    port {
      port = 9701
      target_port = "grpc"
      name = "grpc"
    }
    port {
      port = 9702
      target_port = "https"
      name = "https"
    }
    type = "LoadBalancer"
  }
}