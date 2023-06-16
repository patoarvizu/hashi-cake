provider kubernetes {}

provider vault {
  address = "http://localhost:8200"
  token = jsondecode(nonsensitive(data.kubernetes_secret_v1.unseal_keys.data)["unseal-keys"])["root_token"]
  skip_child_token = true
}