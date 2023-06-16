data kubernetes_secret_v1 unseal_keys {
  metadata {
    name = "unseal-keys"
    namespace = "vault"
  }
}

data vault_policy_document boundary_controller {
  rule {
    path = "auth/token/lookup-self"
    capabilities = [ "read" ]
  }
  rule {
    path = "auth/token/renew-self"
    capabilities = [ "update" ]
  }
  rule {
    path = "auth/token/revoke-self"
    capabilities = [ "update" ]
  }
  rule {
    path = "auth/leases/renew"
    capabilities = [ "update" ]
  }
  rule {
    path = "auth/leases/revoke"
    capabilities = [ "update" ]
  }
  rule {
    path = "auth/capabilities-self"
    capabilities = [ "update" ]
  }
  rule {
    path = "sys/leases/revoke"
    capabilities = [ "update" ]
  }
  rule {
    path = "secret/vnc"
    capabilities = [ "read" ]
  }
}