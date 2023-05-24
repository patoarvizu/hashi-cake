resource kubernetes_namespace_v1 vault {
  metadata {
    name = "vault"
  }
}

resource kubernetes_namespace_v1 boundary {
  metadata {
    name = "boundary"
  }
}

resource kubernetes_service_v1 vault_ext {
  metadata {
    name = "vault-ext"
    namespace = kubernetes_namespace_v1.vault.metadata[0].name
  }
  spec {
    selector = {
     "app.kubernetes.io/instance" = "vault"
     "app.kubernetes.io/name" = "vault"
     component = "server"
     vault-active = "true"
    }
    port {
      port = 8200
      target_port = 8200
    }
    type = "LoadBalancer"
  }
}