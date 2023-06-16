resource helm_release vault {
  name = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart = "vault"
  version = "0.23.0"
  namespace = kubernetes_namespace_v1.vault.metadata[0].name
  max_history = 3
  values = [
    "${file("values/vault.yaml")}"
  ]
}

resource helm_release postgres {
  name = "postgres"
  repository = "https://charts.bitnami.com/bitnami"
  chart = "postgresql"
  version = "12.2.7"
  namespace = kubernetes_namespace_v1.boundary.metadata[0].name
  max_history = 3
  values = [
    "${file("values/postgres.yaml")}"
  ]
}

resource helm_release boundary {
  name = "boundary"
  chart = "./charts/boundary"
  namespace = kubernetes_namespace_v1.boundary.metadata[0].name
  max_history = 3
  depends_on = [
    helm_release.postgres
  ]
}