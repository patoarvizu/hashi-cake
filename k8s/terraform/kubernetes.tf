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